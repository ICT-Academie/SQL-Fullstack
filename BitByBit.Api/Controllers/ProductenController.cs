using BitByBit.Api.Dtos.Producten;
using BitByBit.Data;
using BitByBit.Data.Context;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BitByBit.Api.Controllers;

[ApiController]
[Route("api/producten")]
public class ProductenController : ControllerBase
{
    private readonly BitByBitDbContext _db;

    public ProductenController(BitByBitDbContext db)
    {
        _db = db;
    }

    [HttpGet("paged")]
    public async Task<ActionResult<PagedProductenResponseDto>> GetPagedProducten(
        [FromQuery] PagedProductenRequestDto request)
    {
        var query = _db.Producten
            
            .OrderByDescending(product => product.Prijs);

        var totalItems = await query.CountAsync();

        var producten = await query
            .Skip(request.Skip)
            .Take(request.PageSize)
            .Select(product => new ProductListItemDto
            {
                Productnr = product.Productnr,
                Naam = product.Omschrijving,
                Prijs = product.Prijs
            })
            .ToListAsync();

        var response = new PagedProductenResponseDto
        {
            Page = request.Page,
            PageSize = request.PageSize,
            TotalItems = totalItems,
            TotalPages = (int)Math.Ceiling(totalItems / (double)request.PageSize),
            Items = producten
        };

        return Ok(response);
    }
}