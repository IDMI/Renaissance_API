component persistent="true" table="ECSTransactions" schema="dbo" {
	// id
	property name="id" fieldtype="id" ormtype="int" type="numeric" generator="native";

	// fields
	property name="policyID" ormtype="int" type="numeric";
	property name="invoiceID" ormtype="int" type="numeric";
	property name="paymentID" ormtype="int" type="numeric";
	property name="userID" ormtype="int" type="numeric";
	property name="transactionID" ormtype="string" type="string";
	property name="type" ormtype="string" type="string";
	property name="payment" ormtype="string" type="string";
	property name="amount" ormtype="big_decimal" scale="2" type="numeric";
	property name="ccNumber" ormtype="string" type="string";
	property name="ccExp" ormtype="string" type="string";
	property name="checkaba" ormtype="string" type="string";
	property name="checkaccount" ormtype="string" type="string";
	property name="account_type" ormtype="string" type="string";
	property name="payment_name" ormtype="string" type="string";
	property name="address1" ormtype="string" type="string";
	property name="address2" ormtype="string" type="string";
	property name="city" ormtype="string" type="string";
	property name="state" ormtype="string" type="string";
	property name="zip" ormtype="string" type="string";
	property name="country" ormtype="string" type="string";
	property name="phone" ormtype="string" type="string";
	property name="fax" ormtype="string" type="string";
	property name="email" ormtype="string" type="string";
	property name="customer_vault" ormtype="string" type="string";
	property name="customer_vault_id" ormtype="string" type="string";
	property name="ipAddress" ormtype="string" type="string";
	property name="response" ormtype="short" type="numeric";
	property name="responseText" ormtype="string" type="string";
	property name="response_code" ormtype="short" type="numeric";
	property name="authCode" ormtype="string" type="string";
	property name="avsResponse" ormtype="string" type="string";
	property name="cvvResponse" ormtype="string" type="string";
	property name="addDate" ormtype="timestamp" type="date" update="false";

	// non-persistents
	property name="cvv" persistent="false" type="string" default="";

	void function preInsert() {
		setCCNumber(right(getCCNumber(), 4));
		setAddDate(now());
	}

	void function preUpdate() {
		setCCNumber(right(getCCNumber(), 4));
	}

	string function getCheckNum() {
		var checkNum = "";

		if (len(getCCNumber()))
			checkNum &= getCCNumber();
		else if (len(getCheckAccount()))
			checkNum &= getCheckAccount();

		if (len(checkNum))
			checkNum &= " \ ";

		checkNum &= getAuthCode();

		return checkNum;
	}
}