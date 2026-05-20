using BitByBit.Data.Context;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BitByBit.Api.Controllers;

[ApiController]
[Route("api/rapport")]
public class RapportController : ControllerBase
{
    private readonly BitByBitDbContext _db;

    public RapportController(BitByBitDbContext db)
    {
        _db = db;
    }

    // GET: /api/rapport/klanten
    [HttpGet("klanten")]
    public async Task<IActionResult> GetKlantenRapport()
    {
        var rows = await _db.ViewKlantenOrdersSamenvatting
            .AsNoTracking()
            .OrderBy(r => r.Plaats)
            .ThenBy(r => r.Naam)
            .ToListAsync();

        return Ok(rows);
    }
}
