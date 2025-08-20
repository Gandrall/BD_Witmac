using NetTopologySuite.Geometries;

namespace GeoNetwork.Models
{
    public class SubSangrado
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;

        public Point Coordenadas { get; set; } = default!;
    }
}
