using BitByBit.Api.Services;
using BitByBit.Data.Context;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<BitByBitDbContext>(options =>
{
    string cs = builder.Configuration.GetConnectionString("BitByBit")!;
    options.UseMySql(cs, ServerVersion.AutoDetect(cs));
    options.UseQueryTrackingBehavior(QueryTrackingBehavior.NoTracking);
});

builder.Services.AddScoped<OrderService>();

var app = builder.Build();
app.MapGet("/", () => "BitByBit API draait");
app.UseSwagger();
app.UseSwaggerUI();
app.UseStaticFiles();
app.MapControllers();

app.Run();
