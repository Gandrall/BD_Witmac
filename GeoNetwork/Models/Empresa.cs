using System.Collections.Generic;

namespace GeoNetwork.Models
{
    public class Empresa
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;

        public ICollection<Central> Centrales { get; set; } = new List<Central>();
    }
}
