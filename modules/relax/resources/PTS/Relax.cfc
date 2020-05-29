component
	output="false"
{
	variables.dirPath = getDirectoryFromPath( getMetadata(this).path );

	function configure(){
		this.relax = {
			title = "PTS API",
			description = "",
			entryPoint = {
				dev="http://renaissance.dev.ptsapi.com",
				production="https://renaissance.live.ptsapi.com"
			},
			extensionDetection = true,
			validExtensions = "xml,json",
			throwOnInvalidExtension = false
		};

		/************************************** GLOBAL PARAMS +  HEADERS *********************************************/

		// Global API Headers
		globalHeader(name="secretKey", description="The secretKey needed for request authentication.", required=true);

		/************************************** RESOURCES *********************************************/

		// appQuestions
		resource(pattern="/appQuestions/ratingGroupID/:ratingGroupID-numeric/ratingVersionID/:ratingVersionID-numeric",handler="rest.AppQuestion",action={get="getAll"})
			.description("Returns all application questions based on the given arguments.")
			.methods("GET")
			.defaultMethod("GET")
			.defaultFormat("json")
			.sample(format="json", description="Sample JSON data response on success event.", body=fileRead("#dirPath#samples/appQuestions/Success.json"))
			.sample(format="json", description="Sample JSON data return on a failure event", body=fileRead("#dirPath#samples/appQuestions/Failure.json"));

		// autoViolationCharges
		resource(pattern="/autoViolationCharges/ratingGroupID/:ratingGroupID-numeric/ratingVersionID/:ratingVersionID-numeric",handler="rest.AutoViolationCharge",action={get="getAll"})
			.description("Returns all auto violations based on the the given arguments.")
			.methods("GET")
			.defaultMethod("GET")
			.defaultFormat("json")
			.sample(format="json", description="Sample JSON data response on success event.", body=fileRead("#dirPath#samples/autoViolationCharges/Success.json"))
			.sample(format="json", description="Sample JSON data return on a failure event", body=fileRead("#dirPath#samples/autoViolationCharges/Failure.json"));

		// company
		resource(pattern="/company/:companyName",handler="rest.Company",action={get="get"})
			.description("Returns data for the requested company.")
			.methods("GET")
			.defaultMethod("GET")
			.defaultFormat("json")
			.sample(format="json", description="Sample JSON data response on success event.", body=fileRead("#dirPath#samples/company/Success.json"))
			.sample(format="json", description="Sample JSON data return on a failure event", body=fileRead("#dirPath#samples/company/Failure.json"));

		// coveragePackages
		resource(pattern="/coveragePackages/companyID/:companyID-numeric/stateID/:stateID-numeric/policyType/:policyType-numeric",handler="rest.CoveragePackage",action={get="getAll"})
			.description("Returns coverage package information based on the given arguments.")
			.methods("GET")
			.defaultMethod("GET")
			.defaultFormat("json")
			.sample(format="json", description="Sample JSON data response on success event.", body=fileRead("#dirPath#samples/coveragePackages/Success.json"))
			.sample(format="json", description="Sample JSON data return on a failure event", body=fileRead("#dirPath#samples/coveragePackages/Failure.json"));

		// paymentPlans
		resource(pattern="/paymentPlans/companyID/:companyID-numeric/stateID/:stateID-numeric/policyType/:policyType-numeric/policyTerm/:policyTerm-numeric/isRenewal/:isRenewal-numeric",handler="rest.PaymentPlan",action={get="getAll"})
			.description("Returns payment plans based on the given arguments.")
			.methods("GET")
			.defaultMethod("GET")
			.defaultFormat("json")
			.sample(format="json", description="Sample JSON data response on success event.", body=fileRead("#dirPath#samples/paymentPlans/Success.json"))
			.sample(format="json", description="Sample JSON data return on a failure event", body=fileRead("#dirPath#samples/paymentPlans/Failure.json"));

		// policy
		resource(pattern="/policy/:policyID-numeric",handler="rest.Policy",action={get="get"})
			.description("Returns policy data based on the given ID value.")
			.methods("GET")
			.defaultMethod("GET")
			.defaultFormat("json")
			.sample(format="json", description="Sample JSON data response on success event.", body=fileRead("#dirPath#samples/policy/Success.json"))
			.sample(format="json", description="Sample JSON data return on a failure event", body=fileRead("#dirPath#samples/policy/Failure.json"));

		// policyType
		resource(pattern="/policyType/:policyType",handler="rest.PolicyType",action={get="get"})
			.description("Returns policy type data based on the given argument. Argument can either be a number or string.")
			.methods("GET")
			.defaultMethod("GET")
			.defaultFormat("json")
			.sample(format="json", description="Sample JSON data response on success event.", body=fileRead("#dirPath#samples/policyType/Success.json"))
			.sample(format="json", description="Sample JSON data return on a failure event", body=fileRead("#dirPath#samples/policyType/Failure.json"));

		// rate
		resource(pattern="/rate",handler="rest.Rate",action={post="post"})
			.description("Calls the rating process on the given policy.")
			.methods("POST")
			.defaultFormat("json")
			.param(name="data",description="XML or JSON formatted string holding policy data",required="true")
			.sample(format="json", description="Sample JSON data response on success event.", body=fileRead("#dirPath#samples/rate/Success.json"))
			.sample(format="json", description="Sample JSON data return on a failure event", body=fileRead("#dirPath#samples/rate/Failure.json"));

		// RTR
		resource(pattern="/RTR",handler="rest.RTR",action={post="post"})
			.description("Calls the real time rater on the given policy data set(s).")
			.methods("POST")
			.defaultFormat("json")
			.param(name="data",description="XML or JSON formatted string holding policy data set(s)",required="true")
			.sample(format="json", description="Sample JSON data response on success event.", body=fileRead("#dirPath#samples/RTR/Success.json"))
			.sample(format="json", description="Sample JSON data return on a failure event", body=fileRead("#dirPath#samples/RTR/Failure.json"));

		// ratingGroups
		resource(pattern="/ratingGroups/companyID/:companyID-numeric/stateID/:stateID-numeric/policyType/:policyType-numeric",handler="rest.RatingGroup",action={get="getAll"})
			.description("Returns rating groups based on the given argument. Argument can either be a number or string.")
			.methods("GET")
			.defaultMethod("GET")
			.defaultFormat("json")
			.sample(format="json", description="Sample JSON data response on success event.", body=fileRead("#dirPath#samples/ratingGroups/Success.json"))
			.sample(format="json", description="Sample JSON data return on a failure event", body=fileRead("#dirPath#samples/ratingGroups/Failure.json"));

		// ratingVersions
		resource(pattern="/ratingVersions/ratingGroupID/:ratingGroupID-numeric/isRenewal/:isRenewal-numeric/year/:year-numeric/month/:month-numeric/day/:day-numeric",handler="rest.RatingVersion",action={get="getAll"})
			.description("Returns rating versions based on the given argument. Argument can either be a number or string.")
			.methods("GET")
			.defaultMethod("GET")
			.defaultFormat("json")
			.sample(format="json", description="Sample JSON data response on success event.", body=fileRead("#dirPath#samples/ratingVersions/Success.json"))
			.sample(format="json", description="Sample JSON data return on a failure event", body=fileRead("#dirPath#samples/ratingVersions/Failure.json"));

		// state
		resource(pattern="/state/:state",handler="rest.State",action={get="get"})
			.description("Returns state data for the given argument. Argument can either be a abbreviation or full name of state.")
			.methods("GET")
			.defaultMethod("GET")
			.defaultFormat("json")
			.sample(format="json", description="Sample JSON data response on success event.", body=fileRead("#dirPath#samples/state/Success.json"))
			.sample(format="json", description="Sample JSON data return on a failure event", body=fileRead("#dirPath#samples/state/Failure.json"));

		// zipCode
		resource(pattern="/zipCode/:zipCode-numeric",handler="rest.ZipCode",action={get="getAll"})
			.description("Returns zip code data for the given argument.")
			.methods("GET")
			.defaultMethod("GET")
			.defaultFormat("json")
			.sample(format="json", description="Sample JSON data response on success event.", body=fileRead("#dirPath#samples/zipCode/Success.json"))
			.sample(format="json", description="Sample JSON data return on a failure event", body=fileRead("#dirPath#samples/zipCode/Failure.json"));
	}
}