<xsl:stylesheet version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes"/>
  <xsl:template match="/">
    <add>
      <doc>
        <field name="id">
          <xsl:value-of select="/TEI.2/@id"/>
        </field>
        <field name="date">
          <xsl:choose>
            <xsl:when test="//body//date/@value">
              <xsl:value-of select="substring(//body//date/@value,1,4)"/>
            </xsl:when>
          </xsl:choose>
        </field>
        <xsl:apply-templates/>
      </doc>
    </add>
  </xsl:template>
  <!-- ignore revisionDesc tag -->
  <xsl:template match="revisionDesc"/>
  <xsl:template match="fileDesc/titleStmt/title[1]">
    <xsl:choose>
      <xsl:when test="//titleStmt/title[@type='main']">
        <field name="title">
          <xsl:value-of select="normalize-space(//titleStmt/title[@type='main'])"/>
           
          <xsl:value-of select="normalize-space(//titleStmt/title[@type='sub'])"/>
        </field>
      </xsl:when>
      <xsl:otherwise>
        <field name="title">
          <xsl:value-of select="normalize-space(//titleStmt/title)"/>
        </field>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- author -->
  <xsl:template match="handList">
    <xsl:choose>
      <xsl:when test="//text/body/div1/sp">
        <xsl:for-each select="hand">
          <xsl:variable name="speaker" select="@id"/>
          <xsl:choose>
            <xsl:when test="//text/body/div1/sp[@who=$speaker]">
              <field name="author">
                <xsl:value-of select="@scribe"/>
              </field>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="//monogr/author">
          <field name="author">
            <xsl:value-of select="normalize-space(.)"/>
          </field>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- editor/contributor -->
  <xsl:template match="monogr[1]/editor">
    <field name="editor">
      <xsl:value-of select="."/>
    </field>
  </xsl:template>
  <!--subjects -->
  <xsl:template match="keywords/term">
    <field name="subject">
      <xsl:value-of select="normalize-space(.)"/>
    </field>
  </xsl:template>
  <xsl:template match="text()">
    <xsl:if test="normalize-space(.) != ''">
      <field name="text">
        <xsl:value-of select="normalize-space(.)"/>
      </field>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
