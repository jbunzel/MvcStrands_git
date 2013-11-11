using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Mvc;

using strands.Models;
using strands.Services;

namespace strands.Controllers
{
    public class SearchApiController : ApiController
    {
        // GET api/values
        public List<SearchResult> Get()
        {
            return Get("");
        }

        // GET api/values/5
        public List<SearchResult> Get(string searchterm)
        {
            var result = new SearchResults(LuceneSearchService.Normalize(searchterm)).ResultList;

            if (result != null)
                return result;
            else
                throw new Exception("Der Suchbegriff ist in keinem Strand enthalten."); 
        }
    }
}
