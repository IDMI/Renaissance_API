/*
model/PolicyDiscount.cfc
@author Peruz Carlsen
@createdate 20111003
@description PolicyDiscount entity
*/
component
	persistent="true"
	table="PolicyDiscounts"
	extends="Discount"
	discriminatorvalue="Policy"
	output="false"
{
	// relations
	property name="parent" fieldtype="many-to-one" fkcolumn="parentID" joincolumn="policyID" cfc="model.policy.Policy" lazy="true" inverse="true";
}