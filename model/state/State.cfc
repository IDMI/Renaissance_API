/*
model/State.cfc
@author Peruz Carlsen
@createdate 20110618
@description State entity
*/
component
	persistent="true"
	table="State"
	output="false"
{
	// primary key
	property name="stateID" fieldtype="id" column="stateID" generator="native" setter="false";

	// properties
	property name="stateShort" ormtype="string" default="";
	property name="stateLong" ormtype="string" default="";
	property name="country" ormtype="string" default="";
	property name="active" ormtype="short" default="0";
}