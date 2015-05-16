using System.Web;
using System.Web.Optimization;

namespace strands
{
    public class BundleConfig
    {
        // Weitere Informationen zu Bundling finden Sie unter "http://go.microsoft.com/fwlink/?LinkId=254725".
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js",
                        "~/Scripts/jquery.cookie.js"));

            //bundles.Add(new ScriptBundle("~/bundles/jqueryui").Include(
            //            "~/Scripts/jqueryui/jquery-ui-{version}.js",
            //            "~/Scripts/HtmlFactoryScripts/rqui-datepicker.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.unobtrusive*",
                        "~/Scripts/jquery.validate*"));

            // Verwenden Sie die Entwicklungsversion von Modernizr zum Entwickeln und Erweitern Ihrer Kenntnisse. Wenn Sie dann
            // für die Produktion bereit sind, verwenden Sie das Buildtool unter "http://modernizr.com", um nur die benötigten Tests auszuwählen.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/strands").Include(
                        "~/Scripts/HtmlFactoryScripts/rqui-helpers.js",
                        "~/Scripts/HtmlFactoryScripts/rqui-pdf.js"));

            bundles.Add(new ScriptBundle("~/bundles/search").Include(
                        "~/Scripts/HtmlFactoryScripts/rqui-helpers.js",
                        "~/Scripts/HtmlFactoryScripts/rqui-pdf.js",
                        "~/Scripts/jsrender.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                        "~/Content/Pure/pure-min.css", 
                        "~/Content/site.css"));

            bundles.Add(new StyleBundle("~/Content/strands").Include(
                        "~/Content/themes/strands/strands.css"));

            bundles.Add(new StyleBundle("~/Content/themes").Include(
                        "~/Content/themes/strands/strands.css",
                        "~/Content/themes/strands/themes.css"));

            bundles.Add(new StyleBundle("~/Content/poem").Include(
                        "~/Content/themes/strands/poem.css"));

            bundles.Add(new StyleBundle("~/Content/subpoem").Include(
                        "~/Content/themes/strands/subpoem.css"));

            bundles.Add(new StyleBundle("~/Content/note").Include(
                        "~/Content/themes/strands/strands.css",
                        "~/Content/themes/strands/note.css"));

            bundles.Add(new StyleBundle("~/Content/bibliography").Include(
                        "~/Content/themes/strands/strands.css",
                        "~/Content/themes/strands/bibliography.css"));

            bundles.Add(new StyleBundle("~/Content/toc").Include(
                        "~/Content/themes/strands/strands.css",
                        "~/Content/themes/strands/toc.css"));

            bundles.Add(new StyleBundle("~/Content/search").Include(
                        "~/Content/themes/strands/strands.css",
                        "~/Content/themes/strands/search.css"));

            //bundles.Add(new StyleBundle("~/Content/themes/base/css").Include(
            //            "~/Content/themes/base/jquery.ui.core.css",
            //            "~/Content/themes/base/jquery.ui.resizable.css",
            //            "~/Content/themes/base/jquery.ui.selectable.css",
            //            "~/Content/themes/base/jquery.ui.accordion.css",
            //            "~/Content/themes/base/jquery.ui.autocomplete.css",
            //            "~/Content/themes/base/jquery.ui.button.css",
            //            "~/Content/themes/base/jquery.ui.dialog.css",
            //            "~/Content/themes/base/jquery.ui.slider.css",
            //            "~/Content/themes/base/jquery.ui.tabs.css",
            //            "~/Content/themes/base/jquery.ui.datepicker.css",
            //            "~/Content/themes/base/jquery.ui.progressbar.css",
            //            "~/Content/themes/base/jquery.ui.theme.css"));
        }
    }
}