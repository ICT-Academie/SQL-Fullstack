using BitByBit.Api.Dtos.Orders;
using BitByBit.Data.Context;
using BitByBit.Data.Models;
using Microsoft.EntityFrameworkCore;
using System.Globalization;

namespace BitByBit.Api.Services;

public class OrderService
{
    private readonly BitByBitDbContext _db;

    public OrderService(BitByBitDbContext db)
    {
        _db = db;
    }

    public async Task<int> PlaceOrderAsync(CreateOrderRequest req)
    {
        // 1) Basis validatie
        if (req == null)
            throw new ArgumentException("Request is leeg.");

        if (req.Items == null || req.Items.Count == 0)
            throw new ArgumentException("Order moet minimaal 1 orderregel hebben.");

        // 2) Klant check
        bool klantBestaat = await _db.Klanten.AnyAsync(k => k.Klantnr == req.Klantnr);
        if (!klantBestaat)
            throw new ArgumentException("Klant bestaat niet.");

        // 3) Productnummers verzamelen
        List<int> productNrs = new List<int>();
        foreach (var item in req.Items)
        {
            if (item.Aantal <= 0)
                throw new ArgumentException("Aantal moet groter dan 0 zijn.");

            if (!productNrs.Contains(item.Productnr))
                productNrs.Add(item.Productnr);
        }

        // 4) Producten ophalen
        List<Producten> producten = await _db.Producten
            .Where(p => productNrs.Contains(p.Productnr))
            .ToListAsync();

        // 5) Bestaat elk product + voorraad check
        foreach (var item in req.Items)
        {
            Producten? product = producten.FirstOrDefault(p => p.Productnr == item.Productnr);
            if (product == null)
                throw new ArgumentException("Product bestaat niet: " + item.Productnr);

            if (product.Voorraad < item.Aantal)
                throw new ArgumentException("Onvoldoende voorraad voor product " + item.Productnr);
        }

        // 6) Transactie
        using var tx = await _db.Database.BeginTransactionAsync();

        // 7) Order aanmaken
        Verkooporders order = new Verkooporders();
        order.Klantnr = req.Klantnr;
        order.Mednr = req.Mednr;
        order.Orderdat = DateOnly.FromDateTime(DateTime.Now);
        order.Weeknr = ISOWeek.GetWeekOfYear(DateTime.Now);
        order.Orderbedrag = 0m;

        _db.Verkooporders.Add(order);
        await _db.SaveChangesAsync(); // ordernr komt beschikbaar

        // 8) Orderregels + voorraad update + totaalbedrag
        decimal totaal = 0m;

        foreach (var item in req.Items)
        {
            Producten product = producten.First(p => p.Productnr == item.Productnr);

            // voorraad verminderen
            product.Voorraad = product.Voorraad - item.Aantal;

            // orderregel toevoegen
            Orderregels regel = new Orderregels();
            regel.Ordernr = order.Ordernr;
            regel.Productnr = item.Productnr;
            regel.Aantal = item.Aantal;

            _db.Orderregels.Add(regel);

            // bedrag berekenen
            totaal = totaal + (product.Prijs * item.Aantal);
        }

        // 9) orderbedrag zetten
        order.Orderbedrag = totaal;

        // 10) opslaan + commit
        await _db.SaveChangesAsync();
        await tx.CommitAsync();

        return order.Ordernr;
    }

    public async Task<OrderDetailsResponse?> GetOrderWithLinesAsync(int orderNr)
    {
        Verkooporders? order = await _db.Verkooporders.FirstOrDefaultAsync(o => o.Ordernr == orderNr);

        if (order == null)
            return null;

        List<Orderregels> regels = await _db.Orderregels
            .Where(r => r.Ordernr == orderNr)
            .ToListAsync();

        OrderDetailsResponse response = new OrderDetailsResponse();
        response.Order = order;
        response.Lines = regels;

        return response;
    }
}
