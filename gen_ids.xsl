<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:uuid="http://www.uuid.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="uuid.xsl"/>
	<xsl:template match="*">
      <xsl:copy>
        <!-- UUID works with Saxon -->
        <xsl:attribute name="uuid"><xsl:value-of select="uuid:get-uuid()"/></xsl:attribute>
        <xsl:attribute name="id"><xsl:value-of select="uuid:get-uuid()"/></xsl:attribute>
        <xsl:attribute name="parent-id"><xsl:value-of select="generate-id(parent::*)"/></xsl:attribute>
        <xsl:for-each select="@*">
          <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
        </xsl:for-each>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:template>
</xsl:stylesheet>