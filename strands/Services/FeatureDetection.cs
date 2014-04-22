using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace strands.Services
{
    public class FeatureDetection
    {
        public static bool MathMLSupport()
        {
            if (HttpContext.Current.Request.Cookies["_clientInfo"] != null)
            {
                string val = HttpContext.Current.Server.UrlDecode(HttpContext.Current.Request.Cookies["_clientInfo"].Value.ToString());
                var res = Newtonsoft.Json.JsonConvert.DeserializeObject<dynamic>(val);

                return res.MathMLSupport == true;
            }
            else
                return false;
        }
    }
}