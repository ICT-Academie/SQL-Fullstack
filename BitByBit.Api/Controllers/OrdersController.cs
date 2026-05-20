using BitByBit.Api.Dtos.Orders;
using BitByBit.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace BitByBit.Api.Controllers;

[ApiController]
[Route("api/orders")]
public class OrdersController : ControllerBase
{
    private readonly OrderService _service;

    public OrdersController(OrderService service)
    {
        _service = service;
    }

    // POST: /api/orders
    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateOrderRequest request)
    {
        try
        {
            int orderNr = await _service.PlaceOrderAsync(request);
            return Created($"/api/orders/{orderNr}", new { ordernr = orderNr });
        }
        catch (ArgumentException ex)
        {
            return BadRequest(ex.Message);
        }
    }

    // GET: /api/orders/{id}
    [HttpGet("{id:int}")]
    public async Task<IActionResult> Get(int id)
    {
        var details = await _service.GetOrderWithLinesAsync(id);
        if (details == null)
            return NotFound();

        return Ok(details);
    }
}
