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
	//property name="IVRPaymentService" inject="model";
	//property name="IVRResponseService" inject="model";
	//property name="IVRService" inject="model";
	property name="noteService" inject="model";
	property name="paymentInfoService" inject="model";
	property name="policyService" inject="model";
	property name="systemInfoService" inject="model";
	property name="systemUser" inject;
	property name="transService" inject="model";
	property name="utils" inject="model";
	property name="ECSTransactionService" inject;
	property name="appUrl" inject="coldbox:setting:appUrl";

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

		if (arguments.payment.getMethod() == application.constants.payment.method.creditCard) {

			var ECSTransactions = ECSTransactionService.list(criteria={policyID = arguments.payment.getPolicy().getPolicyID(), paymentID = arguments.payment.getPaymentID()}, asQuery=false);

			if (arrayLen(ECSTransactions)) {
				var httpService = new http();
				httpService.setMethod("post");
				httpService.setUrl("#appUrl#/index.cfm/api/ecs/payments/refund.json");
				httpService.addParam(type="formfield", name="amount", value=ECSTransactions[1].getAmount());
				httpService.addParam(type="formfield", name="transactionID", value=ECSTransactions[1].getTransactionID());
				httpService.addParam(type="formfield", name="policyID", value=arguments.payment.getPolicy().getPolicyID());

				var prefix = httpService.send().getPrefix();
				var refundResponse = deserializeJSON(prefix.fileContent);

				try {
					if (refundResponse.message.response != 1) {
						throw(
							"Unable to refund credit card payment." & getUtils().newLine() &
							"Error Code: " & refundResponse.message.responseText.response_code & getUtils().newLine() &
							"Server Reponse: " & refundResponse.message.responseText
						);
					}

					var ECSTransaction = ECSTransactionService.get(refundResponse.message.ECSTransactionID);
					ECSTransaction.setPaymentID(arguments.payment.getPaymentID());
					ECSTransaction.setUserID(5);
					save(entity=ECSTransaction, flush=true);
					refresh(ECSTransaction);
				} catch (any e) {
					throw("#serializeJSON(refundResponse)#");
				}

			}

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
		model.paymentInfo.PaymentInfo paymentInfo,
		model.payment.ECSTransaction ECSTransaction)
	{
		try {
			if (!isNull(arguments.payment.getPaymentID())) {
				return arguments.payment;
			}

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

				var ccExp = toString(DatePart("m",arguments.paymentInfo.getCCexpDate())) & toString(Right(DatePart('yyyy', arguments.paymentInfo.getCCexpDate()), 2));
				var httpService = new http();
				httpService.setMethod("get");
				httpService.setUrl("#appUrl#/index.cfm/api/ecs/payments/validate.json");
				httpService.addParam(type="url", name="payment", value="creditcard");
				httpService.addParam(type="url", name="payment_name", value=arguments.paymentInfo.getPaymentName());
				httpService.addParam(type="url", name="address1", value=arguments.paymentInfo.getAddress1());
				httpService.addParam(type="url", name="city", value=arguments.paymentInfo.getCity());
				httpService.addParam(type="url", name="zip", value=arguments.paymentInfo.getZip());
				httpService.addParam(type="url", name="country", value=arguments.paymentInfo.getCCCountry());
				httpService.addParam(type="url", name="ccNumber", value=arguments.paymentInfo.getCCNumber());
				httpService.addParam(type="url", name="ccExp", value=ccEXP);
				httpService.addParam(type="url", name="cvv", value=arguments.paymentInfo.getCCSecurity1());
				httpService.addParam(type="url", name="policyID", value=arguments.policy.getPolicyID());
				httpService.addParam(type="url", name="usersID", value=5);

				var prefix = httpService.send().getPrefix();
				var validateResponse = deserializeJSON(prefix.fileContent);

				// error check
				if (validateResponse.message.response != 1) {
					throw(
						"Unable to post credit card payment." & getUtils().newLine() &
						"Error Code: " & validateResponse.message.responseText.response_code & getUtils().newLine() &
						"Server Reponse: " & validateResponse.message.responseText
					);
				} else {

				//try{
				arguments.ECSTransaction = ECSTransactionService.get(validateResponse.message.ECSTransactionID);
				arguments.ECSTransaction.setUserID(5);
				save(entity=arguments.ECSTransaction, flush=true);
				refresh(arguments.ECSTransaction);
				//} catch (any e) {
					//throw(
						//"validateResponse=#serializeJSON(validateResponse)#"
					//);
					//abort;
				//}

				//throw(
					//"amount=#arguments.payment.getAmount()#,policyID=#arguments.payment.getPolicyID()#,insuredID=#arguments.payment.getInsuredID()#,paymentInfoType=#arguments.payment.getPaymentInfoType()#,payment_name=#arguments.payment.getPaymentName()#,address1=#arguments.payment.getAddress1()#,city=#arguments.payment.getCity()#"
				//);
				//abort;

					var httpService = new http();
					httpService.setMethod("post");
					httpService.setUrl("#appUrl#/index.cfm/api/ecs/payments/sale.json");
					httpService.addParam(type="formfield", name="amount", value=arguments.payment.getAmount());
					httpService.addParam(type="formfield", name="policyID", value=arguments.policy.getPolicyID());
					httpService.addParam(type="formfield", name="insuredID", value=arguments.policy.getInsuredID());
					httpService.addParam(type="formfield", name="paymentInfoType", value=arguments.paymentInfo.getPaymentInfoType());
					httpService.addParam(type="formfield", name="payment", value="creditcard");
					httpService.addParam(type="formfield", name="payment_name", value=arguments.paymentInfo.getPaymentName());
					httpService.addParam(type="formfield", name="address1", value=arguments.paymentInfo.getAddress1());
					httpService.addParam(type="formfield", name="city", value=arguments.paymentInfo.getCity());
					httpService.addParam(type="formfield", name="state", value=arguments.paymentInfo.getState());
					httpService.addParam(type="formfield", name="zip", value=arguments.paymentInfo.getZip());
					httpService.addParam(type="formfield", name="country", value=arguments.paymentInfo.getCCCountry());
					httpService.addParam(type="formfield", name="ccNumber", value=arguments.paymentInfo.getCCNumber());
					httpService.addParam(type="formfield", name="ccExp", value=ccEXP);
					httpService.addParam(type="formfield", name="cvv", value=arguments.paymentInfo.getCCSecurity1());
					httpService.addParam(type="formfield", name="customerVault", value="");
					httpService.addParam(type="formfield", name="recurringPayment", value=arguments.paymentInfo.getRecurringPayment());

					prefix = httpService.send().getPrefix();
					var saleResponse = deserializeJSON(prefix.fileContent);

					if (saleResponse.message.response != 1) {
						throw(
							"Unable to post credit card payment." & getUtils().newLine() &
							"Error Code: " & saleResponse.message.responseText.response_code & getUtils().newLine() &
							"Server Reponse: " & saleResponse.message.responseText
						);
					}

					arguments.ECSTransaction = ECSTransactionService.get(saleResponse.message.ECSTransactionID);

					//arguments.payment.getPaymentService().get(saleResponse.message.paymentID);

					arguments.payment.setCheckNum(Right(arguments.paymentInfo.getCCNumber(),4) & " / " & saleResponse.message.authCode);
					arguments.payment.setNote("CreditCard");

				}

				arguments.policy.addPayment(arguments.payment);
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
			if (arguments.payment.getMethod() == application.constants.payment.method.creditCard) {

				arguments.ECSTransaction.setPaymentID(arguments.payment.getPaymentID());
				arguments.ECSTransaction.setUserID(5);
				save(entity=arguments.ECSTransaction, flush=true);
				refresh(arguments.ECSTransaction);

				var cardType = "???";

				if (arguments.paymentInfo.getCCType() == 1) {
					cardType = "AMEX";
				} else if(arguments.paymentInfo.getCCType() == 2){
					cardType = "MasterCard";
				} else if (arguments.paymentInfo.getCCType() == 3) {
					cardType = "Visa";
				} else if (arguments.paymentInfo.getCCType() == 4) {
					cardType = "Discover";
				}

				arguments.policy.addNote(getNoteService().new({
					"policy" = arguments.policy,
					"user" = 5,
					"noteType" = 5,
					"subject" = "Credit Card Payment",
					"body" = arrayToList([
						"Date/Time: " & getDateUtils().formatDateTime(arguments.payment.getPaymentDate()),
						"Card Holder: " & arguments.paymentInfo.getPaymentName(),
						"Amount Charged to Credit Card: " & dollarFormat(arguments.payment.getAmount()),
						"Amount Applied to Policy: " & dollarFormat(arguments.payment.getAmount()),
						"Service Charge: " & dollarFormat(0),
						"Credit Card: " & cardType,
						"Confirmation Number: " & arguments.ECSTransaction.getTransactionID()
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