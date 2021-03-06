﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml.XPath;

namespace strands.Models
{
    public class StrandsModel
    {
        #region private members

        public static string _xmlAppDir = HttpRuntime.AppDomainAppVirtualPath + "/App_Data/xml/";
        public static string _themesXmlName = "strandlist.xml";
        public static string _articleBase = System.Web.VirtualPathUtility.ToAbsolute("~/MyArticles") + "/";

        #endregion

        #region public properties

        public StrandsGraph Strands { get; set; }
        public static string BaseUrl 
        {
            get
            {
                return StrandsModel._articleBase;
            }
        }

        public static string CrossBaseUri 
        { 
            get 
            {
                return StrandsModel.BaseUrl.Contains("://") ? StrandsModel.BaseUrl : HttpContext.Current.Server.MapPath(StrandsModel.BaseUrl);
            }
        }
        public Strand ActualStrand { get; set; }

        #endregion

        #region public constructors

        public StrandsModel() 
        {
            this.Strands = new StrandsGraph();
            //this.BaseUrl = StrandsModel._articleBase;
            //if (this.BaseUrl.Contains("://"))
            //    this.CrossBaseUri = this.BaseUrl;
            //else
            //    this.CrossBaseUri = HttpContext.Current.Server.MapPath(this.BaseUrl);
            this.ActualStrand = null;
        }

        #endregion

        #region public methods
        
        public Strand Select(string StrandName)
        {
            if (!Strands.ContainsKey(StrandName))
                Strands.Add(StrandName, new Strand(StrandName));
            if (Strands.ContainsKey(StrandName))
                this.ActualStrand = Strands[StrandName];
            return this.ActualStrand;
        }

        public Strand Select(string StrandName, string SectionName, string ElementName)
        {
            Strand st = this.Select(StrandName);

            st.Select(SectionName, ElementName);
            return st;
        }

        #endregion
    }

    public class StrandsGraph : System.Collections.Generic.Dictionary<string,Strand>
    {
        #region public constructors

        public StrandsGraph() { }

        #endregion
    }

    public class Strand
    {
        #region private members

        private static string _strandsXslName = "strands.xsl";
        private static string _themesXslName = "strandlist.xsl";
        private static string _defaultXslName = "jbarticle.xsl";

        #endregion

        #region private methods

        private string GetUri()
        {
            try 
            {
                string u = StrandsModel._articleBase + this.Name;
                var di = new System.IO.DirectoryInfo(HttpContext.Current.Server.MapPath(u));

                System.IO.FileInfo[] fi = di.GetFiles("*.xml");

                return u + "/" + fi[0].Name;
            } 
            catch (Exception ex)
            {
                string msg = "Unknown Error.";

                switch (ex.GetType().Name)
                {
                    case "DirectoryNotFoundException":
                        msg = "Strand directory not found.";
                        break;
                    case "IndexOutOfRangeException":
                        msg = "Strand file not found.";
                        break;
                    default:
                        break;
                }
                throw new Exception(msg, ex);
            }
        }
        
        #endregion

        #region public properties

        public string Uri { get; set; }
        public string Name { get; set; } 
        public string XslName { get; set; }
        public SectionList Sections {get; set; }
        public StrandSection ActualSection { get; set; }
 
        #endregion
        
        #region public constructors

        public Strand() 
        { 
            this.Sections = new SectionList();
            this.Uri = "";
            this.ActualSection = null;
            this.Name = "";
        }

        public Strand(Strand theStrand)
        {
            this.Uri = theStrand.Uri;
            this.Name = theStrand.Name;
            this.XslName = theStrand.XslName;
            this.Sections = theStrand.Sections;
            this.ActualSection = theStrand.ActualSection;
        }

        public Strand (string StrandName)
            :this()
        {
            this.Name = StrandName.ToLower();
            switch (this.Name)
            {
                case "themes":
                this.Uri = StrandsModel._xmlAppDir + StrandsModel._themesXmlName;
                    this.XslName = Strand._themesXslName;
                    break;
                case "about":
                case "privacy":
                case "terms":
                    this.Uri = StrandsModel._xmlAppDir + StrandName + ".xml";
                    this.XslName = Strand._defaultXslName;
                    break;
                default:
                this.Uri = GetUri(); // TODO: check different name of strand file in directory.
                    this.XslName = Strand._strandsXslName;
                    break;
        }
        }

        #endregion

        #region public methods
        
        public StrandSection Select(string SectionName) 
        {
            if (!Sections.ContainsKey(SectionName))
                this.Sections.Add(SectionName, new StrandSection(this, SectionName));
            if (Sections.ContainsKey(SectionName))
                this.ActualSection = this.Sections[SectionName];
            return this.ActualSection;
        }

        public StrandSection Select(string SectionName, string ElementName)
        {
            StrandSection st = this.Select(SectionName);

            st.Select(ElementName);
            return st;
        }

        public string GetDirectoryPath()
        {
            return HttpContext.Current.Server.MapPath(this.Uri);
        }

