component extends="coldbox.system.testing.BaseTestCase" {
	public void function setup() {
		super.setup();
	}

	function test_list() {
		var event = execute("rest.States");
		var prc = event.getCollection(private=true);

		assertIsArray(prc.data.message);
		assertTrue(arrayLen(prc.data.message));
	}

	function test_list_GA() {
		url.stateShort = "GA";

		var event = execute("rest.States");
		var prc = event.getCollection(private=true);

		assertTrue(arrayLen(prc.data.message) == 1);
	}

	function test_show_41() {
		url.id = 41;

		var event = execute("rest.States.show");
		var prc = event.getCollection(private=true);

		assertTrue(prc.data.message.getStateShort() == "GA");
	}
}