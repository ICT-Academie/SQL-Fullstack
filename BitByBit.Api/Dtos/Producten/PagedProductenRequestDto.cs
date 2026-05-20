using System.ComponentModel.DataAnnotations;

namespace BitByBit.Api.Dtos.Producten;

public class PagedProductenRequestDto
{
    private const int DefaultPage = 1;
    private const int DefaultPageSize = 5;
    private const int MaxPageSize = 50;

    [Range(1, int.MaxValue)]
    public int Page { get; set; } = DefaultPage;

    [Range(1, MaxPageSize)]
    public int PageSize { get; set; } = DefaultPageSize;

    public int Skip => (Page - 1) * PageSize;
}