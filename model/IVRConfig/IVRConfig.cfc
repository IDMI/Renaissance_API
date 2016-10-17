/*
beans/IVRConfig.cfc
@author Peruz Carlsen
@createdate 20120110
@description IVR_Config entity
*/
component
	persistent="true"
	table="IVR_Config"
	output="false"
{
	// primary key
	property name="IVRConfigID" column="IVR_ConfigID" type="numeric" ormtype="int" fieldtype="id" generator="native" setter="false";

	// properties
	property name="serverInstance" column="serverInstance" type="string" ormtype="string" default="";
	property name="serverKey" column="serverKey" type="string" ormtype="string" default="";
	property name="softwareVersion" column="softwareVersion" type="string" ormtype="string" default="";
	property name="dataSource" column="dataSource" type="string" ormtype="string" default="";
	property name="port" column="port" type="numeric" ormtype="short" default="0";
	property name="mailServer" column="mailServer" type="string" ormtype="string" default="";
	property name="mailPort" column="mailPort" type="numeric" ormtype="short" default="0";
	property name="mailList" column="mailList" type="string" ormtype="string" default="";
	property name="errorReportMethod" column="errorReportMethod" type="numeric" ormtype="short" default="0";
}
