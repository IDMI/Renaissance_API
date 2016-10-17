component extends="coldbox.system.testing.BaseTestCase" {
	function setup() {
		super.setup();
	}

	function test_list() {
		var event = execute("rest.AutoViolationCharges");
		var prc = event.getCollection(private=true);

		assertIsArray(prc.data.message);
		assertTrue(arrayLen(prc.data.message));
	}

	function test_list_ratingGroupID_10_ratingVersionID_10() {
		url.ratingGroupID = "10";
		url.ratingVersionID = "10";

		var event = execute("rest.AutoViolationCharges");
		var prc = event.getCollection(private=true);

		assertTrue(arrayLen(prc.data.message) == 30);
	}
}