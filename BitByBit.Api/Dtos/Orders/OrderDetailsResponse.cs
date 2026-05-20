using BitByBit.Data.Models;

namespace BitByBit.Api.Dtos.Orders;

public class OrderDetailsResponse
{
    public Verkooporders Order { get; set; } = null!;
    public List<Orderregels> Lines { get; set; } = new List<Orderregels>();
}
