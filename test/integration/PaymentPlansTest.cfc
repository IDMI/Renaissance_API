component extends="coldbox.system.testing.BaseTestCase" {
	function setup() {
		super.setup();
	}

	function test_list() {
		url.max = 10;

		var event = execute("rest.PaymentPlans");
		var prc = event.getCollection(private=true);

		assertIsArray(prc.data.message);
		assertTrue(arrayLen(prc.data.message));
	}

	function test_list_companyID_10_stateID_66_policyType_1_policyTerm_6_isRenewal_0() {
		url.companyID = 10;
		url.stateID = 66;
		url.policyType = 1;
		url.policyTerm = 6;
		url.isRenewal = 0;

		var event = execute("rest.PaymentPlans");
		var prc = event.getCollection(private=true);

		assertTrue(arrayLen(prc.data.message) == 6);
	}
}