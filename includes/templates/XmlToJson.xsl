<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="no" omit-xml-declaration="yes" method="text" encoding="UTF-8" media-type="application/json"/>
	<xsl:strip-space elements="*"/>

	<!-- used to identify unique children in Muenchian grouping, credit Martynas Jusevicius http://www.xml.lt -->
	<xsl:key name="elements-by-name" match="@* | *" use="concat(generate-id(..), '@', name(.))"/>

	<!-- string -->
	<xsl:template match="text()">
		<xsl:call-template name="processValues">
			 <xsl:with-param name="s" select="."/>
		</xsl:call-template>
	</xsl:template>

	<!-- text values (from text nodes and attributes) -->
	<xsl:template name="processValues">
		<xsl:param name="s"/>
		<xsl:choose>
			<!-- number -->
			<xsl:when test="not(string(number($s))='NaN')">
				<xsl:value-of select="$s"/>
			</xsl:when>
			<!-- boolean -->
			<xsl:when test="translate($s,'TRUE','true')='true'">true</xsl:when>
			<xsl:when test="translate($s,'FALSE','false')='false'">false</xsl:when>
			<!-- string -->
			<xsl:otherwise>
				<xsl:call-template name="escapeArtist">
					<xsl:with-param name="s" select="$s"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- begin filter chain -->
	<xsl:template name="escapeArtist">
		<xsl:param name="s"/>
		"
		<xsl:call-template name="escapeBackslash">
			<xsl:with-param name="s" select="$s"/>
		</xsl:call-template>
		"
	</xsl:template>

	<!-- escape the backslash (\) before everything else. -->
	<xsl:template name="escapeBackslash">
		<xsl:param name="s"/>
		<xsl:choose>
			<xsl:when test="contains($s,'\')">
				<xsl:call-template name="escapeQuotes">
					<xsl:with-param name="s" select="concat(substring-before($s,'\'),'\\')"/>
				</xsl:call-template>
				<xsl:call-template name="escapeBackslash">
					<xsl:with-param name="s" select="substring-after($s,'\')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="escapeQuotes">
					<xsl:with-param name="s" select="$s"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- escape the double quote ("). -->
	<xsl:template name="escapeQuotes">
		<xsl:param name="s"/>
		<xsl:choose>
			<xsl:when test="contains($s,'&quot;')">
				<xsl:call-template name="encoder">
					<xsl:with-param name="s" select="concat(substring-before($s,'&quot;'),'\&quot;')"/>
				</xsl:call-template>
				<xsl:call-template name="escapeQuotes">
					<xsl:with-param name="s" select="substring-after($s,'&quot;')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="encoder">
					<xsl:with-param name="s" select="$s"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- encode tab, line feed and/or carriage return-->
	<xsl:template name="encoder">
		<xsl:param name="s"/>
		<xsl:choose>
			<!-- tab -->
			<xsl:when test="contains($s,'&#x9;')">
				<xsl:call-template name="encoder">
					<xsl:with-param name="s" select="concat(substring-before($s,'&#x9;'),'$${tab}',substring-after($s,'&#x9;'))"/>
				</xsl:call-template>
			</xsl:when>
			<!-- line feed -->
			<xsl:when test="contains($s,'&#xA;')">
				<xsl:call-template name="encoder">
					<xsl:with-param name="s" select="concat(substring-before($s,'&#xA;'),'$${line}',substring-after($s,'&#xA;'))"/>
				</xsl:call-template>
			</xsl:when>
			<!-- carriage return -->
			<xsl:when test="contains($s,'&#xD;')">
				<xsl:call-template name="encoder">
					<xsl:with-param name="s" select="concat(substring-before($s,'&#xD;'),'$${carriage}',substring-after($s,'&#xD;'))"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$s"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- main handler template
		creates a struct containing: the node text(); struct of attributes; and set a struct key for any node children.
		this template then drills into the children, repeating itself until complete
	-->
	<xsl:template name="processNode">
		{
			"text":
			<xsl:call-template name="escapeArtist">
				<xsl:with-param name="s" select="key('elements-by-name', concat(generate-id(..), '@', name(.)))/text()"/>
			</xsl:call-template>
			,"attributes":{
				<xsl:for-each select="@*">
					<xsl:call-template name="escapeArtist">
						<xsl:with-param name="s" select="name()"/>
					</xsl:call-template>
					:
					<xsl:call-template name="processValues">
						<xsl:with-param name="s" select="."/>
					</xsl:call-template>
					<xsl:if test="position() &lt; count(parent::node()/attribute::*)">
						,
					</xsl:if>
				</xsl:for-each>
			}
			<!-- drill down the tree -->
			<xsl:for-each select="*[generate-id(.) = generate-id(key('elements-by-name', concat(generate-id(..), '@', name(.))))]">
				,
				<xsl:call-template name="escapeArtist">
					<xsl:with-param name="s" select="name()"/>
				</xsl:call-template>
				:
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		}
	</xsl:template>

	<!-- main parser
		basically a node 'loop' - performed once for all matches of *, so once for each node including the root.
		note: this loop has no knowledge of other iterations it may have performed.
	-->
	<xsl:template match="*">
		<!-- determine whether any peers share the node name, so we can spool off into 'array mode' -->
		<xsl:variable name="isArray" select="count(key('elements-by-name', concat(generate-id(..), '@', name(.)))) &gt; 1"/>

		<xsl:if test="count(ancestor::node()) = 1"><!-- begin the root node-->
			{
			<xsl:call-template name="escapeArtist">
				<xsl:with-param name="s" select="name()"/>
			</xsl:call-template>
			:
		</xsl:if>

		<xsl:if test="not($isArray)">
			<xsl:call-template name="processNode">
				<xsl:with-param name="s" select="."/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$isArray">
			[
				<xsl:apply-templates select="key('elements-by-name', concat(generate-id(..), '@', name(.)))" mode="array"/>
			]
		</xsl:if>
		<xsl:if test="count(ancestor::node()) = 1">}</xsl:if><!-- close the root node -->
	</xsl:template>

	<!-- array template called from main parser -->
	<xsl:template match="*" mode="array">
		<xsl:call-template name="processNode">
			<xsl:with-param name="s" select="."/>
		</xsl:call-template>
		<xsl:if test="position() != last()">,</xsl:if>
	</xsl:template>
</xsl:stylesheet>