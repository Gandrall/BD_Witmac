using NetTopologySuite.Geometries;
using System.Collections.Generic;

namespace GeoNetwork.Models
{
    public class Central
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;

        public int EmpresaId { get; set; }
        public Empresa Empresa { get; set; } = default!;

        public Point Coordenadas { get; set; } = default!;

        public ICollection<Olt> Olts { get; set; } = new List<Olt>();
    }
}
