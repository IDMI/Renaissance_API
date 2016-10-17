/*
model/Discount.cfc
@author Peruz Carlsen
@createdate 20111003
@description PolicyDiscount entity
*/
component
	persistent="true"
	table="PolicyDiscounts"
	discriminatorcolumn="parentTable"
	output="false"
{
	// primary key
	property name="policyDiscountID" column="policyDiscountsID" fieldtype="id" generator="native" setter="false";

	// properties
	property name="discountTypeID" column="discountTypesID" type="numeric" ormtype="int" default="0";
	property name="discountMask" column="discountMask" type="numeric" ormtype="int" default="0";
	property name="description" column="description" type="string" ormtype="string" default="";
	property name="type" column="type" type="string" ormtype="string" default="Policy";

	// relations
	property name="policy" fieldtype="many-to-one" fkcolumn="policyID" cfc="model.policy.Policy" lazy="true" inverse="true";
}