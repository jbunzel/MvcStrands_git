using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

using strands.Services;

namespace strands.Controllers
{
    public class ValuesController : ApiController
    {
        private StrandsRepository repository;

        private Exception Parse(Exception ex, string Strand, string Section, string Element)
        {
            if (Strand.Contains("_TB"))
            {
                DateTime date = new DateTime(int.Parse(Strand.Substring(0, 2)), int.Parse(Strand.Substring(2, 2)), int.Parse(Section));
                string uri = "http://de.wikipedia.org/wiki/" + date.ToString("dd._MMMM");
                ex = new Exception("REDIRECT=>" + uri, ex.InnerException);
            }
            return ex;
        }

        private Exception ErrorHandler(Exception ex)
        {
            var resp = new HttpResponseMessage(HttpStatusCode.NotFound)
            {
                Content = new StringContent(ex.Message),
                ReasonPhrase = ex.InnerException.Message
            };
            throw new HttpResponseException(resp);
        }

        public ValuesController()
        {
            repository = new StrandsRepository(); 
        }
        
        // GET api/values
        public string Get()
        {
            return this.Get("Themes", "Home", "");
        }

        // GET api/values/5
        public string Get(string Strand)
        {
           return this.Get(Strand, "1", "");
        }

        // GET api/values/5
        public string Get(string Strand, string Section)
        {
            return this.Get(Strand, Section, "");
        }

        // GET api/values/5
        public string Get(string Strand, string Section, string Element)
        {
            Services.StrandsCache.EnableStrandsChache(true);
            try
            {
                return repository.Lookup(Strand, Section, Element).HTML;
            }
            catch (Exception ex)
            {
                ErrorHandler(Parse(ex, Strand, Section, Element));
                return "";
            }
        }

        // POST api/values
        public void Post([FromBody]string value)
        {
        }

        // PUT api/values/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/values/5
        public void Delete(int id)
        {
        }
    }
}