        public XPathNodeIterator GetSectionData()
        {
            XPathNavigator pn;

            pn = new XPathDocument(GetDirectoryPath()).CreateNavigator();
            // Debug-Variable: string t = (ActualSection != null) ? ActualSection.SectionPath + ((ActualSection.ActualElement != null) ? ActualSection.ActualElement.ElementPath : "") : "";
            return pn.Select((ActualSection != null) ? ActualSection.SectionPath + ((ActualSection.ActualElement != null) ? ActualSection.ActualElement.ElementPath : "") : ""); 
            //switch (this.ActualSection.Name)
            //{ 
            //    case "Tag-Note":
            //      int i;
            //      string ep = ActualSection.ActualElement.ElementPath.Substring(1);

            //      if (int.TryParse(ep, out i))
            //           return pn.Select(ActualSection.SectionPath.Substring(0, ActualSection.SectionPath.Length) + "[" + ep + "]");
            //       else
            //           return pn.Select(ActualSection.SectionPath.Substring(0, ActualSection.SectionPath.Length - 1) + "[@ID='" + ep + "']");
            //    default:
            //        return pn.Select((ActualSection != null) ? ActualSection.SectionPath + ((ActualSection.ActualElement != null) ? ActualSection.ActualElement.ElementPath : "") : ""); 
            //}
        }

        #endregion
    }

    public class StrandSection
    {
        #region private properties

        Strand _theStrand = null;
        
        #endregion
        
        #region public properties

        public string Name { get; set; }
        public string SectionPath {get; set;}
        public StrandElement ActualElement { get; set; }
 
        #endregion

        #region private methods

        private string GetLocationPath(string SectionName)
        {
            string path = "";

            if (path == "")
            {
                int i;

                if (int.TryParse(SectionName, out i))
                {
                    XPathNavigator pd, pn;
                    //XPathNodeIterator pni;

                    pd = new XPathDocument(this._theStrand.GetDirectoryPath()).CreateNavigator();
                    pn = pd.SelectSingleNode("Article/Sect1[" + SectionName + "]/@Id");
                    if (pn != null)
                    {
                        this.Name = pn.InnerXml;
                        path = "Article/Sect1[@Id='" + this.Name + "']";
                    }
                    else
                    {
                        path = "Article/Sect1[" + SectionName + "]";
                        try {
                            pd.SelectSingleNode(path).ToString(); // throw an exception when SelectSingleNode() returns null
                        }
                        catch (Exception ex) {
                            throw new Exception("Strand section not found", ex);
                        }
                    }
                }
                else
                {
                    if (!string.IsNullOrEmpty(SectionName))
                    {
                        if (SectionName.StartsWith("Article"))
                            path = SectionName;
                        else if (SectionName.StartsWith("Tag-"))
                            path = "Article/" + SectionName.Substring("Tag-".Length);
                        else if (SectionName.ToLower() == "start")
                            path = "Article/Sect1[1]";
                        else
                            path = "Article/Sect1[@Id='" + SectionName + "']";
                    }
                } 
            }
            return path;
        }
        
        #endregion

        #region public constructors

        public StrandSection(Strand theStrand) 
        {
            this._theStrand = theStrand;
            this.SectionPath = "";
            this.Name = "";
            this.ActualElement = null;
        }

        public StrandSection (Strand theStrand, string SectionName)
            : this(theStrand)
        {
            this.Name = SectionName;
            this.SectionPath = this.GetLocationPath(SectionName);
        }

        #endregion

        #region public methods
        
        public StrandElement Select(string ElementName) 
        {
            this.ActualElement = new StrandElement(ElementName);
            return this.ActualElement;
        }

        #endregion
    }

    public class SectionList : System.Collections.Generic.Dictionary<string, StrandSection>
    { 
        #region public constructors

        public SectionList() { }

        #endregion
    }

    public class StrandElement
    {
        #region public properties

        public string Name { get; set; }
        public string ElementPath { get; set; }

        #endregion

        #region private methods

        private string GetLocationPath()
        {
            string name = (this.Name.IndexOf("$$") >= 0) ? this.Name.Substring(0, this.Name.IndexOf("$$")) : this.Name;

            if (this.Name.IndexOf("-") >= 0)
            {
                string en = this.Name.Substring(0, this.Name.IndexOf("-"));
                int i;
                string ep = this.Name.Substring(this.Name.IndexOf("-") + 1);

                switch (en)
                {
                    case "Note":
                        if (int.TryParse(ep, out i))
                            return "/Note[" + ep + "]";
                        else
                            return "/Note[@ID='" + ep + "']";
                    case "Position":
                        if (int.TryParse(ep, out i))
                            return "#" + ep;
                        else
                            return "#" + ep;
                    default:
                        return "";
                }
            }
            else
            return (! string.IsNullOrEmpty(name)) ? "/" + name : "";
        }

        #endregion

        #region public constructors

        public StrandElement() 
        {
            this.Name = "";
            this.ElementPath = "";
        }

        public StrandElement(string ElementName)
            : this()
        {
            this.Name = ElementName;
            this.ElementPath = this.GetLocationPath();
        }

        #endregion
    }
}