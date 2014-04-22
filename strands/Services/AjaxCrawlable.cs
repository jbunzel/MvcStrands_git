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
                var repository = new StrandsRepository();
                var strand = filterContext.ActionParameters["Strand"] != null ? filterContext.ActionParameters["Strand"].ToString() : "";
                var section = filterContext.ActionParameters["Section"] != null ? filterContext.ActionParameters["Section"].ToString() : "";
                var element = filterContext.ActionParameters["Element"] != null ? filterContext.ActionParameters["Element"].ToString() : "";
                              
                filterContext.Controller.ViewBag.AjaxCrawlerSnapshot = MvcHtmlString.Create(repository.Lookup(strand, section, element));
            }
        }
    }
}