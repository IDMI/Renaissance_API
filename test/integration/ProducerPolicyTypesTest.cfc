component extends="coldbox.system.testing.BaseTestCase" {
	function setup() {
		super.setup();
	}

	function test_list() {
		url.max = 10;

		var event = execute("rest.ProducerPolicyTypes");
		var prc = event.getCollection(private=true);

		assertIsArray(prc.data.message);
		assertTrue(arrayLen(prc.data.message));
	}

	function test_list_producerID_357_companyID_10_stateID_73_policyType_1() {
		url.producerID = 357;
		url.companyID = 10;
		url.stateID = 73;
		url.policyType = 1;

		var event = execute("rest.ProducerPolicyTypes");
		var prc = event.getCollection(private=true);

		assertTrue(arrayLen(prc.data.message) == 1);
	}
}