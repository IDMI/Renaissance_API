<cfscript>
	// Allow unique URL or combination of URLs, we recommend both enabled
	setUniqueURLS(false);
	// Auto reload configuration, true in dev makes sense to reload the routes on every request
	setAutoReload(false);
	// Sets automatic route extension detection and places the extension in the rc.format variable
	setExtensionDetection(true);
	// The valid extensions this interceptor will detect
	setValidExtensions('xml,json,html');
	// If enabled, the interceptor will throw a 406 exception that an invalid format was detected or just ignore it
	setThrowOnInvalidExtension(true);

	// Base URL
	protocol = "http" & ((ListFindNoCase(cgi.server_name, "live", ".") || cgi.https == "on") ? "s" : "");

	if( len(getSetting('AppMapping') ) lte 1){
		setBaseURL(protocol & "://#cgi.HTTP_HOST#/index.cfm");
	} else{
		setBaseURL(protocol & "://#cgi.HTTP_HOST#/#getSetting('AppMapping')#/index.cfm");
	}

	// Module Routing Added
	addModuleRoutes(pattern="/forgebox",module="forgebox");

	// Application Namespaces
	addNamespace(pattern="/appQuestions", namespace="appQuestions");
	addNamespace(pattern="/attachments", namespace="attachments");
	addNamespace(pattern="/autoViolations", namespace="autoViolations");
	addNamespace(pattern="/autoViolationCharges", namespace="autoViolationCharges");
	addNamespace(pattern="/claimantAutos", namespace="claimantAutos");
	addNamespace(pattern="/claimants", namespace="claimants");
	addNamespace(pattern="/claimCodeCategories", namespace="claimCodeCategories");
	addNamespace(pattern="/claimCodes", namespace="claimCodes");
	addNamespace(pattern="/claimIncidentAutos", namespace="claimIncidentAutos");
	addNamespace(pattern="/claimantIndividualTypes", namespace="claimantIndividualTypes");
	addNamespace(pattern="/claimIncidents", namespace="claimIncidents");
	addNamespace(pattern="/claimNotes", namespace="claimNotes");
	addNamespace(pattern="/companies", namespace="companies");
	addNamespace(pattern="/counties", namespace="counties");
	addNamespace(pattern="/coveragePackages", namespace="coveragePackages");
	addNamespace(pattern="/drivers", namespace="drivers");
	addNamespace(pattern="/insureds", namespace="insureds");
	addNamespace(pattern="/notes", namespace="notes");
	addNamespace(pattern="/payments", namespace="payments");
	addNamespace(pattern="/paymentPlans", namespace="paymentPlans");
	addNamespace(pattern="/policies", namespace="policies");
	addNamespace(pattern="/policyTypes", namespace="policyTypes");
	addNamespace(pattern="/producerPolicyTypes", namespace="producerPolicyTypes");
	addNamespace(pattern="/RTR", namespace="RTR");
	addNamespace(pattern="/ratingGroups", namespace="ratingGroups");
	addNamespace(pattern="/ratingVersions", namespace="ratingVersions");
	addNamespace(pattern="/states", namespace="states");
	addNamespace(pattern="/users", namespace="users");
	addNamespace(pattern="/vehicles", namespace="vehicles");
	addNamespace(pattern="/zipCodes", namespace="zipCodes");

	// Application Routes
	// appQuestions
	with(namespace="appQuestions", handler="rest.AppQuestions")
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// attachments
	with(namespace="attachments", handler="rest.Attachments")
		.addRoute(pattern="/upload", action={post="upload"})
		.addRoute(pattern="/:id-numeric/view", action={get="view"})
		.addRoute(pattern="/:id-numeric", action={get="show"})
		.addRoute(pattern="", action={get="index", post="create"})
	.endWith();

	// autoViolations
	with(namespace="autoViolations", handler="rest.AutoViolations")
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// autoViolationCharges
	with(namespace="autoViolationCharges", handler="rest.AutoViolationCharges")
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// claimantAutos
	with(namespace="claimantAutos", handler="rest.ClaimantAutos")
		.addRoute(pattern="/:id-numeric", action={get="show"})
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// claimantIndividualTypes
	with(namespace="claimantIndividualTypes", handler="rest.ClaimantIndividualTypes")
		.addRoute(pattern="/:id-numeric", action={get="show"})
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// claimants
	with(namespace="claimants", handler="rest.Claimants")
		.addRoute(pattern="/:id-numeric", action={get="show"})
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// claimCodeCategories
	with(namespace="claimCodeCategories", handler="rest.ClaimCodeCategories")
		.addRoute(pattern="/:id-numeric", action={get="show"})
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// claimCodes
	with(namespace="claimCodes", handler="rest.ClaimCodes")
		.addRoute(pattern="/:id-numeric", action={get="show"})
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// claimIncidentAutos
	with(namespace="claimIncidentAutos", handler="rest.ClaimIncidentAutos")
		.addRoute(pattern="/:id-numeric", action={get="show"})
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// claimIncidents
	with(namespace="claimIncidents", handler="rest.ClaimIncidents")
		.addRoute(pattern="/:id-numeric", action={get="show"})
		.addRoute(pattern="", action={get="index", post="create"})
	.endWith();

	// claimNotes
	with(namespace="claimNotes", handler="rest.ClaimNotes")
		.addRoute(pattern="/:id-numeric", action={get="show"})
		.addRoute(pattern="", action={get="index", post="create"})
	.endWith();

	// companies
	with(namespace="companies", handler="rest.Companies")
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// counties
	with(namespace="counties", handler="rest.Counties")
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// coveragePackages
	with(namespace="coveragePackages", handler="rest.CoveragePackages")
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// drivers
	with(namespace="drivers", handler="rest.drivers")
		.addRoute(pattern="/:id-numeric", action={get="show"})
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// insureds
	with(namespace="insureds", handler="rest.Insureds")
		.addRoute(pattern="/:id-numeric", action={get="show"})
	.endWith();

	// notes
	with(namespace="notes", handler="rest.Notes")
		.addRoute(pattern="/:id-numeric", action={get="show"})
		.addRoute(pattern="", action={get="index", post="create"})
	.endWith();

	// payments
	with(namespace="payments", handler="rest.Payments")
		.addRoute(pattern="", action={post="create"})
	.endWith();

	// paymentPlans
	with(namespace="paymentPlans", handler="rest.PaymentPlans")
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// policies
	with(namespace="policies", handler="rest.Policies")
		.addRoute(pattern="/:id-numeric", action={get="show"})
	.endWith();

	// policyTypes
	with(namespace="policyTypes", handler="rest.PolicyTypes")
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// producerPolicyTypes
	with(namespace="producerPolicyTypes", handler="rest.ProducerPolicyTypes")
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// RTR
	with(namespace="RTR", handler="rest.RTR")
		.addRoute(pattern="", action={post="create"})
	.endWith();

	// ratingGroups
	with(namespace="ratingGroups", handler="rest.RatingGroups")
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// ratingVersions
	with(namespace="ratingVersions", handler="rest.RatingVersions")
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// states
	with(namespace="states", handler="rest.States")
		.addRoute(pattern="/:id-numeric", action={get="show"})
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// users
	with(namespace="users", handler="rest.Users")
		.addRoute(pattern="/:id-numeric", action={get="show"})
	.endWith();

	// vehicles
	with(namespace="vehicles", handler="rest.vehicles")
		.addRoute(pattern="/:id-numeric", action={get="show"})
		.addRoute(pattern="", action={get="index"})
	.endWith();

	// zipCode
	with(namespace="zipCodes", handler="rest.ZipCodes")
		.addRoute(pattern="", action={get="index"})
	.endWith();

	addRoute(pattern=":handler/:action?");

	/** Developers can modify the CGI.PATH_INFO value in advance of the SES
		interceptor to do all sorts of manipulations in advance of route
		detection. If provided, this function will be called by the SES
		interceptor instead of referencing the value CGI.PATH_INFO.

		This is a great place to perform custom manipulations to fix systemic
		URL issues your Web site may have or simplify routes for i18n sites.

		@Event The ColdBox RequestContext Object
	**/
	function PathInfoProvider(Event){
		/* Example:
		var URI = CGI.PATH_INFO;
		if (URI eq "api/foo/bar")
		{
			Event.setProxyRequest(true);
			return "some/other/value/for/your/routes";
		}
		*/
		return CGI.PATH_INFO;
	}
</cfscript>