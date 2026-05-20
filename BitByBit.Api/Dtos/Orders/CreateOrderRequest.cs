namespace BitByBit.Api.Dtos.Orders;

public class CreateOrderRequest
{
    public int Klantnr { get; set; }
    public int Mednr { get; set; }
    public List<CreateOrderItem> Items { get; set; } = new List<CreateOrderItem>();
}

public class CreateOrderItem
{
    public int Productnr { get; set; }
    public int Aantal { get; set; }
}
