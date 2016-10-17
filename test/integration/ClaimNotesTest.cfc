component extends="coldbox.system.testing.BaseTestCase" {
	function setup() {
		super.setup();
	}

	function test_list() {
		url.claimIncidentID = 10;

		var event = execute("rest.ClaimNotes");
		var prc = event.getCollection(private=true);

		assertIsArray(prc.data.message);
		assertTrue(arrayLen(prc.data.message) == 5);
	}

	function test_show_392() {
		url.id = 392;

		var event = execute("rest.ClaimNotes.show");
		var prc = event.getCollection(private=true);

		assertTrue(prc.data.message.getClaimIncidentID() == 10);
	}
}