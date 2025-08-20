using NetTopologySuite.Geometries;

namespace GeoNetwork.Models
{
    public class Troncal
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string? Tipo { get; set; } 

        public Point Coordenadas { get; set; } = default!;

    }
}
