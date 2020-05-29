/*
model/PolicyType.cfc
@author Peruz Carlsen
@createdate 20110929
@description PolicyType entity
*/
component
	persistent="true"
	table="PolicyTypes"
	datasource="RenaissanceConfig"
	output="false"
{
	// primary key
	property name="policyTypeID" fieldtype="id" column="policyTypesID" generator="native" setter="false";

	// properties
	property name="policyType" ormtype="short" default="0";
	property name="description" ormtype="string" default="";
	property name="structName" ormtype="string" default="";
	property name="folderName" ormtype="string" default="";
}