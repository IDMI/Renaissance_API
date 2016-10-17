component extends="coldbox.system.testing.BaseTestCase" {
	public void function setup() {
		super.setup();
	}

	function test_list() {
		url.max = 10;

		var event = execute("rest.ClaimCodes");
		var prc = event.getCollection(private=true);

		assertIsArray(prc.data.message);
		assertTrue(arrayLen(prc.data.message));
	}

	function test_show_10() {
		url.id = 10;

		var event = execute("rest.ClaimCodes.show");
		var prc = event.getCollection(private=true);

		assertTrue(prc.data.message.getDescription() == "At Fault - Single Car Accident");
	}
}