/*
model/SurchargeType.cfc
@author Peruz Carlsen
@createdate 20111004
@description SurchargeType entity
*/
component
	persistent="true"
	table="SurchargeTypes"
	datasource="windhavenConfig"
	output="false"
{
	// primary key
	property name="surchargeTypeID" fieldtype="id" column="SurchargeTypesID" generator="native" setter="false";

	// properties
	property name="description" ormtype="string" default="";
	property name="surchargeMask" ormtype="int" default="0";
	property name="type" ormtype="string" default="";
}