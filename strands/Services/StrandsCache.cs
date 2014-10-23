using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using strands.Models;

namespace strands.Services
{
    public class StrandsCache
    {
        private static bool _enabled = true;

        private static string GetCachePath(Strand Strand)
        {
            string sectionName = (Strand.ActualSection != null) ? Strand.ActualSection.Name : "";
            string elementName = (Strand.ActualSection != null && Strand.ActualSection.ActualElement != null) ? Strand.ActualSection.ActualElement.Name : "";
            string browserTag = strands.Services.FeatureDetection.MathMLSupport() ? "FF" : "";

            return HttpContext.Current.Server.MapPath(HttpRuntime.AppDomainAppVirtualPath + "/App_Data/Cache/" + Strand.Name + sectionName + elementName + browserTag + ".txt");
        }
        
        public static bool Contains(Strand Strand)
        {
            if (_enabled && !Strand.Name.StartsWith("Theme"))
            {
                string cachePath = StrandsCache.GetCachePath(Strand);
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
            if (!_enabled)
                return "";
            else
            {
                string cachePath = StrandsCache.GetCachePath(Strand);

                return System.IO.File.ReadAllText(cachePath);
            }
        }

        public static string Write(Strand Strand, string HtmlString)
        {
            if (_enabled && !Strand.Name.StartsWith("Theme"))
            {
                string cachePath = StrandsCache.GetCachePath(Strand);
                System.IO.File.WriteAllText(cachePath, HtmlString);
            }
            return HtmlString;
        }

        public static void EnableStrandsChache(bool value)
        {
            _enabled = value;
        }
    }
}