/*
model/PaymentInfo.cfc
@author Peruz Carlsen
@createdate 20110627
@description PaymentInfo entity
*/
component
	persistent="true"
	table="PaymentInfo"
	output="false"
{
	// primary key
	property name="paymentInfoID" fieldtype="id" column="paymentInfoID" generator="native" setter="false";

	// properties
	property name="paymentName" ormtype="string" default="";
	property name="paymentInfoType" ormtype="short" default="0";
	property name="lastPaymentDate" ormtype="timestamp";
	property name="recurringPayment" ormtype="short" default="0";
	property name="lastPaymentDetailID" ormtype="int" default="1";
	property name="addDate" ormtype="timestamp" insert="false" update="false" setter="false";
	property name="address1" ormtype="string" default="";
	property name="address2" ormtype="string" default="";
	property name="city" ormtype="string" default="";
	property name="state" ormtype="string" default="";
	property name="zip" ormtype="string" default="";
	property name="phone" ormtype="string" default="";
	property name="status" ormtype="short" default="0";
	property name="producerID" ormtype="int" default="1";
	property name="bankRoutingNum" ormtype="string" default="";
	property name="bankName" ormtype="string" default="";
	property name="bankAddress1" ormtype="string" default="";
	property name="bankAddress2" ormtype="string" default="";
	property name="bankCity" ormtype="string" default="";
	property name="bankState" ormtype="string" default="";
	property name="bankZip" ormtype="string" default="";
	property name="bankAcctNum" ormtype="string" default="";
	property name="ccType" ormtype="short" default="0";
	property name="ccNumber" ormtype="string" default="";
	property name="ccExpDate" ormtype="date";
	property name="ccSecurity1" ormtype="string" default="";
	property name="ccSecurity2" ormtype="string" default="";
	property name="ccCountry" ormtype="string" default="";
	property name="ccProcessingCenter" ormtype="short" default="0";
	property name="cardID" ormtype="string" default="";
	property name="responseText" ormtype="string" default="";

	// relations
	property name="insured" fieldtype="many-to-one" fkcolumn="insuredID" cfc="model.insured.Insured" lazy="true" inverse="true";
	property name="policy" fieldtype="many-to-one" fkcolumn="policyID" cfc="model.policy.Policy" lazy="true" inverse="true";
	property name="user" fieldtype="many-to-one" fkcolumn="usersID" cfc="model.user.User" lazy="true" inverse="true";

	this.constraints = {
		"paymentName" = {"required" = true},
		"paymentInfoType" = {"required" = true, type="integer"},
		"address1" = {"required" = true},
		"city" = {"required" = true},
		"state" = {"required" = true},
		"zip" = {"required" = true, type="zipcode"}
	};

	public string function getCCTypeLongDescription()
		hint="I return ccType as string"
		output="false"
	{
		switch (getCCType()) {
			case 1:
				return "American Express";
			case 2:
				return "MasterCard";
			case 3:
				return "Visa";
			case 4:
				return "Discover";
			default:
				return "Unknown";
		}
	}

	public string function getCCTypeShortDescription()
		hint="I return ccType as string"
		output="false"
	{
		switch (getCCType()) {
			case 1:
				return "Amex";
			case 2:
				return "MC";
			case 3:
				return "VI";
			case 4:
				return "DC";
			default:
				return "??";
		}
	}
}