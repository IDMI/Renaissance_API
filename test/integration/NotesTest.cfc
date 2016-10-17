component extends="coldbox.system.testing.BaseTestCase" {
	function setup() {
		super.setup();
	}

	function test_list() {
		url.max = 10;
		url.policyID = 690;

		var event = execute("rest.Notes");
		var prc = event.getCollection(private=true);

		assertIsArray(prc.data.message);
		assertTrue(arrayLen(prc.data.message));
	}

	function test_show_1473() {
		url.id = 1473;

		var event = execute("rest.Notes.show");
		var prc = event.getCollection(private=true);

		assertTrue(prc.data.message.getPolicyID() == 690);
	}
}