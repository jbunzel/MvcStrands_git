using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace strands
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            config.Routes.MapHttpRoute(
                name: "SearchApi",
                routeTemplate: "search-api/{searchterm}",
                defaults: new { controller = "searchapi", searchterm = RouteParameter.Optional }
            );
            
            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{strand}/{section}/{element}",
                defaults: new { controller = "values", strand = RouteParameter.Optional, section = RouteParameter.Optional, element = RouteParameter.Optional }
            );
        }
    }
}
