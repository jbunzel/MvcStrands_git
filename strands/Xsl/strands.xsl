<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:LinkUtils="urn:StrandsExtension">

  <xsl:import href="jbarticle.xsl" />

  <xsl:output method="html" encoding="iso-8859-1" />

  <xsl:param name="AppBase" select="''"/>
  <xsl:param name="AppURL" select="''"/>
  <xsl:param name="SrcURL" select="''"/>
  <xsl:param name="ArticleBase" select="''"/>
  <xsl:param name="Sect" select="*"/>
  <xsl:param name="Extensions" select="''"/>

  <xsl:param name="XBaseURL" select="''"/>
  <xsl:param name="AppImgBase" select="''"/>
  <xsl:param name="DocBase" select="''"/>
  <xsl:param name="JScript" select="'strands.js'"/>
  <xsl:param name="cssclasstype" select="'poemtoc'"/>

  <xsl:param name="SmartURLEnabled" select="'false'"/>

  <xsl:key name="linkend-group" match="Link" use="@Linkend" />

  <xsl:template match="/">
    <script src="Scripts/HtmlFactoryScripts/rqui-pdf.js" type="text/javascript"></script>
    <style type="text/css">
      .embedded {
      width: 730px;
      height: 600px;
      margin: 2em auto;
      border: 5px solid #808080;
      }

      object {
      display: block;
      border: solid 1px #C0C0C0;
      }
    </style>

    <script type="text/javascript" language="JavaScript">

      function embedPDF(file, divname)
      {
      var pObj = new PDFObject({url: file,
      id: "myPDF",
      pdfOpenParams: {navpanes: 0,
      toolbar: 0,
      statusbar: 0,
      view: "FitH" }});

      if(pObj){
      var plugintype = pObj.get("pluginTypeFound");
      msg = "Type of PDF plugin found: " +plugintype;
      if(plugintype){
      //alert(msg);
      document.getElementById(divname).className = "embedded";  //Style the DIV
      var htmlObj = pObj.embed(divname);	//Returns a reference to the HTML or null if unsuccessful
      if(htmlObj){
      msg = "The PDF was successfully embedded!";
      //alert("link"+divname);
      visibilityToggle("link"+divname);
      } else {
      msg = "Irgendwas ist bei der Anzeige schief gelaufen.";
      alert(msg);
      }
      } else {
      msg += "Die Anzeige von PDF-Dateien scheint mit Ihrem Browser nicht möglich zu sein. Sie müssen ein geeignetes Add-In installieren.";
      alert(msg);
      s.className = "fail";
      }
      }
      }

      function showBox (ref, boxName, features)
      {
      newWin=window.open(ref,boxName,features);
      newWin.window.focus();
      }

      function visibilityToggle(id, displayClass) {
      var el = document.getElementById(id);
      if(el.className.indexOf("Linklist") == 0) {
      el.className = displayClass;
      }
      else {
      el.className = "Linklist";
      }
      }

      function createDiv(id, linkid)
      {
      var el = document.getElementById(id);
      var il = document.getElementById(linkid);
      var ind = el.className.indexOf("Linklist");

      if(ind == 0) {
      var newDiv = document.createElement("div");

      newDiv.innerHTML = il.innerHTML;
      newDiv.className = "Linkshow " + el.className.substr(9);
      el.appendChild(newDiv);
      el.className= "Linkshow " + el.className.substr(9);
      //alert(el.outerHTML);
      }
      else {
      el.innerHTML = '';
      el.className = "Linklist " + el.className.substr(9);
      //alert(el.outerHTML);
      }
      }
      
      function readSearchField(path)
      {
        InputText = document.getElementById("searchfield").value;
        InputText = InputText.replace("*","$"); // needed because '*' is in requestPathInvalidCharacters
        path = path.replace("/1", "/" + InputText);
        window.open(path, 'SEARCH','scrollbars,width=500,height=650,left=20,top=20');
      }

    </script>

    <xsl:if test="//D3Graph">
      <xsl:element name="script">
        <xsl:attribute name="type">
          <xsl:value-of select="'text/javascript'" />
        </xsl:attribute>
        <xsl:attribute name="src">
          <xsl:value-of select="'js/d3.v3.min.js'" />
      </xsl:attribute>
      </xsl:element>
      <xsl:element name="script">
        <xsl:attribute name="type">
          <xsl:value-of select="'text/javascript'" />
        </xsl:attribute>
        <xsl:attribute name="src">
          <xsl:value-of select="'js/jquery/jquery-1.7.1.min.js'" />
        </xsl:attribute>
      </xsl:element>
      <xsl:for-each select="//D3Graph[not(preceding::*/@Type = @Type)]">
          <xsl:element name="script">
            <xsl:attribute name="type">
              <xsl:value-of select="'text/javascript'" />
            </xsl:attribute>
            <xsl:attribute name="src">
              <xsl:value-of select="concat($ArticleBase, 'D3Graph/js/', @Type, '.js')" />
            </xsl:attribute>
          </xsl:element>
      </xsl:for-each>
    </xsl:if>
    <xsl:apply-templates select="$Sect"/>
    <xsl:call-template name="generate-linklist">
      <xsl:with-param name="link-nodelist" select="$Sect//Link[generate-id()=generate-id(key('linkend-group',@Linkend)[ancestor::*=$Sect][1])]" />
    </xsl:call-template>
  </xsl:template>

  <!-- Named templates / Overriding jbarticle.xsl -->

  <xsl:template name="generate-linklist">
    <xsl:param name="link-nodelist" />

    <!-- Referenzierte NumberedItems müssen bei Strands-Anzeige für jede Seite gesammelt werden. -->
    <xsl:for-each select="$link-nodelist" >
      <xsl:if test="//NumberedItem[@Id=current()/@Linkend and not(@Language='English')]">
        <xsl:apply-templates select="//NumberedItem[@Id=current()/@Linkend and not(@Language='English')]" mode="linklist" />
        <xsl:call-template name="generate-linklist">
          <xsl:with-param name="link-nodelist" select="//NumberedItem[@Id=current()/@Linkend and not(@Language='English')]//Link[generate-id()=generate-id(key('linkend-group',@Linkend)[1])]" />
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="$link-nodelist" >
      <xsl:if test="//Footnote[@Id=current()/@Linkend and not(current()/ancestor::*[@Language='English']) and not(@Type='Sonstiges')]">
        <xsl:apply-templates select="//Footnote[@Id=current()/@Linkend and not(current()/ancestor::*[@Language='English']) and not(@Type='Sonstiges')]" mode="linklist" />
        <!-- In Fußnoten referenzierte NumberedItems müssen bei Strands-Anzeige für jede Seite gesammelt werden. -->
        <xsl:call-template name="generate-linklist">
          <xsl:with-param name="link-nodelist" select="//NumberedItem[@Id=current()/@Linkend and not(ancestor::*[@Language='English']) and not(@Type='Sonstiges')]//Link[generate-id()=generate-id(key('linkend-group',@Linkend)[1])]" />
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="generate-footnote-ref">
    <xsl:param name="EID" />

    <xsl:element name="span">
      <!-- Attribut zur Darstellung der Referenzen auf Fußnoten in Strands-Anzeige -->
      <xsl:attribute name="onclick">
        <xsl:text>createDiv('</xsl:text>
        <xsl:value-of select="$EID" />
        <xsl:text>', '</xsl:text>
        <xsl:value-of select="concat('NILINK',//Footnote[@Id=current()/@Linkend]/@Id)" />
        <xsl:text>')</xsl:text>
      </xsl:attribute>
      <sup class="reference">
        <!-- ERROR: Referenzen auf gleiche Fußnoten werden unterschiedlich numeriert -->
        <xsl:value-of select="concat(count(preceding::Link[@Type='Footnote' and not(ancestor::*[@Language='English'])])+1,') ')" />
      </sup>
    </xsl:element>
  </xsl:template>

  <xsl:template name="generate-numbereditem-ref">
    <xsl:param name="EID" />
    <xsl:param name="type" />

    <xsl:element name="span">
      <xsl:attribute name="class">
        <xsl:text>lookup</xsl:text>
      </xsl:attribute>
      <!-- Attribut zur Darstellung der Referenzen auf NumberedItems in Strands-Anzeige -->
      <xsl:attribute name="onclick">
        <xsl:text>createDiv('</xsl:text>
        <xsl:value-of select="$EID" />
        <xsl:text>', '</xsl:text>
        <xsl:value-of select="concat('NILINK',//NumberedItem[@Id=current()/@Linkend]/@Id)" />
        <xsl:text>')</xsl:text>
      </xsl:attribute>
      <!-- Attribut zur Darstellung der Referenzen auf NumberedItems in Strands-Anzeige -->
      <xsl:attribute name="title">
        <xsl:text>Anklicken, um Verweis ein- bzw. auszublenden.</xsl:text>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="@Type='Definition' and not(string()=string(current()/@Linkend))">
          <xsl:value-of select="string()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="nrstr">
            <xsl:for-each select="//NumberedItem[@Id=current()/@Linkend]">
              <xsl:choose>
                <xsl:when test="@Type='Definition'">
                  <xsl:text>Definition </xsl:text>
                </xsl:when>
                <xsl:when test="@Type='Satz'">
                  <xsl:text>Satz </xsl:text>
                </xsl:when>
                <xsl:when test="@Type='Lemma'">
                  <xsl:text>Lemma </xsl:text>
                </xsl:when>
                <xsl:when test="@Type='Figure'">
                  <xsl:text>Bild </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="''"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text> (</xsl:text>
              <xsl:number level="any" count="Sect1" />
              <xsl:text>.</xsl:text>
              <xsl:number level="any" count="NumberedItem[@Type=$type]" from="Sect1"/>
              <xsl:text>) </xsl:text>
            </xsl:for-each>
          </xsl:variable>
          <xsl:value-of select="$nrstr" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <!-- Named templates / Additional templates -->

  <!-- Navigation elements -->

  <xsl:template name="Sect1.Toolbar">
    <table border="0" width="50px">
      <tr align="center" valign="baseline">
        <td class="smallcomment">
          <xsl:if test="preceding-sibling::Sect1">
            <xsl:variable name="section">
              <xsl:choose>
                <xsl:when test="preceding-sibling::Sect1[1]/@Id">
                  <xsl:value-of select="preceding-sibling::Sect1[1]/@Id"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="count(preceding-sibling::Sect1)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="LinkUtils:GenerateUlink($SrcURL, $section)"/>
              </xsl:attribute>
              <xsl:attribute name="class">
                <xsl:value-of select="'smallcomment'" />
              </xsl:attribute>
              <xsl:attribute name="title">
                <xsl:value-of select="'zurück'" />
              </xsl:attribute>
              <xsl:text> &lt; </xsl:text>
            </xsl:element>
          </xsl:if>
        </td>
        <td class="smallcomment">
          <xsl:value-of select="count(preceding-sibling::Sect1)+1"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="count(../Sect1)"/>
        </td>
        <td>
          <xsl:if test="following-sibling::Sect1">
            <xsl:variable name="section">
              <xsl:choose>
                <xsl:when test="following-sibling::Sect1[1]/@Id">
                  <xsl:value-of select="following-sibling::Sect1[1]/@Id"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="count(preceding-sibling::Sect1)+2" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="LinkUtils:GenerateUlink($SrcURL, $section)"/>
              </xsl:attribute>
              <xsl:attribute name="class">
                <xsl:value-of select="'smallcomment'" />
              </xsl:attribute>
              <xsl:attribute name="title">
                <xsl:value-of select="'vor'" />
              </xsl:attribute>
              <xsl:text> &gt; </xsl:text>
            </xsl:element>
          </xsl:if>
        </td>
      </tr>
      <tr>
        <td colspan="3">
          <xsl:element name="input">
            <xsl:attribute name="id">searchfield</xsl:attribute>
            <xsl:attribute name="type">text</xsl:attribute>
            <xsl:attribute name="title">Suchterme hier eingeben</xsl:attribute>
          </xsl:element>
        </td>
      </tr>
      <tr>
        <td colspan="3">
          <table border="0">
            <tr align="center" valign="baseline">
              <td>
                <xsl:element name="a">
                  <xsl:attribute name="class">
                    <xsl:text>smallcomment</xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="onclick">
                    <xsl:variable name="path">
                      <xsl:value-of select="LinkUtils:GenerateUlink('Search', '')"/>
                    </xsl:variable>

                    <xsl:value-of select="concat('javascript:readSearchField(&quot;',$path,'&quot;)')" />
                  </xsl:attribute>
                  <xsl:attribute name="href">
                    <xsl:text>#</xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="title">
                    <xsl:text>textsuche (in allen strands)</xsl:text>
                  </xsl:attribute>
                  <xsl:text>search</xsl:text>
                </xsl:element>
              </td>
              <td>
                <xsl:element name="a">
                  <xsl:attribute name="class">
                    <xsl:value-of select="'smallcomment'" />
                  </xsl:attribute>
                  <xsl:attribute name="href">
                    <xsl:value-of select="'###'" />
                  </xsl:attribute>
                  <xsl:attribute name="title">
                    <xsl:value-of select="'Inhaltsverzeichnis'" />
                  </xsl:attribute>
                  <xsl:attribute name="onClick">
                    <xsl:variable name="Strand">
                      <xsl:value-of select="LinkUtils:GenerateUlink($SrcURL, 'Article', 'TOC')"/>
                    </xsl:variable>

                    <xsl:value-of select="concat('window.open(&quot;', $Strand, '&quot;, &quot;TOC&quot;, &quot;scrollbars,width=500','height=650,left=20,top=20&quot;)')" />
                  </xsl:attribute>
                  <xsl:text>/toc</xsl:text>
                </xsl:element>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="Sect1.Navbar">
    <table border="0">
      <tr align="right">
        <td colspan="2">
          <xsl:call-template name="Sect1.Toolbar"/>
        </td>
      </tr>
      <tr>
        <td valign="top">
          <img src="{$AppBase}tibanner.gif" border="0" alt="{Title}" title="{Title}"/>
        </td>
        <td class="shadow" valign="top">
          <xsl:variable name="pos" select="."/>
          <xsl:for-each select="../Sect1">
            <xsl:variable name="nrstr">
              <xsl:if test="not(Title/@Type='nonumber')">
                <xsl:value-of select="concat(number(position()),'. ')" />
              </xsl:if>
            </xsl:variable>

            <xsl:choose>
              <xsl:when test="current()=$pos">
                <img src="{$AppImgBase}/selpixel.jpg" border="0" alt="{$nrstr}{Title}" title="{$nrstr}{Title}" align="middle"
                  width="15" height="15"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="section">
                  <xsl:choose>
                    <xsl:when test="@Id">
                      <xsl:value-of select="@Id"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="position()"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="LinkUtils:GenerateUlink($SrcURL, $section)"/>
                  </xsl:attribute>
                  <img src="{$AppImgBase}/bluepixel.gif" border="0" alt="{$nrstr}{Title}" title="{$nrstr}{Title}" align="middle" width="15" height="15"/>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
            <p/>
          </xsl:for-each>
        </td>
      </tr>
      <tr align="right" valign="bottom">
        <td colspan="2">
          <xsl:call-template name="Sect1.Toolbar"/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!-- SUBSTRANDS not implemented in MvcStrands
  <xsl:template name="Sect1.SubIndex">
    <xsl:if test="Sect2[@Type='substrand']">
      <table border="0" align="center" cellspacing="5" cellpadding="5">
        <xsl:for-each select="Sect2[count(preceding-sibling::Sect2) mod 2 = 0]">
          <xsl:variable name="section">
            <xsl:choose>
              <xsl:when test="parent::*/@Id">
                <xsl:value-of select="parent::*/@Id"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="count(preceding-sibling::Sect1)+1"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:variable name="paragraph">
            <xsl:choose>
              <xsl:when test="@Id">
                <xsl:value-of select="@Id"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="count(preceding-sibling::Sect2)+1"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <tr>
            <td class="shadow">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:call-template name="generate_smart_url">
                    <xsl:with-param name="location" select="$SrcURL" />
                    <xsl:with-param name="section" select="$section" />
                    <xsl:with-param name="paragraph" select="$paragraph" />
                  </xsl:call-template>
                </xsl:attribute>
                <img src="{$AppImgBase}/bluepixel.gif" border="0" alt="{Title}" title="{Title}" align="middle" width="15" height="15"/>
              </xsl:element>
            </td>
            <td>
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:call-template name="generate_smart_url">
                    <xsl:with-param name="location" select="$SrcURL" />
                    <xsl:with-param name="section" select="$section" />
                    <xsl:with-param name="paragraph" select="$paragraph" />
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:apply-templates select="Title" mode="Index"/>
              </xsl:element>
            </td>
            <xsl:choose>
              <xsl:when test="following-sibling::Sect2">
                <xsl:variable name="paragraph2">
                  <xsl:choose>
                    <xsl:when test="following-sibling::Sect2/@Id">
                      <xsl:value-of select="following-sibling::Sect2/@Id"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="count(preceding-sibling::Sect2)+2"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <td class="shadow">
                  <xsl:element name="a">
                    <xsl:attribute name="href">
                      <xsl:call-template name="generate_smart_url">
                        <xsl:with-param name="location" select="$SrcURL" />
                        <xsl:with-param name="section" select="$section" />
                        <xsl:with-param name="paragraph" select="$paragraph2" />
                      </xsl:call-template>
                    </xsl:attribute>
                    <img src="{$AppImgBase}/bluepixel.gif" border="0" alt="{following-sibling::Sect2[1]/Title}" title="{following-sibling::Sect2[1]/Title}" align="middle" width="15" height="15"/>
                  </xsl:element>
                </td>
                <td>
                  <xsl:element name="a">
                    <xsl:attribute name="href">
                      <xsl:call-template name="generate_smart_url">
                        <xsl:with-param name="location" select="$SrcURL" />
                        <xsl:with-param name="section" select="$section" />
                        <xsl:with-param name="paragraph" select="$paragraph2" />
                      </xsl:call-template>
                    </xsl:attribute>
                    <xsl:apply-templates select="following-sibling::Sect2[1]/Title" mode="Index"/>
                  </xsl:element>
                </td>
              </xsl:when>
              <xsl:otherwise>
                <td/>
                <td/>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>
  </xsl:template>
-->
  
  <xsl:template name="SectionBody">
    <xsl:param name="base" select="$AppBase"/>
    <xsl:param name="strand" select="''"/>

    <table border="0" width="100%" align="center" cellspacing="0" cellpadding="0">
      <xsl:apply-templates select="Motto">
        <xsl:with-param name="base" select="$base"/>
      </xsl:apply-templates>
      <tr>
        <td colspan="2">
          <table border="0" class="strand" width="100%" cellspacing="0" cellpadding="10">
            <tr>
              <xsl:choose>
                <xsl:when test="@Type = 'restricted'">
                  <td class="strandbox" align="center">
                    <xsl:text>This strand is still under construction</xsl:text>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$base=$AppBase">
                        <xsl:apply-templates
                          select="*[not(self::Title|self::Motto|self::Sect2[@Type='substrand'])]"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:apply-templates
                          select="*[not(self::Title|self::Motto|self::Sect2[@Type='substrand']|self::Para/ALink)]">
                          <xsl:with-param name="base" select="$base"/>
                          <xsl:with-param name="strand" select="$strand"/>
                        </xsl:apply-templates>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </xsl:otherwise>
              </xsl:choose>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td>
          <xsl:text> </xsl:text>
        </td>
        <td align="right">
          <xsl:call-template name="Sect1.Toolbar"/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!-- Navigation elements / crossing strands-->

  <xsl:template name="XStrand">
    <xsl:param name="base" select="$AppBase"/>
    <xsl:param name="strand" select="''"/>
    <xsl:param name="path" select="."/>
    <xsl:param name="sectid" select="''"/>
    <xsl:param name="type" select="''"/>

    <xsl:apply-templates select="$path//Sect1[@Id=$sectid]" mode="xstrand">
      <xsl:with-param name="base" select="$base"/>
      <xsl:with-param name="strand" select="$strand"/>
      <xsl:with-param name="type" select="$type"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="Sect1.XNavbar">
    <xsl:param name="base" select="$AppBase"/>
    <xsl:param name="strand" select="''"/>

    <table>
      <tr>
        <td valign="top">
          <img src="{$base}tibannerx.gif" border="0" alt="{Title}" title="{Title}"/>
        </td>
      </tr>
      <tr>
        <td>
          <xsl:variable name="pos" select="."/>
          <table>
            <tr>
              <td class="smallcomment" align="left">
                <xsl:value-of select="count(preceding-sibling::Sect1)+1"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="count(../Sect1)"/>
              </td>
              <td width="400" class="shadow" valign="top">
                <xsl:for-each select="../Sect1">
                  <xsl:variable name="nrstr">
                    <xsl:if test="not(Title/@Type='nonumber')">
                      <xsl:value-of select="concat(number(position()),'. ')" />
                    </xsl:if>
                  </xsl:variable>
                  <xsl:choose>
                    <xsl:when test="current()=$pos">
                      <img src="{$AppImgBase}/selpixel.jpg" border="0" hspace="5" vspace="5"
                        alt="{$nrstr}{Title}" title="{$nrstr}{Title}" align="middle" width="15" height="15"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:variable name="path" select="substring-after($base,$ArticleBase)"/>

                      <xsl:variable name="section">
                        <xsl:choose>
                          <xsl:when test="@Id">
                            <xsl:value-of select="@Id"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="position()"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:variable>
                      <xsl:element name="a">
                        <xsl:attribute name="href">
                          <xsl:value-of select="LinkUtils:GenerateUlink(concat($path,$strand), $section)"/>
                        </xsl:attribute>
                        <img src="{$AppImgBase}/bluepixel.gif" border="0" hspace="5" vspace="5" alt="{$nrstr}{Title}" title="{$nrstr}{Title}" align="middle" width="15" height="15"/>
                      </xsl:element>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!-- Document structure matches / overriding jbarticle.xsl -->

  <xsl:template match="Motto">
    <xsl:param name="base" select="''"/>

    <tr>
      <td align="center" valign="top">
        <xsl:apply-templates select="Graphic">
          <xsl:with-param name="base" select="$base" />
        </xsl:apply-templates>
        <xsl:apply-templates select="Object" />
      </td>
      <td width="15%">
        <xsl:text> </xsl:text>
      </td>
    </tr>
    <tr>
      <td colspan="2">
        <table border="0" width="100%" class="Motto">
          <tr>
            <td width="30%">
              <xsl:text> </xsl:text>
              <br/>
            </td>
            <td width="70%" class="comment">
              <xsl:apply-templates select="*[(name() != 'Graphic') and (name() != 'Object') ]"/>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="Citation">
    <xsl:param name="base" select="''"/>
    <xsl:param name="strand" select="''"/>

    <xsl:variable name="cit">
      <xsl:value-of
        select="normalize-space(//BiblioItem[@Id=string(current()/@Linkend)]/BiblioEntry)"/>
    </xsl:variable>

    <xsl:variable name="ref" select="@Linkend"/>

    <xsl:variable name="BibURL">
      <xsl:choose>
        <xsl:when test="string-length(concat($base,$strand))>0">
          <xsl:value-of select="substring-after(concat($base,$strand),$ArticleBase)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="string($SrcURL)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="//BiblioItem[@Id=$ref]">
        <xsl:element name="span">
          <xsl:attribute name="class">
            <xsl:text>reference</xsl:text>
          </xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="'###'" />
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="$cit" />
            </xsl:attribute>
            <xsl:attribute name="onClick">
              <xsl:variable name="Element">
                <xsl:value-of select ="concat('Note[', count(preceding-sibling::Note)+1, ']')"/>
              </xsl:variable>
              <xsl:variable name="Position">
<!-- TODO:
     Positionierungs-Marke einfügen. # wird offenbar vom Routing-Mechanismus ausgeblendet.   
-->                
                <xsl:value-of select ="concat('#', $ref)"/>
              </xsl:variable>

              <xsl:variable name="Strand">
<!-- TODO (s. o. 
                <xsl:value-of select="LinkUtils:GenerateUlink($BibURL, 'Tag-Bibliography', $Position, 'Bibliography')"/>
-->
                <xsl:value-of select="LinkUtils:GenerateUlink($BibURL, 'Tag-Bibliography', 'Bibliography')"/>
              </xsl:variable>

              <xsl:value-of select="concat('window.open(&quot;', $Strand, '&quot;, &quot;BIB&quot;, &quot;scrollbars,width=300','height=650,left=20,top=20&quot;)')" />
            </xsl:attribute>
            <img src="{$AppImgBase}/bibliography.gif" alt="bibliography" title="bibliography" />
            <xsl:text></xsl:text>
            <xsl:apply-templates/>
            <xsl:text></xsl:text>
          </xsl:element>
        </xsl:element>
        <xsl:element name="span">
          <xsl:attribute name="class">
            <xsl:text>top</xsl:text>
          </xsl:attribute>
          <xsl:if test="//BiblioItem[@Id=string(current()/@Linkend)]/BiblioEntry/@Id">
            <xsl:variable name="docno" select="substring-after(//BiblioItem[@Id=string(current()/@Linkend)]/BiblioEntry/@Id,'RQ')"/>

            <a href="http://www.riquest.de/default.aspx?QRY=$access${$docno}" target="riquest" title="open catalog">
              <img src="{$AppImgBase}/catalog.gif" alt="open catalog" title="open catalog" />
            </a>
          </xsl:if>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <a href="@Linkend" title="{$cit}">
          <b>
            <xsl:apply-templates/>
          </b>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ALink">
    <xsl:call-template name="XStrand">
      <xsl:with-param name="base" select="concat($ArticleBase,substring-before(@Article,'/'),'/')"/>
      <xsl:with-param name="strand" select="substring-after(@Article,'/')"/>
      <xsl:with-param name="path" select="document(concat($XBaseURL,@Article))"/>
      <xsl:with-param name="sectid" select="."/>
      <xsl:with-param name="type" select="string(@Type)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="Footnote" mode="inline">
    <xsl:param name="text-prefix" select="''" />

    <!-- Inline-Fußnoten werden bei Strands-Anzeige über Links eingeblendet -->
    <xsl:variable name="EID">
      <xsl:value-of select="generate-id()"/>
    </xsl:variable>

    <xsl:element name="span">
      <xsl:attribute name="onclick">
        <xsl:text>visibilityToggle('</xsl:text>
        <xsl:value-of select="$EID" />
        <xsl:text>', 'strand');</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:text>lookup</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:text>Anklicken, um Abschnitt ein- bzw. auszublenden.</xsl:text>
      </xsl:attribute>
      <xsl:value-of select="$text-prefix" />
    </xsl:element>
    <xsl:element name="div">
      <xsl:attribute name="ID">
        <xsl:value-of select="$EID" />
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:text>Linklist</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates select="." mode="linklist" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="Note">
    <xsl:param name="base" select="''"/>
    <xsl:param name="strand" select="''"/>

    <xsl:variable name="NoteURL">
      <xsl:choose>
        <xsl:when test="string-length(concat($base,$strand))>0">
          <xsl:value-of select="substring-after(concat($base,$strand),$ArticleBase)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="string($SrcURL)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="position()=1">
        <body class="strandbox">
          <span class="strandbox">
            <xsl:apply-templates/>
          </span>
        </body>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="pos" select="count(./preceding-sibling::*)"/>
        <xsl:variable name="width">
          <xsl:choose>
            <xsl:when test="contains(@Type,'flexibel:')" >
              <xsl:value-of select="substring-before(substring-after(@Type,'width='),';')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'700'" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <table width="150" border="0" align="right">
          <tr>
            <td rowspan="2" width="20" align="right">
              <img src="{$AppImgBase}/tabseparator.gif" width="2" height="100"/>
            </td>
            <td>
              <xsl:element name="a">
                <xsl:attribute name="class">
                  <xsl:text>smallcomment</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="'###'" />
                </xsl:attribute>
                <xsl:attribute name="onClick">
                  <xsl:variable name="Element">
                    <xsl:value-of select ="concat('Note[', count(preceding-sibling::Note)+1, ']')"/>
                  </xsl:variable>
                  
                  <xsl:variable name="Strand">
                    <xsl:value-of select="LinkUtils:GenerateUlink($NoteURL, string(ancestor::Sect1/@Id), $Element, 'Note')"/>
                  </xsl:variable>

                  <xsl:value-of select="concat('window.open(&quot;', $Strand, '&quot;, &quot;NOTE&quot;, &quot;scrollbars,width=', $width,'height=650,left=20,top=20&quot;)')" />
                </xsl:attribute>
                <img src="{$AppImgBase}/note.gif" border="0"/>
              </xsl:element>              
            </td>
          </tr>
          <tr>
            <td colspan="2" valign="bottom">
              <xsl:element name="a">
                <xsl:attribute name="class">
                  <xsl:text>smallcomment</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="'###'" />
                </xsl:attribute>
                <xsl:attribute name="onClick">
                  <xsl:variable name="Element">
                    <xsl:value-of select ="concat('Note[', count(preceding-sibling::Note)+1, ']')"/>
                  </xsl:variable>

                  <xsl:variable name="Strand">
                    <xsl:value-of select="LinkUtils:GenerateUlink($NoteURL, string(ancestor::Sect1/@Id), $Element, 'Note')"/>
                  </xsl:variable>

                  <xsl:value-of select="concat('window.open(&quot;', $Strand, '&quot;, &quot;NOTE&quot;, &quot;scrollbars,width=', $width,'height=650,left=20,top=20&quot;)')" />
                </xsl:attribute>
                <xsl:apply-templates select="Title"/>
              </xsl:element>
            </td>
          </tr>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
     
  <xsl:template match ="Math">
    <xsl:choose>
      <!-- MathJAX rendering engine - actually not installed --> 
      <xsl:when test="Code and contains($Extensions, 'MathJax')">
        <xsl:element name="span">
          <xsl:attribute name="class">
            <xsl:text>MathJax_Preview</xsl:text>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="InlineGraphic">
              <xsl:apply-templates select="InlineGraphic" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="Code[@Type='TeXVC'] and contains($Extensions, 'TeXVC')">
                  <xsl:value-of select="Code[@Type='TeXVC']/." />
                </xsl:when>
                <xsl:when test="Code[@Type='MathTeX'] and contains($Extensions, 'MathTeX')">
                  <xsl:value-of select="Code[@Type='MathTeX']/." />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="Code" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
        <xsl:element name="script">
          <xsl:attribute name="type">
            <xsl:text>math/tex</xsl:text>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="Code[@Type='TeXVC'] and contains($Extensions, 'TeXVC')">
              <xsl:value-of disable-output-escaping="yes" select="Code[@Type='TeXVC']/."/>
            </xsl:when>
            <xsl:when test="Code[@Type='MathTeX'] and contains($Extensions, 'MathTeX')">
              <xsl:value-of disable-output-escaping="yes" select="Code[@Type='MathTeX']/."/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="Code/."/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:when>
      <!-- MathPlayer rendering engine -->
      <xsl:when test="Code[@Type='MathML2.0'] and contains($Extensions, 'MathPlayer MathML2.0')">
        <xsl:value-of disable-output-escaping="yes" select="Code[@Type='MathML2.0']/."/>
      </xsl:when>
      <!-- HTML 5 rendering engine -->
      <xsl:when test="Code[@Type='MathML2.0'] and contains($Extensions, 'HTML5 MathML2.0')">
        <xsl:variable name="CDATA">
          <xsl:value-of disable-output-escaping="yes" select="Code[@Type='MathML2.0']/."/>
        </xsl:variable>

        <xsl:value-of disable-output-escaping="yes" select="LinkUtils:StripNamespace($CDATA)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="InlineGraphic" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="Greek">
    <xsl:value-of disable-output-escaping="yes" select="LinkUtils:GreekLetterCorrection(.)" />
  </xsl:template>
    
  <!-- Navigation elements -->

  <xsl:template match="Sect1">
    <xsl:apply-templates select="Title"/>
    <table border="0" width="100%" class="strand" align="center" cellspacing="0" cellpadding="0">
      <tr>
        <td width="15%" valign="top" align="left">
          <xsl:call-template name="Sect1.Navbar"/>
        </td>
        <td valign="top">
          <xsl:call-template name="SectionBody"/>
<!--          
          Substrands not implemented in MvcStrands
          <xsl:call-template name="Sect1.SubIndex"/>
-->          
        </td>
      </tr>
    </table>
  </xsl:template>

  <!-- Document structure matches / Additional matches -->

  <xsl:template match="Sect1" mode="xstrand">
    <xsl:param name="base" select="$AppBase"/>
    <xsl:param name="strand" select="''"/>
    <xsl:param name="type" select="'to'"/>

    <xsl:if test="$type=''">
      <xsl:call-template name="SectionBody">
        <xsl:with-param name="base" select="$base"/>
        <xsl:with-param name="strand" select="$strand"/>
      </xsl:call-template>
    </xsl:if>
    <table border="0" class="strandbox" align="right">
      <tr>
        <td>
          <xsl:text>This is a crosspoint of several strands. You may branch to:</xsl:text>
          <xsl:call-template name="Sect1.XNavbar">
            <xsl:with-param name="base" select="$base"/>
            <xsl:with-param name="strand" select="$strand"/>
          </xsl:call-template>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="NumberedItem" mode="linklist">
    <xsl:variable name="myType" select="@Type" />

    <xsl:element name="div">
      <xsl:attribute name="class">
        <xsl:text>Linklist </xsl:text>
        <xsl:value-of select="$myType" />
      </xsl:attribute>
      <xsl:attribute name="Id">
        <xsl:value-of select="concat('NILINK',@Id)" />
      </xsl:attribute>
      <xsl:element name="p">
        <xsl:choose>
          <xsl:when test="@Type='Definition'">
            <xsl:text>Definition </xsl:text>
          </xsl:when>
          <xsl:when test="@Type='Satz'">
            <xsl:text>Satz </xsl:text>
          </xsl:when>
          <xsl:when test="@Type='Lemma'">
            <xsl:text>Lemma </xsl:text>
          </xsl:when>
          <xsl:when test="@Type='Figure'">
            <xsl:text>Bild </xsl:text>
          </xsl:when>
          <xsl:when test="@Type='Formel'">
            <xsl:text>Gleichung </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="''"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:number level="any" count="Sect1" />
        <xsl:text>. </xsl:text>
        <xsl:number level="any" count="NumberedItem[@Type=$myType]" from="Sect1"/>
        <xsl:text>: </xsl:text>
        <xsl:apply-templates select="child::*" />
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="NumberedItem[@Type='Figure']">
    <xsl:variable name="type" select="@Type" />
    
    <xsl:element name="div">
      <xsl:attribute name="class">
        <xsl:value-of select="@Type" />
      </xsl:attribute>
      <xsl:apply-templates select="Graphic | Figure/Graphic | D3Graph" />
      <xsl:element name="span">
        <xsl:attribute name="class">
          <xsl:text>NumberedItemCount</xsl:text>
        </xsl:attribute>
        <xsl:number level="any" count="Sect1" />
        <xsl:text>. </xsl:text>
        <xsl:number level="any" count="NumberedItem[@Type=$type]" from="Sect1"/>
      </xsl:element>
      <xsl:if test="Figure">
        <xsl:element name="span">
          <xsl:attribute name="class">
            <xsl:text>Emphasis</xsl:text>
          </xsl:attribute>
          <xsl:value-of select="Figure/Title" />
        </xsl:element>
        <xsl:element name="p">
          <xsl:if test="Figure/Para">
            <xsl:value-of select="Figure/Para" />
          </xsl:if>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
