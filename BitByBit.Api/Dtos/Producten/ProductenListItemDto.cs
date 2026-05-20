namespace BitByBit.Api.Dtos.Producten;

public class ProductListItemDto
{
    public int Productnr { get; set; }
    public string Naam { get; set; } = string.Empty;
    public decimal Prijs { get; set; }
}