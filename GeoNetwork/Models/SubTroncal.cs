using NetTopologySuite.Geometries;

namespace GeoNetwork.Models
{
    public class SubTroncal
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;

        public Point Coordenadas { get; set; } = default!;
    }
}
