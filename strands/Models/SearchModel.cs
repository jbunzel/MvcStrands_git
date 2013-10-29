using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using strands.Services;

namespace strands.Models
{
    public class SearchResults
    {
        public List<SearchResult> ResultList { get; set; }
 
        public SearchResults(string Searchterm)
        {
            this.ResultList = new LuceneSearchService(Searchterm).ResultList;
        }
    }

    public class SearchResult
    {
        public string Title {get; set;}
        public string Section { get; set; }
        public string Adress { get; set; }

        public SearchResult(string Title, string Section, string Adress) 
        {
            this.Title = Title;
            this.Section = Section;
            this.Adress = Adress;
        }
    }
}