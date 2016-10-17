/*
model/Driver.cfc
@author Peruz Carlsen
@createdate 20110910
@description Driver entity
*/
component
	persistent="true"
	table="Driver"
	output="false"
{
	// primary key
	property name="driverID" column="driverID" fieldtype="id" generator="native" setter="false";

	// properties
	property name="policyID" ormtype="int" type="numeric" insert="false" update="false";
	property name="driverNumber" column="driverNumber" type="numeric"ormtype="short" default="0";
	property name="fname" column="fname" type="string" ormtype="string" default="";
	property name="middle" column="middle" type="string" ormtype="string" default="";
	property name="lname" column="lname" type="string" ormtype="string" default="";
	property name="dob" column="dob" ormtype="timestamp" default="";
	property name="gender" column="gender" type="string" ormtype="string" default="";
	property name="maritalStatus" column="maritalStatus" type="numeric"ormtype="short" default="0";
	property name="driverType" column="driverType" type="numeric"ormtype="short" default="0";
	property name="licState" column="licState" type="string" ormtype="string" default="";
	property name="licNum" column="licNum" type="string" ormtype="string" default="";
	property name="licenseStatus" column="licenseStatus" type="numeric" ormtype="short" default="0";
	property name="namedInsured" column="namedInsured" type="numeric"ormtype="short" default="0";
	property name="relationToApplicant" column="relationToApplicant" type="string" ormtype="string" default="";
	property name="occupation" column="occupation" type="string" ormtype="string" default="";
	property name="principalOperator" column="principalOperator" type="numeric"ormtype="short" default="0";
	property name="goodStudent" column="goodStudent" type="numeric"ormtype="short" default="0";
	property name="goodStudentDate" persistent="false" default="";
	property name="defensiveDriver" column="defensiveDriver" type="numeric" ormtype="short" default="0";
	property name="defensiveDriverDate" persistent="false" default="";
	property name="driverTraining" column="driverTraining" type="numeric" ormtype="short" default="0";
	property name="driverTrainingDate" column="driverTrainingDate" ormtype="timestamp" default="";
	property name="dateLicensed" column="dateLicensed" ormtype="timestamp" default="";
	property name="MVRStatus" column="MVRStatus" ormtype="short" default="0";
	property name="MVRDate" column="MVRDate" ormtype="timestamp" default="";
	property name="checkMVR" column="checkMVR" ormtype="short" default="0";
	property name="sdipPoints" column="sdipPoints" ormtype="short" default="0";
	property name="requiresSR22" column="requiresSR22" ormtype="short" default="0";
	property name="tempRecord" column="tempRecord" ormtype="short" default="0";
	property name="driverOrder" column="driverOrder" type="numeric" ormtype="short" default="0";
	property name="driverClass" type="string" ormtype="string" default="";
	property name="age" type="numeric" default="0" persistent="false";
	property name="vehicleNumber" type="numeric" default="0" persistent="false";

	// relations
	property name="auto" fieldtype="many-to-one" fkcolumn="autoID" cfc="model.auto.Auto" lazy="true" inverse="true";
	property name="driverAccidents" fieldtype="one-to-many" fkcolumn="driverID" cfc="model.driverAccident.DriverAccident" singularname="driverAccident" cascade="all-delete-orphan";
	property name="policy" fieldtype="many-to-one" fkcolumn="policyID" cfc="model.policy.Policy" lazy="true" inverse="true";

	public numeric function getDriverAge(date today = now())
		output="false"
	{
		if (!isDate(getDOB())) {
			return 0;
		}

		return numberFormat(dateDiff("d", dateFormat(getDOB(), "m/d/yyyy"), dateFormat(arguments.today, "m/d/yyyy")) / 365.25);
	}

	public string function getMaritalStatusShort()
		output="false"
	{
		switch(getMaritalStatus()) {
			case "10":
				return "S";
			case "0":
				return "M";
			default:
				return "";
		}
	}
}