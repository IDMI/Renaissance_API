<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Luis Majano
Date        :	10/16/2007
Description :
	This is the bootstrapper Application.cfc for ColdBox Applications.
	It uses inheritance on the CFC, so if you do not want inheritance
	then use the Application_noinheritance.cfc instead.


----------------------------------------------------------------------->
<cfcomponent extends="coldbox.system.Coldbox" output="false">
	<cfsetting enablecfoutputonly="yes">

	<cfscript>
   		this.name = hash(getCurrentTemplatePath());
   		this.sessionManagement = true;
   		this.sessionTimeout = createTimeSpan(0,0,30,0);
   		this.setClientCookies = true;
   		this.mappings["/"] = getDirectoryFromPath(getCurrentTemplatePath());

       	// ORM Settings
       	this.ormEnabled = true;
       	this.datasource = "windhaven";
       	this.ormSettings = {
	       	cfclocation = "model",
	       	dbcreate = "none",
	       	logSQL = false,
	       	flushAtRequestEnd = false,
	       	autoManageSession = false,
			eventHandling = true,
			eventHandler = "model.system.orm.hibernate.EventHandler",
			skipCFCWithError = false
       	};
   	</cfscript>

	<!--- COLDBOX STATIC PROPERTY, DO NOT CHANGE UNLESS THIS IS NOT THE ROOT OF YOUR COLDBOX APP --->
	<cfset COLDBOX_APP_ROOT_PATH = getDirectoryFromPath(getCurrentTemplatePath())>
	<!--- The web server mapping to this application. Used for remote purposes or static purposes --->
	<cfset COLDBOX_APP_MAPPING   = "">
	<!--- COLDBOX PROPERTIES --->
	<cfset COLDBOX_CONFIG_FILE   = "">
	<!--- COLDBOX APPLICATION KEY OVERRIDE --->
	<cfset COLDBOX_APP_KEY       = "">

	<!--- on Request Start --->
	<cffunction name="onRequestStart" returnType="boolean" output="true">
		<!--- ************************************************************* --->
		<cfargument name="targetPage" type="string" required="true" />
		<!--- ************************************************************* --->

		<cfscript>
		if (ListFindNoCase(cgi.server_name, "live", ".") && cgi.https != "on") {
			cfheader(statusCode="403", statusText="Forbidden");
			throw(message="Unauthorized request", type="Application", errorCode="403.SVSSL");
		}
		</cfscript>

		<!--- Process A ColdBox Request Only --->
		<cfif findNoCase('index.cfm', listLast(arguments.targetPage, '/'))>
			<!--- Reload Checks --->
			<cfset reloadChecks()>
			<!--- Process Request --->
			<cfset processColdBoxRequest()>
		</cfif>

		<!--- WHATEVER YOU WANT BELOW --->
		<cfreturn true>
	</cffunction>
</cfcomponent>