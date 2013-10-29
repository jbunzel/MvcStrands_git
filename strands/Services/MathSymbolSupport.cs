using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace strands.Services
{
    public class MathSymbolSupport
    {
        #region private members

            DocTypeDefinition _dtd = DocTypeDefinition.undefined;
        
        #endregion

        #region public members"

        public enum DocTypeDefinition
        {
            jbarticle,
            undefined
        }

        public enum MathRendererType
        {
            MathPlayer,
            XHTML,
            TexVc,
            MathJax,
            HTML5,
            undefined
        }

        #endregion

        #region public constructors

        public MathSymbolSupport(DocTypeDefinition Dtd)
        {
            this._dtd = Dtd;
        }

        #endregion

        #region public methods

        public string GetMathTransformParams()
        {
            switch (HttpContext.Current.Request.Browser.Browser)
            {
                case "Firefox":
                    return "HTML5 MathML2.0";
                default:
                    return "";
            }
        }

        static public string GreekLetters(Char Letter)
        {
            switch (HttpContext.Current.Request.Browser.Browser)
            {
                case "Firefox":
                    switch (Letter)
                    {
                        case 'a':
                            return "&#945;";
                        case 'b':
                            return "&#946;";
                        case 'g':
                            return "&#947;";
                        case 'd':
                            return "&#948;";
                        case 'e':
                            return "&#949;";
                        case 'z':
                            return "&#950;";
                        case 'h':
                            return "&#951;";
                        case 'q':
                            return "&#952;";
                        case 'i':
                            return "&#953;";
                        case 'k':
                            return "&#954;";
                        case 'l':
                            return "&#955;";
                        case 'm':
                            return "&#956;";
                        case 'n':
                            return "&#957;";
                        case 'x':
                            return "&#958;";
                        case 'o':
                            return "&#959;";
                        case 'p':
                            return "&#960;";
                        case 'r':
                            return "&#961;";
                        case 'V':
                            return "&#962;";
                        case 's':
                            return "&#963;";
                        case 't':
                            return "&#964;";
                        case 'u':
                            return "&#965;";
                        case 'f':
                            return "&#966;";
                        case 'c':
                            return "&#967;";
                        case 'y':
                            return "&#968;";
                        case 'w':
                            return "&#969;";
                        case 'J':
                            return "&#977;";
                        case 'j':
                            return "&#981;";
                        case 'v':
                            return "&#982;";
                        case (char)161:
                            return "&#978;";
                        default:
                            return "&#978;";
                    }
                default:
                    return null;
            }
        }

        #endregion
    }
}