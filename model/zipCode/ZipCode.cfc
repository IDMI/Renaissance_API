/*
model/ZipCode.cfc
@author Peruz Carlsen
@createdate 20110725
@description ZipCode entity
*/
component
	persistent="true"
	table="ZipCode"
	output="false"
{
	// primary key
	property name="zipCodeID" fieldtype="id" column="zipCodeID" type="numeric" ormtype="int" generator="native" setter="false";

	// properties
	property name="zipCode" column="zipCode" type="string" ormtype="string" default="";
	property name="city" column="city" type="string" ormtype="string" default="";
	property name="LL" column="LL" type="string" ormtype="string" default="";
	property name="FAC" column="FAC" type="string" ormtype="string" default="";
	property name="cityAbbreviated" column="cityAbbreviated" type="string" ormtype="string" default="";
	property name="areaCode" column="areaCode" type="numeric" ormtype="short";
	property name="version" column="version" type="numeric" ormtype="short" default="";
	property name="addDate" ormtype="timestamp" insert="false" update="false" setter="false";
	property name="stateID" ormtype="int" type="numeric" insert="false" update="false";
	property name="countyFIPS" ormtype="int" type="numeric" insert="false" update="false";
	property name="stateShort" persistent="false";
	property name="stateLong" persistent="false";

	// relations
	property name="county" fieldtype="many-to-one" fkcolumn="countyFIPS" cfc="model.county.County";
	property name="state" fieldtype="many-to-one" fkcolumn="stateID" cfc="model.state.State";

	public function getStateShort()
		output="false"
	{
		if (!isNull(getState())) {
			return getState().getStateShort();
		} else {
			return "";
		}
	}

	public function getStateLong()
		output="false"
	{
		if (!isNull(getState())) {
			return getState().getStateLong();
		} else {
			return "";
		}
	}
}