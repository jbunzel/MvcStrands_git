<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:LinkUtils="urn:StrandsExtension">
  
	<xsl:import href="jbarticle.xsl" />
	<xsl:output method="html" encoding="iso-8859-1" />

  <xsl:variable name="StyleType" select="/Article/@Type" />

	<xsl:param name="AppURL" select="''" />
	<xsl:param name="AppBase" select="''" />
	<xsl:param name="AppImgBase" select="''"/>
	<xsl:param name="ArticleBase" select="''" />
	<xsl:param name="DocBase" select="''" />
	<xsl:param name="XBaseURL" select="''" />
	<xsl:param name="TabId" select="''" />

  
  <xsl:template match="/">
    <script type="text/javascript" language="JavaScript">

      function readSearchField(path)
      {
        InputText = document.getElementById("searchfield").value;
        InputText = InputText.replace("*","$"); // needed because '*' is in requestPathInvalidCharacters
        path = path.replace("/1", "/" + InputText);
        window.open(path, 'SEARCH','scrollbars,width=500,height=650,left=20,top=20');
      }

    </script>

    <table width="100%">
        <xsl:apply-templates select="/Article/Sect1[@Type=$TabId]" />
      </table>
     <p class="search">
       <xsl:text></xsl:text>
       <xsl:element name="input">
         <xsl:attribute name="id">searchfield</xsl:attribute>
         <xsl:attribute name="type">text</xsl:attribute>
         <xsl:attribute name="title">Suchterme hier eingeben</xsl:attribute>
       </xsl:element>
       <xsl:element name="input">
         <xsl:attribute name="id">searchbutton</xsl:attribute>
         <xsl:attribute name="type">submit</xsl:attribute>
         <xsl:attribute name="value">Volltextsuche in Strands</xsl:attribute>
         <xsl:attribute name="onclick">
           <xsl:variable name="path">
             <xsl:value-of select="LinkUtils:GenerateUlink('Search', '')"/>
           </xsl:variable>

           <xsl:value-of select="concat('javascript:readSearchField(&quot;',$path,'&quot;)')" />
         </xsl:attribute>
       </xsl:element>
     </p>
   </xsl:template>


  <xsl:template match="/" mode="items">
    <xsl:apply-templates select="/Article/Abstract" mode="items" />
  </xsl:template>

  
  <xsl:template match="/Article/Abstract" mode="items">
    <tr>
      <td width="5%">
        <img src="{$AppImgBase}/clearpixel.gif" border="0" width="1" height="1" />
      </td>
      <td width="95%" class="Abstract">
        <xsl:apply-templates select=".//Para[not(@Language='English')]" />
      </td>
    </tr>
  </xsl:template>



  <!-- Document structure matches / overriding jbarticle.xsl -->

  <xsl:template match="Motto">
    <tr>
      <td>
        <xsl:apply-templates select="Graphic">
          <xsl:with-param name="base" select="concat($AppImgBase,'/')" />
        </xsl:apply-templates>
      </td>
    </tr>
    <tr>
      <td>
        <table width="100%">
          <tr>
            <td width="30%"></td>
            <td width="70%">
              <xsl:apply-templates select="*[(name() != 'Graphic') and (name() != 'Object') ]"/>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </xsl:template>


  <xsl:template match = "ALink">
<!--
    <a class="comment" href="###" onClick="window.open('{$AppURL}?tabname=StrandsBox&amp;C=poem&amp;L={@Article}&amp;Q=IdTOC&amp;T=Box','BOX','scrollbars,width=700,height=650,left=20,top=20')" title="pen textbox">

    <a class="comment" href="" onClick="window.open('{$AppURL}/{@Article}/TOC','BOX','scrollbars,width=700,height=650,left=20,top=20')" title="open textbox">
        <xsl:apply-templates/>
    </a>
-->
    <xsl:element name="a">
      <xsl:attribute name="class">
        <xsl:text>comment</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="'###'" />
      </xsl:attribute>
      <xsl:attribute name="onClick">
        <xsl:variable name="Strand">
          <xsl:value-of select="LinkUtils:GenerateUlink(@Article, 'TOC', 'Poem')"/>
        </xsl:variable>

        <xsl:value-of select="concat('window.open(&quot;', $Strand, '&quot;, &quot;BOX&quot;, &quot;scrollbars,width=700,height=650,left=20,top=20&quot;)')" />
      </xsl:attribute>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  
  <xsl:template match = "Link">
<!--
    <a class="comment" href="###" onClick="window.open('{$AppURL}?tabname=StrandsBox&amp;C=poem&amp;L={@Article}&amp;Q=Id{@Linkend}&amp;T=Box','BOX','scrollbars,width=700,height=650,left=20,top=20')" title="pen textbox">
