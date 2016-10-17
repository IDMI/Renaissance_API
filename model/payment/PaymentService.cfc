/**
payment/PaymentService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Payment service
@output false
**/
component
	extends="coldbox.system.orm.hibernate.VirtualEntityService"
	accessors="true"
	singleton
{
	property name="dateUtils" inject="model";
	property name="depositProofService" inject="model";
	property name="IVRPaymentService" inject="model";
	property name="IVRResponseService" inject="model";
	property name="IVRService" inject="model";
	property name="noteService" inject="model";
	property name="paymentInfoService" inject="model";
	property name="policyService" inject="model";
	property name="systemInfoService" inject="model";
	property name="systemUser" inject;
	property name="transService" inject="model";
	property name="utils" inject="model";

	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint constructor
    @output false
    **/
	public model.payment.PaymentService function init() {
		super.init(entityName="Payment");

		return this;
	}

	public model.payment.Payment function refund(required model.payment.Payment payment) {
		if (isNull(arguments.payment.getPaymentID()) || arrayFind([20], arguments.payment.getPaymentType()) || arrayFind([20], arguments.payment.getStatus())) {
			return arguments.payment;
		}

		// load systemInfo
		var systemInfo = getSystemInfoService().findWhere({});

		// adjust existing payment
		arguments.payment.setStatus(20);
		arguments.payment.setDepositNum(systemInfo.getCurrentDepositNum()==arguments.payment.getDepositNum()?0:arguments.payment.getDepositNum());
		save(arguments.payment);

		// adjust DepositProof
		var depositProof = getDepositProofService().findWhere({payment = arguments.payment});

		if (structKeyExists(local, "depositProof")) {
			depositProof.setProofBatchNum("REVERSED");
			save(depositProof);
		}

		// reverse payment
		var newPayment = new({
			policy = arguments.payment.getPolicy(),
			amount = 0 - arguments.payment.getAmount(),
			paymentDate = arguments.payment.getPaymentDate(),
			postMarkedDate = arguments.payment.getPostMarkedDate(),
			paymentType = arguments.payment.getStatus(),
			method = arguments.payment.getMethod(),
			checkNum = arguments.payment.getCheckNum(),
			depositNum = arguments.payment.getDepositNum(),
			note = "Voided Payment",
			insured = arguments.payment.getInsured(),
			producer = arguments.payment.getProducer(),
			company = arguments.payment.getCompany(),
			user = arguments.payment.getUser(),
			noTrans = 2
		});
		save(newPayment);

		// reverse trans
		for (var j=1;j<=arrayLen(arguments.payment.getTrans());j++) {
			var oldTrans = arguments.payment.getTrans()[j];
			var newTrans = getTransService().new({
				payment = newPayment,
				amount = 0 - oldTrans.getAmount(),
				transDate = oldTrans.getTransDate(),
				transType = oldTrans.getTransType(),
				depositNum = oldTrans.getDepositNum(),
				policy = oldTrans.getPolicy(),
				isRenewal = oldTrans.getIsRenewal(),
				insured = oldTrans.getInsured(),
				producer = oldTrans.getProducer(),
				company = oldTrans.getCompany(),
				transSubType = oldTrans.getTransSubType()
			});

			if (oldTrans.getTransType() == 99) {
				oldTrans.setTransType(98);
				newTrans.setTransType(98);
				save(oldTrans);
			}
			save(newTrans);
		}

		// reverse IVRPayment
		if (payment.getMethod() == application.constants.payment.method.creditCard && arrayLen(arguments.payment.getIVRPayment())) {
			var IVRPayment = arguments.payment.getIVRPayment()[1];
			var IVRResponse = javacast("null", "");

			var IVRResponse = getIVRResponseService().findWhere({
				policy = arguments.payment.getPolicy(),
				callID = IVRPayment.getCallID()
			});

			if (isNull(IVRResponse)) {
				continue;
			}

			var refundResponse = xmlParse(getIVRService().refund(arguments.payment.getPolicy(), arguments.payment, IVRPayment, IVRResponse));

			if (!refundResponse.xmlRoot.refundSuccessful.xmlText) {
				throw(
					"Unable to refund credit card payment." & getUtils().newLine() &
					"Error Code: " & refundResponse.xmlRoot.errorCode.xmlText & getUtils().newLine() &
					"Server Reponse: " & refundResponse.xmlRoot.responseText.xmlText
				);
			}

		  	// update refund IVRPayment
			var refundIVRPayment = getIVRPaymentService().get(refundResponse.xmlRoot.refundIVR_PaymentID.xmlText);
		  	refundIVRPayment.setPayment(newPayment);
		  	refundIVRPayment.setIsPosted(1);
		  	save(refundIVRPayment);
		 }

		 return newPayment;
	}

	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint Handles sale requests
    @output false
    **/
	public model.payment.Payment function sale(
		required model.policy.Policy policy,
		required model.payment.Payment payment,
		model.paymentInfo.PaymentInfo paymentInfo)
	{
		try {
			if (!isNull(arguments.payment.getPaymentID())) {
				return arguments.payment;
			}
			var IVRPayment = javacast("null", "");

			// load systemInfo
			var systemInfo = getSystemInfoService().findWhere({});

			// lookup latest term policy
			arguments.policy = getLatestTermPolicy(arguments.policy);

			// populate payment entity
			arguments.payment.setPolicy(arguments.policy);
			arguments.payment.setInsured(arguments.policy.getInsured());
			arguments.payment.setProducer(arguments.policy.getProducer());
			arguments.payment.setCompany(arguments.policy.getCompany());
			arguments.payment.setUser(getSystemUser());
			arguments.payment.setDepositNum(systemInfo.getCurrentDepositNum());

			// populate paymentInfo entity
			if (!isNull(arguments.paymentInfo)) {
				arguments.paymentInfo.setPolicy(arguments.policy);
				arguments.paymentInfo.setInsured(arguments.policy.getInsured());
				arguments.paymentInfo.setUser(arguments.payment.getUser());
			}

			// credit card payments
			if (arguments.payment.getMethod() == application.constants.payment.method.creditCard) {
				// validate and store card
				var storeCardResponse = xmlParse(getIVRService().storeCard(arguments.policy, arguments.paymentInfo));

				// error check
				if (!storeCardResponse.xmlRoot.storeCardSuccessful.xmlText) {
					throw(
						"Unable to post credit card payment." & getUtils().newLine() &
						"Error Code: " & storeCardResponse.xmlRoot.errorCode.xmlText & getUtils().newLine() &
						"Server Reponse: " & storeCardResponse.xmlRoot.responseText.xmlText
					);
				}

				// reload paymentInfo entity
				arguments.paymentInfo = getPaymentInfoService().get(storeCardResponse.xmlRoot.paymentInfoID.xmlText);

				// send sale request
				var saleResponse = xmlParse(getIVRService().sale(arguments.policy, arguments.payment, arguments.paymentInfo));

				// error check
				if (!saleResponse.xmlRoot.saleSuccessful.xmlText) {
					throw(
						"Unable to post credit card payment." & getUtils().newLine() &
						"Error Code: " & saleResponse.xmlRoot.errorCode.xmlText & getUtils().newLine() &
						"Server Reponse: " & saleResponse.xmlRoot.responseText.xmlText
					);
				}

				arguments.policy.addPayment(arguments.payment);

				// lookup and edit IVRPayment
				IVRPayment = getIVRPaymentService().get(saleResponse.xmlRoot.IVR_PaymentID.xmlText);
				IVRPayment.setPayment(arguments.payment);
				IVRPayment.setIsPosted(1);
				save(IVRPayment);

				arguments.policy.addIVRPayment(IVRPayment);
			} else {
				arguments.policy.addPayment(arguments.payment);
			}

			save(entity=arguments.payment, flush=true);
			refresh(arguments.payment);

			if (!isNull(arguments.paymentInfo)) {
				save(entity=arguments.paymentInfo, flush=true);
				refresh(arguments.paymentInfo);
				postPaymentInfo(arguments.payment, arguments.paymentInfo);
			}

			// create confirmation note
			if (!isNull(IVRPayment)) {
				arguments.policy.addNote(getNoteService().new({
					"policy" = arguments.policy,
					"user" = getSystemUser(),
					"noteType" = 5,
					"subject" = "Credit Card Payment",
					"body" = arrayToList([
						"Date/Time: " & getDateUtils().formatDateTime(arguments.payment.getPaymentDate()),
						"Card Holder: " & IVRPayment.getCardHolder(),
						"Amount Charged to Credit Card: " & dollarFormat(IVRPayment.getAmount() + IVRPayment.getPrimorisFee()),
						"Amount Applied to Policy: " & dollarFormat(IVRPayment.getAmount()),
						"Service Charge: " & dollarFormat(IVRPayment.getPrimorisFee()),
						"Credit Card: " & IVRPayment.getCardType(),
						"Confirmation Number: " & arguments.payment.getConfirmationNum()
					], "<br />")
				}));

				save(entity=arguments.policy, flush=true);
			}

			// pending & new business
			if (!arguments.policy.getIsRenewal() &&
				arguments.policy.getStatus() == application.constants.policy.status.pending)
			{
				// adjust eff/exp dates
				if (dateDiff("d", getDateUtils().formatDate(arguments.policy.getEffectiveDate()), getDateUtils().formatDate(now())) >= 0) {
					arguments.policy.setEffectiveDate(getDateUtils().formatDateTime(now()));
					arguments.policy.setExpirationDate(getDateUtils().formatDate(dateAdd("m", arguments.policy.getPolicyTerm(), arguments.policy.getEffectiveDate())));
				}

				arguments.policy.setStatus(application.constants.policy.status.bound);
				save(entity=arguments.policy, flush=true);
				refresh(arguments.policy);
				arguments.policy.setStatus(application.constants.policy.status.active);
				save(entity=arguments.policy, flush=true);
				refresh(arguments.policy);
			}

			// active and non-pay
			if (arguments.policy.getStatus() == application.constants.policy.status.active &&
				arguments.policy.getCancelledReason() == application.constants.policy.cancel.reason.nonpay)
			{
				clearCancellationNotice(arguments.policy);
				refresh(arguments.policy);
			}

			// terminated and non-pay
			if (arguments.policy.getStatus() == application.constants.policy.status.cancelled &&
				arguments.policy.getCancelledReason() == application.constants.policy.cancel.reason.nonpay &&
				datediff("d", getDateUtils().formatDate(arguments.payment.getPostMarkedDate()), getDateUtils().formatDate(arguments.policy.getExpirationDate())) > 0 &&
				datediff("d", getDateUtils().formatDate(arguments.policy.getCancelledDate()), getDateUtils().formatDate(arguments.payment.getPostMarkedDate())) <= 30)
			{
				arguments.policy.setCheckReinstatement(1);
				save(entity=arguments.policy, flush=true);
				processReinstatement(arguments.policy);
				refresh(arguments.policy);
			}

			// not written & renewal
			if (arguments.policy.getIsRenewal() &&
				arguments.policy.getStatus() == application.constants.policy.status.notwritten)
			{
				processNotWrittenRenewal(arguments.policy);
				refresh(arguments.policy);
			}

			return arguments.payment;
		} catch (any e) {
			// refund
			refund(arguments.payment);

			if (!isNull(arguments.paymentInfo)) {
				postPaymentInfo(arguments.payment, arguments.paymentInfo);
			}

			ormFlush();

			throw(object=e);
		}
	}

	/**
    @author Peruz Carlsen
    @createdate 20120329
    @hint Executes clearCancellationNotice procedure
    @output false
    **/
	private void function clearCancellationNotice(required model.policy.Policy policy) {
		var procService = new storedproc();

		procService.setProcedure("clearCancellationNotice");
		procService.addParam(cfsqltype="cf_sql_integer", type="in", value=arguments.policy.getPolicyID());
		procService.execute();
	}

	/**
    @author Peruz Carlsen
    @createdate 20120326
    @hint Returns latest policy term
    @output false
    **/
	private model.policy.Policy function getLatestTermPolicy(required model.policy.Policy policy) {
		var procService = new storedproc();

		procService.setProcedure("GetLatestTermPolicy");
		procService.addParam(cfsqltype="cf_sql_integer", type="in", value=arguments.policy.getPolicyID());
		procService.addParam(cfsqltype="cf_sql_integer", type="out", variable="latestPolicyID");

		var result = procService.execute();

		return getPolicyService().get(structFind(result.getProcOutVariables(), "latestPolicyID"));
	}

	/**
    @author Peruz Carlsen
    @createdate 20120326
    @hint Executes PostPaymentInfo procedure
    @output false
    **/
	private numeric function postPaymentInfo(
		required model.payment.Payment payment,
		required model.paymentInfo.PaymentInfo paymentInfo)
	{
		if (isNull(arguments.payment.getPaymentID()) ||
			isNull(arguments.paymentInfo.getPaymentInfoID()))
		{
			delete(arguments.paymentInfo);
			return -1;
		}

		var procService = new storedproc();

		procService.setProcedure("PostPaymentInfo");
		procService.addParam(cfsqltype="cf_sql_integer", type="in", value=arguments.paymentInfo.getPolicy().getPolicyID());
		procService.addParam(cfsqltype="cf_sql_integer", type="in", value=arguments.paymentInfo.getPaymentInfoID());
		procService.addParam(cfsqltype="cf_sql_money", type="in", value=arguments.payment.getAmount());
		procService.addParam(cfsqltype="cf_sql_tinyint", type="in", value=arguments.payment.getMethod());
		procService.addParam(cfsqltype="cf_sql_integer", type="in", value=arguments.payment.getUser().getUserID());
		procService.addParam(cfsqltype="cf_sql_integer", type="in", value=arguments.payment.getPaymentID());
		procService.addParam(cfsqltype="cf_sql_integer", type="out", variable="paymentDetailID");

		var result = procService.execute();

		return structFind(result.getProcOutVariables(), "paymentDetailID");
	}

	/**
    @author Peruz Carlsen
    @createdate 20120326
    @hint Executes ProcessRenewal_NotWritten procedure
    @output false
    **/
	private void function processNotWrittenRenewal(required model.policy.Policy policy)
	{
		var procService = new storedproc();

		procService.setProcedure("ProcessRenewal_NotWritten");
		procService.addParam(cfsqltype="cf_sql_integer", type="in", value=arguments.policy.getPolicyID());
		procService.execute();
	}

	/**
    @author Peruz Carlsen
    @createdate 20120328
    @hint Executes ProcessReinstatement procedure
    @output false
    **/
	private void function processReinstatement(required model.policy.Policy policy)
	{
		var procService = new storedproc();

		procService.setProcedure("ProcessReinstatement");
		procService.addParam(cfsqltype="cf_sql_integer", type="in", value=arguments.policy.getPolicyID());
		procService.execute();
	}
}