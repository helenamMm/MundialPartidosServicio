using MundialPartidosServicio;
using MundialPartidosServicio.Data; 
using Microsoft.EntityFrameworkCore; 
//using Pomelo.EntityFrameworkCore.MySql.Infrastructure; This contains MySqlServerVersion

var builder = Host.CreateApplicationBuilder(args);

builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseMySql(
        builder.Configuration.GetConnectionString("DefaultConnection"),
        ServerVersion.AutoDetect(builder.Configuration.GetConnectionString("DefaultConnection")) // <<< CHANGE THIS TO YOUR MYSQL SERVER VERSION
    ));
builder.Services.AddHostedService<Worker>();

var host = builder.Build();
host.Run();