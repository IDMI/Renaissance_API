component extends="coldbox.system.testing.BaseTestCase" {
	function setup() {
		super.setup();
	}

	function test_create() {
		url.policyID = 18637;
		url.method = 10;
		url.amount = randRange(10, 50);
		url.paymentName = "Test Test";
		url.address1 = "123 Test St";
		url.city = "Atlanta";
		url.state = "GA";
		url.zip = "30339";
		url.bankRoutingNum = "061000052";
		url.bankAcctNum = "12135454545";

		var event = execute("rest.Payments.create");
		var prc = event.getCollection(private=true);

		assertTrue(prc.data.message.getPaymentID() > 1);
	}
}