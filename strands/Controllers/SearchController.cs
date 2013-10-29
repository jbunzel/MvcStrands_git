using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace strands.Controllers
{
    public class SearchController : Controller
    {
        //
        // GET: /Search/
        public ActionResult Index(string Searchterm)
        {
            ViewBag.Searchterm = Searchterm;
            ViewBag.Title = "The Strands - Search";
            ViewBag.Type = "search";
            return View("Search", "_BoxLayout");
        }

    }
}
