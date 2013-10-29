using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace strands.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index( string Strand, string Section, string Element)
        {
            string view = "Index";
            string type = (Element != null) ? Element.Contains("$$") ? Element.Substring(Element.IndexOf("$$") + 2) : "strands" : "strands";

            ViewBag.Strand = (Strand != null) ? Strand : "Themes";
            ViewBag.Section = (Section != null) ? Section : "";
            ViewBag.Element = (Element != null) ? Element : "";
            ViewBag.Type = ((string)ViewBag.Strand == "Themes") ? "Themes" : type;
            ViewBag.Title = "The Strands - " + ((ViewBag.Strand == "Themes")||(ViewBag.Strand == "Search") ? (ViewBag.Section != "" ? ViewBag.Section : "Home") : ViewBag.Strand);
            return View(view, ((string)ViewBag.Type == "Themes" || (string)ViewBag.Type == "strands") ? "_Layout" : "_BoxLayout");
        }
    }
}
