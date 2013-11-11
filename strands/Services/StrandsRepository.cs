using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;

using strands.Models;

namespace strands.Services
{
    public class StrandsRepository
    {
        #region private members

        private StrandsModel model;
        private string _applUrl = "http://" + HttpContext.Current.Request.ServerVariables["HTTP_HOST"] + HttpRuntime.AppDomainAppVirtualPath;
        public string _xslAppUrl = HttpRuntime.AppDomainAppVirtualPath + "/Xsl/";
        private string _applImgBase = "images";
        private string _docBase = "http://mydocs.strands.de/";
        private string _displayType = "";
        private MathSymbolSupport _mathRenderer = new MathSymbolSupport(MathSymbolSupport.DocTypeDefinition.jbarticle);

        #endregion
        
        #region private methods

        public string StripDisplayType(string Element)
        {
            if (!string.IsNullOrEmpty(Element))
                this._displayType = (Element.Contains("$$") ? Element.Substring(Element.IndexOf("$$") + 2) : "").ToLower();
            return (Element.Contains("$$") ? Element.Substring(0, Element.IndexOf("$$")) : Element);
        }

        private XsltArgumentList TransformArguments(Strand Strand)
        {
            var arguments = new XsltArgumentList();
            string theme = "";

            switch (Strand.ActualSection.Name)
            {
                case "Home":
                    theme = "0";
                    break;
                case "Science":
                case "Science_&_Philosophy":
                case "Science & Philophy":
                    theme = "1";
                    break;
                case "Arts":
                case "Arts_&_Literature":
                case "Arts & Literature":
                    theme = "2";
                    break;
                case "Music":
                    theme = "3";
                    break;
                case "Public":
                case "Public_Affairs":
                case "Public Affairs":
                    theme = "4";
                    break;
                case "Questionnaire":
                    theme = "5";
                    break;
                default:
                    theme = "0";
                    break;
            }
            arguments.AddParam("TabId", "", theme);
            arguments.AddParam("AppURL", "", this._applUrl);
            arguments.AddParam("AppImgBase", "", this._applUrl + "/" + this._applImgBase);
            arguments.AddParam("DocBase", "", this._docBase);
            arguments.AddParam("ArticleBase", "", model.BaseUrl);
            arguments.AddParam("XBaseURL", "", model.CrossBaseUri);
            arguments.AddParam("AppBase", "", Strand.Uri.Substring(0, Strand.Uri.LastIndexOf("/")) + "/");
            arguments.AddParam("SrcURL", "", Strand.Name);
            arguments.AddParam("Sect", "", Strand.GetSectionData());
            arguments.AddParam("cssclasstype", "", this._displayType);
            //Put switches for RQRenderer here. Actually only MathRenderers (MathPlayer) implemented 
            arguments.AddParam("Extensions", "", _mathRenderer.GetMathTransformParams());
            arguments.AddExtensionObject("urn:StrandsExtension", new StrandsExtension.LinkUtils());
            return arguments;
        }
        
        private string LookupCache(string strandName, string sectionName, string elementName)
        {
            throw new System.Exception("Strand not available in cache.");
        }

        private string ToHtml(Strand Strand)
        {
            var transform = new XslCompiledTransform(true);
            var arguments = new XsltArgumentList();
            var settings = new XsltSettings();
            var readersettings = new XmlReaderSettings();
            string xslsrc = (!string.IsNullOrEmpty(this._displayType)) ? "/XMLList.xsl" : "/Strands.xsl"; 
            var xslfile = (Strand.Name == "Themes") ? HttpContext.Current.Server.MapPath(this._xslAppUrl + "/StrandList.xsl") : HttpContext.Current.Server.MapPath(this._xslAppUrl + xslsrc);

            settings.EnableDocumentFunction = true;
            settings.EnableScript = true;
            readersettings.DtdProcessing = DtdProcessing.Parse;
            readersettings.ValidationType = ValidationType.None;
            transform.Load(xslfile, settings, new XmlUrlResolver());
            arguments = TransformArguments(Strand);
            using (XmlReader reader = XmlReader.Create(Strand.GetDirectoryPath(), readersettings))
            {
                System.IO.StringWriter writer = new System.IO.StringWriter();

                transform.Transform(reader, arguments, writer);
                return writer.ToString();
            }
        }

        #endregion

        #region public constructors

        public StrandsRepository() 
        {
            model = new StrandsModel();
        }

        #endregion

        #region public methods

        public string Lookup(string StrandName, string SectionName, string ElementName)
        {
            ElementName = this.StripDisplayType(ElementName);

            try {
                return LookupCache(StrandName, SectionName,ElementName);
            }
            catch {
                try {
                    return ToHtml(model.Select(StrandName, SectionName, ElementName));
                }
                catch (Exception ex) {
                    throw new Exception("ERROR!\\n" + ex.Message + ".", ex);
                }
            }
        }

        #endregion
    }
}

namespace StrandsExtension
{
    class LinkUtils
    {
        public LinkUtils() { }

        private System.IO.Stream GenerateStreamFromString(string s)
        {
            System.IO.MemoryStream stream = new System.IO.MemoryStream();
            System.IO.StreamWriter writer = new System.IO.StreamWriter(stream);
            writer.Write(s);
            writer.Flush();
            stream.Position = 0;
            return stream;
        }

        public string GenerateUlink(string link, string section)
        {
            System.Web.Mvc.UrlHelper u = new System.Web.Mvc.UrlHelper(HttpContext.Current.Request.RequestContext);
            string strand = link.Contains("/") ? link.Substring(0, link.IndexOf("/")) : link;

            return u.Action("Index", "Home", new { Strand = strand, Section = ((section != "") ? section : "") });
        }

        public string GenerateUlink(string link, string section, string type)
        {
            System.Web.Mvc.UrlHelper u = new System.Web.Mvc.UrlHelper(HttpContext.Current.Request.RequestContext);
            string strand = link.Contains("/") ? link.Substring(0, link.IndexOf("/")) : link;

            string t = u.Action("Index", "Home", new { Strand = strand, Section = ((section != "") ? section : "1"), Element = "$$" + type });
            return u.Action("Index", "Home", new { Strand = strand, Section = ((section != "") ? section : "1"), Element = "$$" + type });

        }

        public string GenerateUlink(string link, string section, string element, string type)
        {
            System.Web.Mvc.UrlHelper u = new System.Web.Mvc.UrlHelper(HttpContext.Current.Request.RequestContext);
            string strand = link.Contains("/") ? link.Substring(0, link.IndexOf("/")) : link;

            return u.Action("Index", "Home", new { Strand = strand, Section = ((section != "") ? section : "1"), Element = element + "$$" + type });
        }

        public string StripNamespace(string CDATA)
        {
            return CDATA.Replace("m:","");
        }

        public string GreekLetterCorrection(string Letter)
        {
            string c = strands.Services.MathSymbolSupport.GreekLetters(Letter[0]);

            if (!string.IsNullOrEmpty(c))
            {
                for (int i = 1; i < Letter.Length; i++)
                    c += strands.Services.MathSymbolSupport.GreekLetters(Letter[i]);
                return "<span class='Math'>" + c + "</span>";
            }
            else
                return "<span class='Greek'>" + Letter + "</span>";
        }
    }

}