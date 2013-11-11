using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using strands.Models;
using RQLucene.RQLucene;

namespace strands.Services
{
    public class LuceneSearchService
    {
        private System.Xml.XmlNodeList _indexConfigNodes;
        private string _searchterm;

        public List<SearchResult> ResultList { get; set; }

        private void IndexFiles()
        {
            try
            {
                for (int i = 0; i <= this._indexConfigNodes.Count - 1; i++)
                {
                    string indexType = this._indexConfigNodes[i].SelectSingleNode("@indexType").Value;
                    Indexer indexer;

                    if (indexType == "XMLIndexer")
                        indexer = new XMLIndexer(this._indexConfigNodes[i]);
                    else
                        indexer = new OleDBIndexer(this._indexConfigNodes[i]);
                    indexer.Generate();
                }
                this.ResultList = new List<SearchResult>(1);
                this.ResultList.Add(new SearchResult("", "Indexierung abgeschlossen.", ""));
            }
            catch (Exception ex)
            {
                throw new Exception("Error on Indexing", ex);
            }
        }
        
        private void SearchIndex()
        {
            if (this._searchterm.Length > 0)
            {
                try
                {
                    Searcher sr = new Searcher(this._indexConfigNodes[0]);
                    sr.search(this._searchterm, 0);
                    if (sr.ResultTable.Rows.Count > 0)
                    {
                        this.ResultList = new List<SearchResult>(sr.ResultTable.Rows.Count);
                        for (int i = 0; i < sr.ResultTable.Rows.Count; i++)
                        {
                            SearchResult result = new SearchResult(sr.ResultTable.Rows[i][0].ToString(), sr.ResultTable.Rows[i][1].ToString(), sr.ResultTable.Rows[i][2].ToString());

                            try
                            {
                                DateTime dateStr = DateTime.Parse(sr.ResultTable.Rows[i][0].ToString());

                                result.SortField = dateStr.Date.Year.ToString().Substring(2) + dateStr.Month.ToString("d2") + dateStr.Day.ToString("d2");
                            }
                            catch
                            {
                                result.SortField = result.Title;
                            }
                            this.ResultList.Add(result);
                        }
                        this.ResultList = ResultList.OrderBy(o => o.SortField).ToList();
                    }
                }
                catch { }
            }
        }

        public LuceneSearchService(string Searchterm) {
            System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
            string xpath = "[@name='MyArticles']";

            this._searchterm = Searchterm;
            doc.Load(HttpRuntime.AppDomainAppPath + "/App_Data/xml/indexConfig.xml");
            this._indexConfigNodes = doc.SelectNodes("/indexConfiguration/*" + xpath);
            if (Searchterm.StartsWith("§§INDEX§§")) this.IndexFiles(); else this.SearchIndex();
        }

        public static string Normalize(string SearchTerm)
        {
            return SearchTerm.Replace("$", "*");
        }
    }
}