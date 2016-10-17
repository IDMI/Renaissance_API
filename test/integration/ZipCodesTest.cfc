component extends="coldbox.system.testing.BaseTestCase" {
	public void function setup() {
		super.setup();
	}

	function test_list() {
		url.max = 10;

		var event = execute("rest.ZipCodes");
		var prc = event.getCollection(private=true);

		assertIsArray(prc.data.message);
		assertTrue(arrayLen(prc.data.message));
	}

	function test_list_30339() {
		url.zipCode = 30339;

		var event = execute("rest.ZipCodes");
		var prc = event.getCollection(private=true);

		assertTrue(arrayLen(prc.data.message) == 7);
	}
}