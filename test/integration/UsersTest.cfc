component extends="coldbox.system.testing.BaseTestCase" {
	function setup() {
		super.setup();
	}

	function test_show() {
		url.id = 2;

		var event = execute("rest.Users.show");
		var prc = event.getCollection(private=true);

		assertTrue(prc.data.message.getFName() == "AUTOMATED ENTRY");
	}
}