using BitByBit.Api.Dtos.Klanten;
using BitByBit.Api.Dtos.Orders;
using BitByBit.Data.Context;
using BitByBit.Data.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Globalization;

namespace BitByBit.Api.Controllers
{
    [ApiController]
    [Route("api/klanten")]
    public class KlantenController : ControllerBase
    {
        private readonly BitByBitDbContext _db;

        public KlantenController(BitByBitDbContext db)
        {
            _db = db;
        }


        // GET: api/klanten
        [HttpGet("klanten")]
        public async Task<IActionResult> GetAll()
        {
            var klanten = await _db.Klanten
                                    .OrderBy(k => k.Naam)
                                    .Take(5)
                                    .Select(k => new KlantListItemDto
                                    {
                                        Klantnr = k.Klantnr,
                                        Naam = k.Naam,
                                        Plaats = k.Plaats
                                    })
                                    .ToListAsync();
            return Ok(klanten);

        }

        // GET: api/facturen
        [HttpGet("facturen")]
        public async Task<IActionResult> GetAllFacturen()
        {
            var klantenMetOpenstaand = await _db.Klanten
                 .Select(k => new
                 {
                     k.Klantnr,
                     k.Naam,
                     OpenstaandBedrag = k.Verkooporders
                         .SelectMany(v => v.Facturen)
                         .Sum(f => f.Bedrag - (f.Betalingen.Sum(b => (decimal?)b.Bedrag) ?? 0))
                 })
                 .Where(k => k.OpenstaandBedrag > 0)
                 .OrderBy(k => k.Naam)
                 .ToListAsync();
            return Ok(klantenMetOpenstaand);

        }

        // POST: /api/orders
        [HttpPost("orders")]
        public async Task<IActionResult> Create([FromBody] CreateOrderRequest request)
        {
            try
            {
                int orderNr = 0;//

                // 1) Basis validatie
                if (request == null)
                    throw new ArgumentException("requestuest is leeg.");

                if (request.Items == null || request.Items.Count == 0)
                    throw new ArgumentException("Order moet minimaal 1 orderregel hebben.");

                // 2) Klant check
                bool klantBestaat = await _db.Klanten.AnyAsync(k => k.Klantnr == request.Klantnr);
                if (!klantBestaat)
                    throw new ArgumentException("Klant bestaat niet.");

                // 3) Productnummers verzamelen
                List<int> productNrs = new List<int>();
                foreach (var item in request.Items)
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
                foreach (var item in request.Items)
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
                order.Klantnr = request.Klantnr;
                order.Mednr = request.Mednr;
                order.Orderdat = DateOnly.FromDateTime(DateTime.Now);
                order.Weeknr = ISOWeek.GetWeekOfYear(DateTime.Now);
                order.Orderbedrag = 0m;

                _db.Verkooporders.Add(order);
                await _db.SaveChangesAsync(); // ordernr komt beschikbaar

                // 8) Orderregels + voorraad update + totaalbedrag
                decimal totaal = 0m;

                foreach (var item in request.Items)
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




                return Created($"/api/klantens/{orderNr}", new { ordernr = order.Ordernr });
            }
            catch (ArgumentException ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
