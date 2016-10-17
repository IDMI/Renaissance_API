/*
model/County.cfc
@author Peruz Carlsen
@createdate 20110725
@description County entity
*/
component
	persistent="true"
	table="County"
	output="false"
{
	// primary key
	property name="id" column="countyID" fieldtype="id" type="numeric" ormtype="int" generator="native" setter="false";

	// Properties
	property name="stateID" ormtype="int" type="numeric" insert="false" update="false";
	property name="stateShort" column="stateShort" type="string" ormtype="string" default="";
	property name="countyFIPS" column="countyFIPS" type="string" ormtype="string" default="";
	property name="name" column="county" type="string" ormtype="string" default="";
	property name="description" column="countyDesc" type="string" ormtype="string" default="";
	property name="descriptionLong" column="countyDescLong" type="string" ormtype="string" default="";
	property name="isCoastal" column="isCoastal" type="numeric" ormtype="byte" default="0";
	property name="ISOTerritory" column="ISOTerritory" type="string" ormtype="string" default="";
	property name="NAIITerritory" column="NAIITerritory" type="string" ormtype="string" default="";
	property name="tier" column="tier" type="numeric" ormtype="short" default="0";
	property name="zone" column="zone" type="string" ormtype="string" default="";
	property name="code" column="countyCode" type="string" ormtype="string" default="";
	property name="version" column="version" type="numeric" ormtype="short" default="0";

	// relations
	property name="state" fieldtype="many-to-one" fkcolumn="stateID" cfc="model.state.State" missingrowignored="true";
}