using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NetTopologySuite.Features;
using NetTopologySuite.Geometries;
using NetTopologySuite.IO;
using GeoNetwork.Data;
using GeoNetwork.Models;

namespace GeoNetwork.Controllers
{
    public class MapController : Controller
    {
        private readonly AppDbContext _context;

        public MapController(AppDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var troncales = await _context.Troncales.ToListAsync();

            var features = troncales.Select(t => new Feature(t.Coordenadas, new AttributesTable
            {
                { "Nombre", t.Nombre },
                { "Tipo", t.Tipo }
            })).ToList();

            var featureCollection = new FeatureCollection();
            features.ForEach(f => featureCollection.Add(f));

            var geoJsonWriter = new GeoJsonWriter();
            ViewBag.GeoJson = geoJsonWriter.Write(featureCollection);

            return View();
        }
    }
}
