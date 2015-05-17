using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Xml.XPath;

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
                name: "About",
                url: "about/{section}",
                defaults: new { controller = "Home", action = "About", section = UrlParameter.Optional }
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
            if (strands.Services.Settings.CheckLegacyRoutes == true)
            {
                var request = httpContext.Request;
                var response = httpContext.Response;
                var legacyUrl = request.Url.ToString();
                string urlPrefix = "http://" + HttpContext.Current.Request.ServerVariables["HTTP_HOST"] + HttpRuntime.AppDomainAppVirtualPath;
                string newUrl = "";
                string testUrl = "";
                string testUrlPostfix = "";
                XPathNavigator config = null;
                XPathNavigator node = null;

                if (request.QueryString.Get(strands.Services.AjaxCrawlable.Fragment) != null) return null;
                if (legacyUrl.ToLower().Contains("default.aspx") || legacyUrl.Contains("?"))
                {
                    //const string status = "301 Moved Permanently";
                    string t = string.IsNullOrEmpty(request.QueryString["tabid"]) ? request.QueryString["amp;tabid"] : request.QueryString["tabid"];
                    string l = string.IsNullOrEmpty(request.QueryString["L"]) ? request.QueryString["amp;L"] : request.QueryString["L"];
                    string s = string.IsNullOrEmpty(request.QueryString["S"]) ? request.QueryString["amp;S"] : request.QueryString["S"];
                    string strand = "";
                    string section = "";

                    l = (!string.IsNullOrEmpty(l) && l.Contains("/")) ? l.Substring(0, l.IndexOf("/")) : l;
                    if (!string.IsNullOrEmpty(l))
                    {
                        strand = string.IsNullOrEmpty(t) ? l : "Themes";
                        section = string.IsNullOrEmpty(t) ? (string.IsNullOrEmpty(s) ? "/1" : "/" + s) : "/" + t;
                        newUrl = System.Text.RegularExpressions.Regex.Replace((strand + section), @"[^\u0000-\u007F]", string.Empty);
                    }
                    else
                        newUrl = urlPrefix;
                }
                testUrl = (string.IsNullOrEmpty(newUrl)) ? legacyUrl.Replace(urlPrefix + "/", "") : newUrl.Replace(urlPrefix + "/", "");
                try
                {
                    config = new XPathDocument(HttpContext.Current.Server.MapPath(HttpRuntime.AppDomainAppVirtualPath + "/App_Data/xml/StrandsConfig.xml")).CreateNavigator();
                }
                catch (Exception ex)
                {
                    throw new Exception(ex.Message, ex.InnerException);
                }
                while (!string.IsNullOrEmpty(testUrl))
                {
                    node = config.SelectSingleNode("/configuration/legacy-routes/route[@old='" + testUrl + "']");
                    if (node != null)
                    {
                        node.MoveToAttribute("new", "");
                        newUrl = urlPrefix + "/" + node.InnerXml + testUrlPostfix;
                        break;
                    }
                    if (testUrl.Contains("/"))
                    {
                        testUrlPostfix = testUrl.Substring(testUrl.LastIndexOf("/"));
                        testUrl = testUrl.Substring(0, testUrl.LastIndexOf("/"));
                    }
                    else
                        testUrl = "";
                }
                if (newUrl != "")
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