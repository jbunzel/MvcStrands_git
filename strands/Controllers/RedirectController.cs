using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace strands.Controllers
{
    public class RedirectController : Controller
    {
        //
        // GET: /Redirect/

        public ActionResult Index()
        {
            string t = System.Web.HttpContext.Current.Request.Params["tabid"]; 
            string l = System.Web.HttpContext.Current.Request.Params["L"];
            string s = System.Web.HttpContext.Current.Request.Params["S"];
            string strand = "";
            string section = "";

            if (!string.IsNullOrEmpty(l) && l.Contains("/")) l = l.Substring(0, l.IndexOf("/"));
            strand = string.IsNullOrEmpty(t) ? l : "Themes";
            section = string.IsNullOrEmpty(t) ? s : t;
            return RedirectToAction("Index","Home", new System.Web.Routing.RouteValueDictionary(new {Strand = strand, Section =  section, Element = ""}));
        }
    }
}
