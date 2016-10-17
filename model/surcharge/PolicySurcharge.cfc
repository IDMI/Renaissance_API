/*
model/PolicySurcharge.cfc
@author Peruz Carlsen
@createdate 20111005
@description PolicySurcharge entity
*/
component
	persistent="true"
	table="PolicySurcharges"
	extends="Surcharge"
	discriminatorvalue="Policy"
	output="false"
{
	// relations
	property name="parent" fieldtype="many-to-one" fkcolumn="parentID" joincolumn="policyID" cfc="model.policy.Policy" lazy="true" inverse="true";
}