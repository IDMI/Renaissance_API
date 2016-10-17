component extends="coldbox.system.testing.BaseTestCase" {
	public void function setup() {
		super.setup();
	}

	function test_list() {
		var event = execute("rest.Attachments");
		var prc = event.getCollection(private=true);

		assertIsArray(prc.data.message);
		assertTrue(arrayLen(prc.data.message));
	}

	function test_list_policyID_1_claimIncidentID_112() {
		url.policyID = 1;
		url.claimIncidentID = 112;

		var event = execute("rest.Attachments");
		var prc = event.getCollection(private=true);

		assertTrue(arrayLen(prc.data.message) == 4);
	}

	function test_show_107() {
		url.id = 107;

		var event = execute("rest.Attachments.show");
		var prc = event.getCollection(private=true);

		assertTrue(prc.data.message.getClaimIncidentID() == 112);
	}
}