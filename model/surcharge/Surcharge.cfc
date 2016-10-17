/*
model/Surcharge.cfc
@author Peruz Carlsen
@createdate 20111005
@description PolicySurcharge entity
*/
component
	persistent="true"
	table="PolicySurcharges"
	discriminatorcolumn="parentTable"
	output="false"
{
	// primary key
	property name="policySurchargeID" column="policySurchargesID" fieldtype="id" generator="native" setter="false";

	// properties
	property name="surchargeTypeID" column="surchargeTypesID" type="numeric" ormtype="int" default="0";
	property name="surchargeMask" column="surchargeMask" type="numeric" ormtype="int" default="0";
	property name="description" column="description" type="string" ormtype="string" default="";
	property name="type" column="type" type="string" ormtype="string" default="Policy";

	// relations
	property name="policy" fieldtype="many-to-one" fkcolumn="policyID" cfc="model.policy.Policy" lazy="true" inverse="true";
}