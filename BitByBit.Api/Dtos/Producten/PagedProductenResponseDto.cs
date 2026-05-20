namespace BitByBit.Api.Dtos.Producten;

public class PagedProductenResponseDto
{
    public int Page { get; set; }
    public int PageSize { get; set; }
    public int TotalItems { get; set; }
    public int TotalPages { get; set; }
    public List<ProductListItemDto> Items { get; set; } = new();
}