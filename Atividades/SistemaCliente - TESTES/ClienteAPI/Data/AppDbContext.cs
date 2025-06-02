using Microsoft.EntityFrameworkCore;
using ClienteAPI.Models;

namespace ClienteAPI.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<Cliente> Clientes { get; set; }
    public DbSet<CargoOcupado> CargosOcupados { get; set; }
    public DbSet<Dependente> Dependentes { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Cliente>()
            .HasIndex(c => c.Matricula)
            .IsUnique();
            
        modelBuilder.Entity<Cliente>()
            .HasIndex(c => c.CPF)
            .IsUnique();
    }
}