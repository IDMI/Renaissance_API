<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Author 	 :	Luis Majano
Description :
	Your WireBox Configuration Binder
----------------------------------------------------------------------->
<cfcomponent output="false" hint="The default WireBox Injector configuration object" extends="coldbox.system.ioc.config.Binder">
<cfscript>

	/**
	* Configure WireBox, that's it!
	*/
	function configure(){

		// The WireBox configuration structure DSL
		wireBox = {
			// Scope registration, automatically register a wirebox injector instance on any CF scope
			// By default it registeres itself on application scope
			scopeRegistration = {
				enabled = true,
				scope = "application", // server, cluster, session, application
				key = "wireBox"
			},

			// DSL Namespace registrations
			customDSL = {
				// namespace = "mapping name"
			},

			// Custom Storage Scopes
			customScopes = {
				// annotationName = "mapping name"
			},

			// Package scan locations
			scanLocations = [],

			// Stop Recursions
			stopRecursions = [],

			// Parent Injector to assign to the configured injector, this must be an object reference
			parentInjector = "",

			// Register all event listeners here, they are created in the specified order
			listeners = [
				{ class="coldbox.system.aop.Mixer", name="", properties={} }
			]
		};

		// Map Bindings below

		// wirebox
		map("wirebox")
			.toDSL("wirebox");

		// model mapping
		mapPath("model.agencyFee.AgencyFeeService");
		mapPath("model.appQuestion.AppQuestionService");
		mapPath("model.appQuestionResponse.AppQuestionResponseService");
		mapPath("model.ar.ARService");
		mapPath("model.attachment.attachmentService");
		mapPath("model.auto.AutoService");
		mapPath("model.claim.ClaimantService");
		mapPath("model.claim.ClaimantAutoService");
		mapPath("model.claim.ClaimantIndividualTypeService");
		mapPath("model.claim.ClaimCodeCategoryService");
		mapPath("model.claim.ClaimCodeService");
		mapPath("model.claim.ClaimIncidentAutoService");
		mapPath("model.claim.ClaimIncidentService");
		mapPath("model.claim.ClaimNoteService");
		mapPath("model.company.CompanyService");
		mapPath("model.companyFinancial.CompanyFinancialService");
		mapPath("model.config.autoViolation.AutoViolationService");
		mapPath("model.config.discountType.DiscountTypeService");
		mapPath("model.config.policyCoverage.PolicyCoverageService");
		mapPath("model.config.policyType.PolicyTypeService");
		mapPath("model.config.surchargeType.SurchargeTypeService");
		mapPath("model.county.CountyService");
		mapPath("model.coverage.CoverageService");
		mapPath("model.coverage.VehicleCoverageService");
		mapPath("model.depositProof.DepositProofService");
		mapPath("model.discount.DiscountService");
		mapPath("model.discount.PolicyDiscountService");
		mapPath("model.driver.DriverService");
		mapPath("model.driverAccident.DriverAccidentService");
		mapPath("model.insured.InsuredService");
		mapPath("model.insuredPortal.coveragePackage.CoveragePackageService");
		mapPath("model.insuredPortal.coveragePackageDetail.CoveragePackageDetailService");
		mapPath("model.IVR.IVRService");
		mapPath("model.IVRConfig.IVRConfigService");
		mapPath("model.IVRConfigClient.IVRConfigClientService");
		mapPath("model.IVRPayment.IVRPaymentService");
		mapPath("model.IVRPaymentAttempt.IVRPaymentAttemptService");
		mapPath("model.IVRResponse.IVRResponseService");
		mapPath("model.lienholder.LienholderService");
		mapPath("model.note.NoteService");
		mapPath("model.payment.PaymentService");
		mapPath("model.paymentInfo.PaymentInfoService");
		mapPath("model.paymentPlan.PaymentPlanService");
		mapPath("model.paymentPlanSchedule.PaymentPlanScheduleService");
		mapPath("model.policy.PolicyService");
		mapPath("model.policyRateDetail.PolicyRateDetailService");
		mapPath("model.policyRating.PolicyRatingService");
		mapPath("model.producer.ProducerService");
		mapPath("model.producerPolicyType.ProducerPolicyTypeService");
		mapPath("model.rate.autoDriverFactor.AutoDriverFactorService");
		mapPath("model.rate.autoRateDetail.AutoRateDetailService");
		mapPath("model.rate.autoTerritory.AutoTerritoryService");
		mapPath("model.rate.autoViolationCharge.AutoViolationChargeService");
		mapPath("model.rate.ratingGroup.RatingGroupService");
		mapPath("model.rate.ratingVersion.RatingVersionService");
		mapPath("model.rate.underwriting.UnderwritingService");
		mapPath("model.RTR.RTRPAutoService");
		mapPath("model.RTR.RTRService");
		mapPath("model.RTR.RTRValidatorService");
		mapPath("model.security.SecurityService");
		mapPath("model.state.StateService");
		mapPath("model.surcharge.PolicySurchargeService");
		mapPath("model.surcharge.SurchargeService");
		mapPath("model.surcharge.VehicleSurchargeService");
		mapPath("model.suspense.SuspenseService");
		mapPath("model.systemInfo.SystemInfoService");
		mapPath("model.trans.TransService");
		mapPath("model.user.UserService");
		mapPath("model.utilities.Conversions");
		mapPath("model.utilities.DateUtils");
		mapPath("model.utilities.Utils");
		mapPath("model.utilities.Validator");
		mapPath("model.vehicle.VehicleService");
		mapPath("model.zipCode.ZipCodeService");
		mapPath("model.validators.BankRoutingNumber");

		// factory methods
		map("notAssignedUser")
			.toFactoryMethod("UserService", "get")
			.methodArg(name="id", value="1")
			.asSingleton();

		map("systemUser")
			.toFactoryMethod("UserService", "get")
			.methodArg(name="id", value="5")
			.asSingleton();

		// webservices
		map("transactionRefund")
			.toWebservice(getColdBox().getSetting("appUrl") & "/exportProcess/IVR/Primoris/components/transactionRefund.cfc?wsdl");

		map("transactionSale")
			.toWebservice(getColdBox().getSetting("appUrl") & "/exportProcess/IVR/Primoris/components/transactionSale.cfc?wsdl");

		map("transactionStoreCard")
			.toWebservice(getColdBox().getSetting("appUrl") & "/exportProcess/IVR/Primoris/components/transactionStoreCard.cfc?wsdl");

		map("ECSTransactionService").toDSL("entityService:ECSTransaction");
	}
</cfscript>
</cfcomponent>