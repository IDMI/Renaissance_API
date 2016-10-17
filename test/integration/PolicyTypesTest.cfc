component extends="coldbox.system.testing.BaseTestCase" {
	function setup() {
		super.setup();
	}

	function test_list() {
		url.max = 10;

		var event = execute("rest.PolicyTypes");
		var prc = event.getCollection(private=true);

		assertIsArray(prc.data.message);
		assertTrue(arrayLen(prc.data.message));
	}

	function test_list_policyType_1() {
		url.policyType = 1;

		var event = execute("rest.PolicyTypes");
		var prc = event.getCollection(private=true);

		assertTrue(arrayLen(prc.data.message) == 1);
	}

	function test_list_description_Personal_Auto() {
		url.description = "Personal Auto";

		var event = execute("rest.PolicyTypes");
		var prc = event.getCollection(private=true);

		assertTrue(arrayLen(prc.data.message) == 1);
	}
}