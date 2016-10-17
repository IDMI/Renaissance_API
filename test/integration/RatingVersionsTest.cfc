component extends="coldbox.system.testing.BaseTestCase" {
	function setup() {
		super.setup();
	}

	function test_list() {
		url.max = 10;

		var event = execute("rest.RatingVersions");
		var prc = event.getCollection(private=true);

		assertIsArray(prc.data.message);
		assertTrue(arrayLen(prc.data.message));
	}

	function test_list_ratingGroupID_10_isRenewal_0_effectiveDate_080102010() {
		url.ratingGroupID = 10;
		url.isRenewal = 0;
		url.effectiveDate = "8/1/2010";

		var event = execute("rest.RatingVersions");
		var prc = event.getCollection(private=true);

		assertTrue(arrayLen(prc.data.message) == 0);
	}

	function test_list_ratingGroupID_10_isRenewal_1_effectiveDate_080102010() {
		url.ratingGroupID = 10;
		url.isRenewal = 1;
		url.effectiveDate = "8/1/2010";

		var event = execute("rest.RatingVersions");
		var prc = event.getCollection(private=true);

		assertTrue(arrayLen(prc.data.message) == 0);
	}

	function test_list_ratingGroupID_10_isRenewal_0_effectiveDate_03052015() {
		url.ratingGroupID = 10;
		url.isRenewal = 0;
		url.effectiveDate = "03/05/2015";

		var event = execute("rest.RatingVersions");
		var prc = event.getCollection(private=true);

		assertTrue(arrayLen(prc.data.message) == 1);
	}

	function test_list_ratingGroupID_10_isRenewal_1_effectiveDate_03052015() {
		url.ratingGroupID = 10;
		url.isRenewal = 1;
		url.effectiveDate = "03/05/2015";

		var event = execute("rest.RatingVersions");
		var prc = event.getCollection(private=true);

		assertTrue(arrayLen(prc.data.message) == 1);
	}
}