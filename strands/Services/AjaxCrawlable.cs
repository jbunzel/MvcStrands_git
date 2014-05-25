using System;
using System.Web.Mvc;

namespace strands.Services
{
    public class AjaxCrawlable : ActionFilterAttribute
    {
        public static string Fragment = "_escaped_fragment_";

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            var request = filterContext.HttpContext.Request;

            if (request.QueryString[Fragment] == null)
            {
                return;
            }
            else
            {
                var strand = filterContext.ActionParameters["Strand"] != null ? filterContext.ActionParameters["Strand"].ToString() : "";
                var section = filterContext.ActionParameters["Section"] != null ? filterContext.ActionParameters["Section"].ToString() : "";
                var element = filterContext.ActionParameters["Element"] != null ? filterContext.ActionParameters["Element"].ToString() : "";
                var strandDoc = new StrandsRepository().Lookup(strand, section, element); 
 
                filterContext.Controller.ViewBag.AjaxCrawlerSnapshot = MvcHtmlString.Create(strandDoc.HTML);
                filterContext.Controller.ViewBag.Title = strandDoc.GetDocElement("Title");
                filterContext.Controller.ViewBag.Description = strandDoc.GetDocElement("Description");
            }
        }
    }
}