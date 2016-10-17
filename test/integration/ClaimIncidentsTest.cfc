component extends="coldbox.system.testing.BaseTestCase" {
	function setup() {
		super.setup();
	}

	function test_list() {
		url.policyID = 825;

		var event = execute("rest.ClaimIncidents");
		var prc = event.getCollection(private=true);

		assertIsArray(prc.data.message);
		assertTrue(arrayLen(prc.data.message) == 6);
	}

	function test_show_138() {
		url.id = 138;

		var event = execute("rest.ClaimIncidents.show");
		var prc = event.getCollection(private=true);

		assertTrue(prc.data.message.getPolicyID() == 825);
	}
}