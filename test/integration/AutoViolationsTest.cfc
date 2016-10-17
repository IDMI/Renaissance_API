component extends="coldbox.system.testing.BaseTestCase" {
	public void function setup() {
		super.setup();
	}

	function test_list() {
		var event = execute("rest.AutoViolations");
		var prc = event.getCollection(private=true);

		assertIsArray(prc.data.message);
		assertTrue(arrayLen(prc.data.message));
	}
}