using Microsoft.EntityFrameworkCore;
using NetTopologySuite.Geometries;
using GeoNetwork.Data;
using GeoNetwork.Models;

namespace GeoNetwork.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Empresa> Empresas { get; set; } = default!;
        public DbSet<Central> Centrales { get; set; } = default!;
        public DbSet<Olt> Olts { get; set; } = default!;
        public DbSet<Odf> Odfs { get; set; } = default!;
        public DbSet<Troncal> Troncales { get; set; } = default!;
        public DbSet<SubTroncal> SubTroncales { get; set; } = default!;
        public DbSet<CajaEmpalme> CajasEmpalme { get; set; } = default!;
        public DbSet<Sangrado> Sangrados { get; set; } = default!;
        public DbSet<SubSangrado> SubSangrados { get; set; } = default!;
        public DbSet<CajaNat> CajasNat { get; set; } = default!;
        public DbSet<SpliterPrincipal> SpliterPrincipales { get; set; } = default!;
        public DbSet<SpliterSecundario> SpliterSecundarios { get; set; } = default!;
        public DbSet<SpliterCliente> SpliterClientes { get; set; } = default!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Configurar precisión de geometría para PostGIS
            modelBuilder.Entity<Troncal>().Property(t => t.Coordenadas).HasColumnType("geometry(Point,4326)");
            modelBuilder.Entity<SubTroncal>().Property(s => s.Coordenadas).HasColumnType("geometry(Point,4326)");
            modelBuilder.Entity<CajaEmpalme>().Property(c => c.Coordenadas).HasColumnType("geometry(Point,4326)");
            modelBuilder.Entity<Sangrado>().Property(s => s.Coordenadas).HasColumnType("geometry(Point,4326)");
            modelBuilder.Entity<SubSangrado>().Property(s => s.Coordenadas).HasColumnType("geometry(Point,4326)");
            modelBuilder.Entity<CajaNat>().Property(c => c.Coordenadas).HasColumnType("geometry(Point,4326)");

            modelBuilder.Entity<Troncal>().ToTable("troncal");
            modelBuilder.Entity<SubTroncal>().ToTable("sub_troncal");
            modelBuilder.Entity<CajaEmpalme>().ToTable("caja_empalme");
            modelBuilder.Entity<Sangrado>().ToTable("sangrado");
            modelBuilder.Entity<SubSangrado>().ToTable("sub_sangrado");
            modelBuilder.Entity<CajaNat>().ToTable("caja_nat");
            modelBuilder.Entity<SpliterPrincipal>().ToTable("spliter_principal");
            modelBuilder.Entity<SpliterSecundario>().ToTable("spliter_secundario");
            modelBuilder.Entity<SpliterCliente>().ToTable("spliter_cliente");

             foreach (var entity in modelBuilder.Model.GetEntityTypes())
            {
                    entity.SetTableName(entity.GetTableName()!.ToLower());
                foreach (var property in entity.GetProperties())
                property.SetColumnName(property.GetColumnName()!.ToLower());
            }
        
        }
    }
}
