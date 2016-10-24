/*
model/Payment.cfc
@author Peruz Carlsen
@createdate 20110627
@description Payment entity
*/
component
	persistent="true"
	table="Payment"
	output="false"
{
	// primary key
	property name="paymentID" fieldtype="id" column="paymentID" generator="native" setter="false";

	// properties
	property name="paymentDate" ormtype="timestamp";
	property name="amount" ormtype="float" default="0";
	property name="paymentType" ormtype="short" default="0";
	property name="method" ormtype="short" default="0";
	property name="checkNum" ormtype="string" default="";
	property name="note" ormtype="string" default="";
	property name="depositNum" ormtype="int" default="0";
	property name="isDeposit" ormtype="short" default="0";
	property name="addDate" ormtype="timestamp" insert="false" update="false" setter="false";
	property name="invoiced" ormtype="short" default="0";
	property name="invoiceDate" ormtype="timestamp";
	property name="invoiceEndDate" ormtype="timestamp";
	property name="status" ormtype="short" default="0";
	property name="financeCompanyID" ormtype="int" default="1";
	property name="refundDate" ormtype="timestamp";
	property name="accountExpenseID" ormtype="int" default="1";
	property name="invoiceID" ormtype="int" default="1";
	property name="postMarkedDate" ormtype="timestamp";
	property name="noTrans" ormtype="short" default="0";
	property name="paymentMethod" default="0" generated="never" insert="false" update="false" persistent="false";
	property name="confirmationNum" type="string" persistent="false" default="" setter="false";

	// relations
	property name="policy" fieldtype="many-to-one" fkcolumn="policyID" cfc="model.policy.Policy" lazy="true" inverse="true";
	property name="insured" fieldtype="many-to-one" fkcolumn="insuredID" cfc="model.insured.Insured" lazy="true" inverse="true";
	property name="producer" fieldtype="many-to-one" fkcolumn="producerID" cfc="model.producer.Producer" lazy="true" inverse="true";
	property name="company" fieldtype="many-to-one" fkcolumn="companyID" cfc="model.company.Company" lazy="true" inverse="true";
	property name="user" fieldtype="many-to-one" fkcolumn="usersID" cfc="model.user.User" lazy="true" inverse="true";
	property name="voidPayment" fieldtype="many-to-one" fkcolumn="voidPaymentID" joincolumn="paymentID" cfc="model.payment.Payment" lazy="true" inverse="true" missingrowignored="true";
	property name="trans" fieldtype="one-to-many" fkcolumn="paymentID" cfc="model.trans.Trans" singularname="tran" lazy="extra";
	//property name="IVRPayment" fieldtype="one-to-many" fkcolumn="paymentID" cfc="model.IVRPayment.IVRPayment";

	this.constraints = {
		"paymentDate" = {"required" = true, type="date"},
		"amount" = {"required" = true, type="numeric"},
		"paymentType" = {"required" = true, type="integer"},
		"method" = {"required" = true, type="integer"},
		"postMarkedDate" = {"required" = true, type="date"}
	};

	/**
    @author Peruz Carlsen
    @createdate 20120329
    @hint Returns confirmation number
    @output false
    **/
    public string function getConfirmationNum() {
    	if (isNull(getPaymentID())) {
    		return "";
    	}

    	return timeFormat(getPaymentDate(), "HHmm") & dateFormat(getPaymentDate(), "mmddyyyy") & right(repeatString("0", 7) & getPaymentID(), 7);
    }

	public string function getMethodAsText()
		output="false"
	{
		switch (getMethod()) {
			case 9:
				return "Credit Card";
			case 10:
				return "Bank Draft";
			default:
				return "n/a";
		}
	}
}