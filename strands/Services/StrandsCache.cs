using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using strands.Models;

namespace strands.Services
{
    public class StrandsCache
    {
        public static bool Contains(Strand Strand)
        {
            if (!Strand.Name.StartsWith("Theme"))
            {
                string browserTag = strands.Services.FeatureDetection.MathMLSupport() ? "FF" : "";
                string cachePath = HttpContext.Current.Server.MapPath(HttpRuntime.AppDomainAppVirtualPath + "/App_Data/Cache/" + Strand.Name + Strand.ActualSection.Name + browserTag + ".txt");

                if (!System.IO.File.Exists(cachePath))
                {
                    return false;
                }
                else
                {
                    DateTime dtXml = System.IO.File.GetLastWriteTimeUtc(Strand.GetDirectoryPath());
                    DateTime dtCache = System.IO.File.GetLastWriteTimeUtc(cachePath);

                    if (dtXml.CompareTo(dtCache) == -1)
                        return true;
                    else
                        return false;
                }
            }
            else
                return false;
        }

        public static string Read(Strand Strand)
        {
            string browserTag = strands.Services.FeatureDetection.MathMLSupport() ? "FF" : ""; 
            //string browserTag = HttpContext.Current.Request.Browser.Browser == "Firefox" ? "FF" : "";
            string cachePath = HttpContext.Current.Server.MapPath(HttpRuntime.AppDomainAppVirtualPath + "/App_Data/Cache/" + Strand.Name + Strand.ActualSection.Name + browserTag + ".txt");

            return System.IO.File.ReadAllText(cachePath);
        }

        public static string Write(Strand Strand, string HtmlString)
        {
            if (!Strand.Name.StartsWith("Theme"))
            {
                string browserTag = strands.Services.FeatureDetection.MathMLSupport() ? "FF" : ""; 
                //string browserTag = HttpContext.Current.Request.Browser.Browser == "Firefox" ? "FF" : "";
                string cachePath = HttpContext.Current.Server.MapPath(HttpRuntime.AppDomainAppVirtualPath + "/App_Data/Cache/" + Strand.Name + Strand.ActualSection.Name + browserTag + ".txt");

                System.IO.File.WriteAllText(cachePath, HtmlString);
            }
            return HtmlString;
        }
    }
}