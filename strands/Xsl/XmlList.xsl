<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:LinkUtils="urn:StrandsExtension">
  <xsl:import href="jbarticle.xsl" />

  <xsl:output method="html" encoding="iso-8859-1" />

  <xsl:param name="AppURL" select="''" />
  <xsl:param name="AppBase" select="''" />
  <xsl:param name="XBaseURL" select="''"/>
  <xsl:param name="AppImgBase" select="''"/>
  <xsl:param name="ArticleBase" select="''" />
  <xsl:param name="DocBase" select="''" />
  <xsl:param name="Sect" select="*"/>
  <xsl:param name="SrcURL" select="''" />
  <xsl:param name="JScript" select="'strands.js'" />
  <xsl:param name="cssclasstype" select ="''" />

  <xsl:variable name="class">
    <xsl:choose>
      <xsl:when test="$Sect[@Id='TOC']">
        <xsl:value-of select="concat($cssclasstype,'toc')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$cssclasstype" />
      </xsl:otherwise> 
    </xsl:choose>
  </xsl:variable>  


  <xsl:template match="/">
			<script type="text/javascript" language="JavaScript">
				function navigateTo (adr){
					if (window.opener.location.href != adr)
						window.opener.location.href=adr;
				}

				function visibilityToggle(id) {
					var el = document.getElementById(id).style;

					if(el.display == "none") {
					el.display = "block";
					}
					else if(el.display == "block") {
					el.display = "none";
					}
				}
			</script>

		<xsl:apply-templates select="$Sect" />
  </xsl:template>    
  

  <xsl:template match="Sect1/Title">
    <h1 class="{$class}">
      <xsl:value-of select="." />
    </h1>
  </xsl:template>


  <xsl:template match="Title">
    <h1 class="{$class}">
      <xsl:value-of select="." />
    </h1>
  </xsl:template>


  <xsl:template match="Insertion">
    <div class="{$class}">
      <xsl:apply-templates />
    </div>
  </xsl:template>


  <xsl:template match = "OrderedList">
    <ol class="{$class}">
      <xsl:apply-templates select="ListItem"/>
    </ol>
  </xsl:template>


  <xsl:template match = "ItemizedList">
    <ul class="{$class}">
      <xsl:apply-templates select="ListItem"/>
    </ul>
  </xsl:template>


  <xsl:template match = "BiblioItem">
    <p class="{$class}">
      <xsl:call-template name = "id-and-children"/>
    </p>
  </xsl:template>


  <xsl:template match = "ListItem">
    <li class="{$class}">
      <xsl:apply-templates/>
    </li>
  </xsl:template>


  <xsl:template match = "Para">
    <p class="{$class}">
      <xsl:apply-templates/>
    </p> 
  </xsl:template>


  <xsl:template match = "LiteralLayout">
    <pre class="{$class}">
      <xsl:apply-templates/>
    </pre>
  </xsl:template>

  
  <xsl:template match = "Link">
    <xsl:element name="a">
      <xsl:attribute name="class">
        <xsl:value-of select="$class" />
      </xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="'###'" />
      </xsl:attribute>
      <xsl:attribute name="onClick">
        <xsl:variable name="Strand">
          <xsl:value-of select="LinkUtils:GenerateUlink($SrcURL, @Linkend, 'Subpoem')"/>
        </xsl:variable>

        <xsl:value-of select="concat('window.open(&quot;', $Strand, '&quot;, &quot;BOX&quot;, &quot;scrollbars,width=700,height=650,left=20,top=20&quot;)')" />
      </xsl:attribute>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>


  <xsl:template match = "DLink">
    <a class="{$class}" href="{$DocBase}{@Document}" target="-blank" title="View Fulltext">
      <xsl:apply-templates/>
    </a>
  </xsl:template>


  <xsl:template match = "ELink">
    <a class="{$class}" href="{@URL}" target="_blank">
      <xsl:apply-templates/>
    </a>
  </xsl:template>


  <xsl:template match = "BiblioEntry">
    <xsl:apply-templates />
    <xsl:if test="@Id" >
      <xsl:variable name="docno" select="substring-after(@Id,'RQ')" />
      
        <a href="http://www.riquest.de/default.aspx?tabindex=0&amp;tabitem=0&amp;QRY=$access${$docno}" target="riquest" title="open catalog">
        <img src="{$AppImgBase}/catalog.gif" align="top" alt="open catalog" width="9" height="6" border="0" />
      </a>
    </xsl:if>
  </xsl:template>


  <xsl:template match="Article">
		<xsl:call-template name="Article.SubIndex" />
  </xsl:template>


  <xsl:template name="Article.SubIndex">
    <xsl:variable name="paragraph" select="'0'" />

    <xsl:variable name="parString">
        <xsl:if test="not($paragraph='0')">
          <xsl:value-of select="concat('&amp;P=',$paragraph)" />
        </xsl:if>
    </xsl:variable>
    
		<xsl:if test="Sect1">
      <table border="0" align="center" cellspacing="5" cellpadding="5">
				<xsl:for-each select="Sect1">
					<tr>
            <td class="shadow">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="'###'" />
                </xsl:attribute>
                <xsl:attribute name="onClick">
                  <xsl:variable name="Strand">
                    <xsl:value-of select="LinkUtils:GenerateUlink($SrcURL, count(preceding-sibling::Sect1) + 1)"/>
                  </xsl:variable>

                  <xsl:value-of select="concat('navigateTo(&quot;', $Strand, '&quot;)')" />
                </xsl:attribute>
                <img src="{$AppImgBase}/bluepixel.gif" border="0" alt="{Title}" align="middle" width="15" height="15" />
              </xsl:element>
              
            </td>
            <td align="left">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="'###'" />
                </xsl:attribute>
                <xsl:attribute name="onClick">
                  <xsl:variable name="Strand">
                    <xsl:value-of select="LinkUtils:GenerateUlink($SrcURL, count(preceding-sibling::Sect1) + 1)"/>
                  </xsl:variable>

                  <xsl:value-of select="concat('navigateTo(&quot;', $Strand, '&quot;)')" />
                </xsl:attribute>
                <xsl:value-of select="concat(number(position()), ' ')" />
                <xsl:apply-templates select="Title" mode="Index" />
              </xsl:element>
            </td>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>
  </xsl:template>


  <xsl:template match="Title" mode="Index">
			<xsl:apply-templates />
	</xsl:template>


  <xsl:template match = "Citation">
    <xsl:if test="//BiblioItem[@Id=string(current()/@Linkend)]/BiblioEntry/@Id">
      <xsl:variable name="docno" select="substring-after(//BiblioItem[@Id=string(current()/@Linkend)]/BiblioEntry/@Id,'RQ')" />
      <a class="comment" href="http://www.riquest.de/default.aspx?QRY=$access${$docno}" target="riquest" title="open catalog">
        <xsl:apply-templates/>
      </a>
    </xsl:if>
  </xsl:template>


  <xsl:template match="Bibliography">
    <span class="{$class}">
      <xsl:apply-templates />
    </span>
  </xsl:template>


  <xsl:template match="Note">
    <span class="{$class}">
      <xsl:apply-templates />
    </span>
  </xsl:template>

  
  <xsl:template match="Graphic">
    <div>
      <img src="{$AppBase}{@FileRef}" height="{@Depth}" width="{@Width}" alt="{@Alt}" />
    </div>
  </xsl:template>


  <xsl:template match="InlineGraphic">
    <img src="{$AppBase}{@FileRef}" height="{@Depth}" width="{@Width}" align="{@Align}" alt="{@Alt}" />
  </xsl:template>

</xsl:stylesheet>
