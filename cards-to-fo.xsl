<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" indent="yes"/>
    <xsl:attribute-set name="page-size">
        <xsl:attribute name="page-height">4in</xsl:attribute>
        <xsl:attribute name="page-width">6in</xsl:attribute>
        <xsl:attribute name="margin-top">0.125in</xsl:attribute>
        <xsl:attribute name="margin-left">0.125in</xsl:attribute>
        <xsl:attribute name="margin-right">0.125in</xsl:attribute>
        <xsl:attribute name="margin-bottom">0.125in</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="block-decoration">
        <xsl:attribute name="border-color">black</xsl:attribute>
        <xsl:attribute name="border-left-style">solid</xsl:attribute>
        <xsl:attribute name="border-left-width">thin</xsl:attribute>
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-width">thin</xsl:attribute>
        <xsl:attribute name="padding-left">2mm</xsl:attribute>
        <xsl:attribute name="space-after">1mm</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="element-formatting">
        <xsl:attribute name="font-family">Times Roman</xsl:attribute>
        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="text-align">left</xsl:attribute>
		<xsl:attribute name="text-indent">0em</xsl:attribute>
		<xsl:attribute name="start-indent">0mm</xsl:attribute>
		<xsl:attribute name="end-indent">0mm</xsl:attribute>
		<!-- Shrink line height -->
		<!--  xsl:attribute name="line-height">8pt</xsl:attribute-->
    </xsl:attribute-set>

	<xsl:template name="define-layout">
		<fo:layout-master-set>
			<fo:simple-page-master master-name="a-page" xsl:use-attribute-sets="page-size">
				<fo:region-body xsl:use-attribute-sets="page-size" display-align="center" />
				<!-- fo:region-before extent="1cm" /-->
			</fo:simple-page-master>
			<fo:page-sequence-master master-name="page-layout">
				<fo:repeatable-page-master-reference master-reference="a-page" />
			</fo:page-sequence-master>
		</fo:layout-master-set>
	</xsl:template>
    
    <xsl:template match="/">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <xsl:call-template name="define-layout"/>
            <fo:page-sequence master-reference="page-layout">
				<fo:flow flow-name="xsl-region-body">
        	        <xsl:apply-templates/>
				</fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>

    <xsl:template match="card">
		<xsl:apply-templates select="question"/>
		<xsl:apply-templates select="answer"/>
    </xsl:template>

<!--     
    <xsl:template  match="question">
		<fo:block xsl:use-attribute-sets="element-formatting" 
			page-break-after="always" 
			white-space-treatment="inherit"
          	linefeed-treatment="preserve">
			<xsl:value-of select="text()" />
		</fo:block>
    </xsl:template>

   	<xsl:template match="answer">
		<fo:block xsl:use-attribute-sets="element-formatting" 
			page-break-after="always" 
			white-space-treatment="inherit"
          	linefeed-treatment="preserve">
			<xsl:value-of select="text()" />
		</fo:block>
    </xsl:template>
 -->

<!--
WRAP EACH LINE IN A BLOCK
--> 
    <xsl:template  match="question">
		<fo:block-container xsl:use-attribute-sets="element-formatting" 
			page-break-after="always">
			<xsl:apply-templates/>
		</fo:block-container>
    </xsl:template>

   	<xsl:template match="answer">
		<fo:block-container xsl:use-attribute-sets="element-formatting" 
			page-break-after="always">
			<xsl:apply-templates/>
		</fo:block-container>
    </xsl:template>

	<xsl:template match="text()">
		<xsl:for-each select="tokenize(., '\n\r?')">
		<xsl:variable name="line" select="."/>
		<fo:block xsl:use-attribute-sets="element-formatting" linefeed-treatment="ignore">
	      	<xsl:if test=".">
	      		<xsl:attribute name="white-space-treatment">inherit</xsl:attribute>
	      	</xsl:if>
	      	<xsl:if test="not(.)">
	      		<xsl:attribute name="white-space-treatment">preserve</xsl:attribute>
				<!-- Add a space to preserve a blank line -->
	      		<xsl:text> </xsl:text>
	      	</xsl:if>
			<xsl:value-of select="."/>
		</fo:block>
		<!-- Use a block for space-after, since FOP doesn't support it -->
		<xsl:if test=".">
		<fo:block white-space-treatment="preserve" font-size="4pt"><xsl:text> </xsl:text></fo:block>
		</xsl:if>
	 	</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
