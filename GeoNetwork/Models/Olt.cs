namespace GeoNetwork.Models
{
    public class Olt
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;

        public int CentralId { get; set; }
        public Central Central { get; set; } = default!;
    }
}
