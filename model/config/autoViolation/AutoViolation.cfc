/*
model/AutoViolation.cfc
@author Peruz Carlsen
@createdate 20111005
@description AutoViolation entity
*/
component
	persistent="true"
	table="AutoViolation"
	datasource="windhavenConfig"
	output="false"
{
	// Primary Key
	property name="autoViolationID" fieldtype="id" column="autoViolationID" generator="native" setter="false";

	// Properties
	property name="violation" ormtype="string" default="";
}