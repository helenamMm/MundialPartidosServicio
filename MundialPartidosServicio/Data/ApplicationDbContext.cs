using Microsoft.EntityFrameworkCore;

namespace MundialPartidosServicio.Data
{
    public class ApplicationDbContext : DbContext
    {
        public DbSet<Grupo> Grupo { get; set; }
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options): base(options)
        {
        }
    }
}
