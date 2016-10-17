/*
model/Vehicle.cfc
@author Peruz Carlsen
@createdate 20110910
@description Vehicle entity
*/
component
	persistent="true"
	table="Vehicle"
	output="false"
{
	// primary key
	property name="vehicleID" column="vehicleID" fieldtype="id" generator="native" setter="false";

	// properties
	property name="policyID" ormtype="int" type="numeric" insert="false" update="false";
	property name="vehicleNumber" column="vehicleNumber" type="numeric" ormtype="short" default="0";
	property name="vehicleYear" column="vehicleYear" type="numeric" ormtype="int" default="0";
	property name="make" column="make" type="string" ormtype="string" default="";
	property name="model" column="model" type="string" ormtype="string" default="";
	property name="vin" column="vin" type="string" ormtype="string" default="";
	property name="bodyType" column="bodyType" type="string" ormtype="string" default="";
	property name="usage" column="usage" type="string" ormtype="string" default="";
	property name="costNew" column="costNew" type="numeric" ormtype="int" default="0";
	property name="oneWayMiles" column="oneWayMiles" type="numeric" ormtype="int" default="0";
	property name="daysPerWeek" column="daysPerWeek" type="numeric" ormtype="short" default="0";
	property name="biSymbol" column="biSymbol" type="numeric" ormtype="int" default="0";
	property name="pdSymbol" column="pdSymbol" type="numeric" ormtype="int" default="0";
	property name="pipSymbol" column="pipSymbol" type="numeric" ormtype="int" default="0";
	property name="mpSymbol" column="mpSymbol" type="numeric" ormtype="int" default="0";
	property name="classCode" column="classCode" type="numeric" ormtype="int" default="0";
	property name="passiveSeatBelt" column="passiveSeatBelt" type="numeric" ormtype="short" default="0";
	property name="garageAddress1" column="garageAddress1" type="string" ormtype="string" default="";
	property name="garageAddress2" column="garageAddress2" type="string" ormtype="string" default="";
	property name="garageCity" column="garageCity" type="string" ormtype="string" default="";
	property name="garageState" column="garageState" type="string" ormtype="string" default="";
	property name="garageZip" column="garageZip" type="string" ormtype="string" default="";
	property name="territory" column="territory" type="string" ormtype="string" default="";
	property name="airbag" type="numeric" ormtype="short" default="0";
	property name="antiLockBrakes" type="numeric" ormtype="short" default="0";
	property name="is4X4" type="numeric" ormtype="short" default="0";
	property name="lienType1" column="lienType1" type="numeric" ormtype="short" default="0";
	property name="lienType2" column="lienType2" type="numeric" ormtype="short" default="0";
	property name="vehiclePremiumTotal" type="numeric" ormtype="float" default="0";
	property name="antiTheft" type="string" ormtype="string" default="";
	property name="symbolGroup" type="numeric" ormtype="short" default="0";
	property name="ratingSymbol" type="numeric" ormtype="short" default="0";
	property name="vinState" type="string" ormtype="string" default="";
	property name="tempRecord" column="tempRecord" ormtype="short" default="0";
	property name="countyCode" persistent="false" ormtype="string" default="";
	property name="vehicleZipID" column="vehicleZipID" type="string" ormtype="string" default="";
	property name="vehicleOrder" column="vehicleOrder" type="numeric" ormtype="short" default="0";
	property name="driverNumber" type="numeric" default="0" persistent="false";

	// relations
	property name="auto" fieldtype="many-to-one" fkcolumn="autoID" cfc="model.auto.Auto" lazy="true" inverse="true";
	property name="coverages" fieldtype="one-to-many" fkcolumn="objectID" joincolumn="vehicleID" where="objectName='Vehicle'" cfc="model.coverage.VehicleCoverage" singularname="coverage" cascade="all-delete-orphan";
	property name="driver" fieldtype="many-to-one" fkcolumn="driverID" cfc="model.driver.Driver" missingrowignored="true" lazy="true" inverse="true";
	property name="lienholder1" fieldtype="many-to-one" fkcolumn="lienholderID1" joincolumn="lienholderID"  cfc="model.lienholder.Lienholder" missingrowignored="true" lazy="true" inverse="true";
	property name="lienholder2" fieldtype="many-to-one" fkcolumn="lienholderID2" joincolumn="lienholderID"  cfc="model.lienholder.Lienholder" missingrowignored="true" lazy="true" inverse="true";
	property name="policy" fieldtype="many-to-one" fkcolumn="policyID" cfc="model.policy.Policy" lazy="true" inverse="true";
	property name="surcharges" fieldtype="one-to-many" fkcolumn="parentID" joincolumn="vehicleID" where="parentTable='Vehicle'" cfc="model.surcharge.VehicleSurcharge" singularname="surcharge" cascade="all-delete-orphan";

	public boolean function hasSurchargeType(required model.config.surchargeType.SurchargeType surchargeType)
		output="false"
	{
		if (isNull(getSurcharges())) {
			return false;
		}

		for (var i=1;i<=arrayLen(getSurcharges());i++) {
			if (objectEquals(getSurcharges()[i], arguments.surchargeType)) {
				return true;
			}
		}

		return false;
	}
}
