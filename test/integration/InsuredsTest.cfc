component extends="coldbox.system.testing.BaseTestCase" {
	function setup() {
		super.setup();
	}

	function test_show() {
		url.id = 10;

		var event = execute("rest.Insureds.show");
		var prc = event.getCollection(private=true);

		assertTrue(prc.data.message.getFullName1() == "KAREN b BECK");
	}
}