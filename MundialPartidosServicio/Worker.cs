using MundialPartidosServicio.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace MundialPartidosServicio;

public class Worker : BackgroundService
{
    private readonly ILogger<Worker> _logger;
    private readonly IServiceProvider _serviceProvider; // Add this


    public Worker(ILogger<Worker> logger,  IServiceProvider serviceProvider)
    {
        _logger = logger;
        _serviceProvider = serviceProvider;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            if (_logger.IsEnabled(LogLevel.Information))
            {
                _logger.LogInformation("Worker running at: {time}", DateTimeOffset.Now);
            }

            try
            {
                using (var scope = _serviceProvider.CreateScope())
                {
                    // Get the DbContext from the scope
                    var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();

                    // QUERY YOUR DATABASE HERE
                    await QueryGruposAsync(dbContext, stoppingToken);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error ocurred while quering database");
            }
            await Task.Delay(1000, stoppingToken);
        }
    } 
    private async Task QueryGruposAsync(ApplicationDbContext dbContext, CancellationToken stoppingToken)
    {
        
        var allGrupos = await dbContext.Grupo.ToListAsync(stoppingToken);
        _logger.LogInformation("Found {Count} grupos in database", allGrupos.Count);
        
        foreach (var grupo in allGrupos)
        {
            _logger.LogInformation("Grupo ID: {Id}, Letra: {Letra}, Fecha Creación: {Fecha}",
                grupo.Id, grupo.LetraGrupo, grupo.FechaCreacion);
        }
    }
}