-->
    <xsl:element name="a">
      <xsl:attribute name="class">
        <xsl:text>comment</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="'###'" />
      </xsl:attribute>
      <xsl:attribute name="onClick">
        <xsl:variable name="Strand">
          <xsl:value-of select="LinkUtils:GenerateUlink(@Article, @Linkend, 'Subpoem')"/>
        </xsl:variable>

        <xsl:value-of select="concat('window.open(&quot;', $Strand, '&quot;, &quot;BOX&quot;, &quot;scrollbars,width=700,height=650,left=20,top=20&quot;)')" />
      </xsl:attribute>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>


  
  <!-- Navigation elements -->

  <xsl:template match="Sect1">
    <tr>
      <td>
        <xsl:apply-templates select="Title" />
      </td>
    </tr>
    <xsl:if test="Motto">
      <xsl:apply-templates select="Motto" />
    </xsl:if>
    <xsl:apply-templates select="Sect2" />
    <xsl:if test="Para[@Type='text']">
      <tr>
        <td>
          <img src="{$AppImgBase}/bluepixel.gif" width="600" height="3"/>
          <xsl:apply-templates select="Para[@Type='text']"/>
          <img src="{$AppImgBase}/bluepixel.gif" width="600" height="3"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="Para[@Type='featured']">
      <tr>
        <td align="center" height="20"></td>
      </tr>
      <tr>
        <td>
          <table width="100%">
            <xsl:for-each select="Para[@Type='featured']">
              <tr>
                <td width="25%"></td>
                <td align="right">
                  <table width="100%">
                    <tr>
                      <td align="right" colspan="2">
                        <xsl:element name="a">
                          <xsl:attribute name="class">
                            <xsl:text>comment</xsl:text>
                          </xsl:attribute>
                          <xsl:attribute name="href">
 <!--
                            <xsl:call-template name="generate_smart_url">
                              <xsl:with-param name="location" select="ULink/@URL" />
                            </xsl:call-template>
-->
                            <xsl:value-of select="LinkUtils:GenerateUlink(ULink/@URL, '')"/>
                          </xsl:attribute>
                          <xsl:text>  </xsl:text>
                          <xsl:value-of select="ULink" />
                        </xsl:element>
                      </td>
                    </tr>
                    <xsl:apply-templates select="document(concat($XBaseURL,ULink/@URL))" mode="items"/>
                  </table>
                </td>
              </tr>
            </xsl:for-each>
            <xsl:if test="Para[@Type='listed']">
              <tr>
                <td align="left" colspan="2">
                  <h1 class="Test2">&amp;</h1>
                </td>
              </tr>
              <tr>
                <td align="left" colspan="2">
                  <img src="{$AppImgBase}/bluepixel.gif" border="0" width="300" height="2" />
                </td>
              </tr>
              <xsl:for-each select="Para[@Type='listed'] | Para[@Type='noted']">
                <tr>
                  <td align="left" colspan="2">
                    <table border="0" class="strand" width="100%" cellspacing="0" cellpadding="10">
                      <tr>
                        <td align="left" colspan="2">
                          <xsl:element name="a">
                            <xsl:attribute name="class">
                              <xsl:text>comment</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="href">
<!--                              
                              <xsl:call-template name="generate_smart_url">
                                <xsl:with-param name="location" select="ULink/@URL" />
                              </xsl:call-template>
-->
                              <xsl:value-of select="LinkUtils:GenerateUlink(ULink/@URL, '')"/>
                            </xsl:attribute>
                            <xsl:text>  </xsl:text>
                            <xsl:value-of select="ULink" />
                          </xsl:element>
                        </td>
                      </tr>
                      <xsl:if test="@Type='noted'">
                        <xsl:apply-templates select="document(concat($XBaseURL,ULink/@URL))" mode="items"/>
                      </xsl:if>
                      </table>
                  </td>
                </tr>
              </xsl:for-each>
              <tr>
                <td width="15%"></td>
                <td align="center" height="40"></td>
              </tr>
            </xsl:if>
          </table>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>


  <xsl:template match="Sect2">
    <xsl:apply-templates select="Title" />
    <xsl:if test="Motto">
      <tr>
        <td align="center">
          <table>
            <tr>
              <td>
                <xsl:apply-templates select="Motto/Graphic">
                  <xsl:with-param name="base" select="concat($AppImgBase,'/')" />
                </xsl:apply-templates>
              </td>
              <td>
                <h3 class="Test3">
                  <xsl:value-of select="Sect3/Title" />
                </h3>
                <xsl:apply-templates select="Sect3/LiteralLayout" />
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </xsl:if>
    <tr align="left">
      <td>
        <xsl:apply-templates select="Para" />
      </td>
    </tr>
  </xsl:template>


  <xsl:template match="Sect2/Title">
    <xsl:if test="string-length(.)>0">
      <tr align="center">
        <td align="center">
          <img src="{$AppImgBase}/bluepixel.gif" width="600" height="3"/>
        </td>
      </tr>
      <tr>
        <td>
          <h1 class="Test1">
            <xsl:value-of select="." />
          </h1>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>
