using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace strands
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.Add(new LegacyUrlRoute());

            routes.MapRoute(
                name: "Search",
                url: "search/{searchterm}",
                defaults: new { controller = "Search", action = "Index", searchterm = UrlParameter.Optional }
            );

            routes.MapRoute(
                name: "Default",
                url: "{strand}/{section}/{element}",
                defaults: new { controller = "Home", action = "Index", strand = UrlParameter.Optional, section = UrlParameter.Optional, element = UrlParameter.Optional }
            );
        }
    }

    public class LegacyUrlRoute : RouteBase
    {
        public override RouteData GetRouteData(HttpContextBase httpContext)
        {
            var request = httpContext.Request;
            var legacyUrl = request.Url.ToString();
            var newUrl = "";

            if (legacyUrl.ToLower().Contains("default.aspx") || legacyUrl.Contains("?"))
            {
                //const string status = "301 Moved Permanently";
                string t = string.IsNullOrEmpty(request.QueryString["tabid"]) ? request.QueryString["amp;tabid"] : request.QueryString["tabid"];
                string l = string.IsNullOrEmpty(request.QueryString["L"]) ? request.QueryString["amp;L"] : request.QueryString["L"];
                string s = string.IsNullOrEmpty(request.QueryString["S"]) ? request.QueryString["amp;S"] : request.QueryString["S"]; 
                string strand = "";
                string section = "";
                var response = httpContext.Response;

                l = (!string.IsNullOrEmpty(l) && l.Contains("/")) ? l.Substring(0, l.IndexOf("/")) : l;
                if (!string.IsNullOrEmpty(l))
                {
                    strand = string.IsNullOrEmpty(t) ? l : "Themes";
                    section = string.IsNullOrEmpty(t) ? (string.IsNullOrEmpty(s) ? "/1" : "/" + s) : "/" + t;
                    newUrl = System.Text.RegularExpressions.Regex.Replace((strand + section), @"[^\u0000-\u007F]", string.Empty);
                }
                else
                    newUrl = "http://" + HttpContext.Current.Request.ServerVariables["HTTP_HOST"] + HttpRuntime.AppDomainAppVirtualPath;
                response.Redirect(newUrl, true);
            }
            return null;
        }

        public override VirtualPathData GetVirtualPath(RequestContext requestContext, RouteValueDictionary values)
        {
            return null;
        }
    }
}