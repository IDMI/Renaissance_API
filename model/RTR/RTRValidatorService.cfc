component
	accessors="true"
	output="false"
{
	property any line;
	property payments;
	property paymentInfos;
	property string action;
	property struct errors;
	property name="validator" inject="model";

	public model.RTR.RTRValidatorService function init(any line="", string action="")
		output="false"
	{
		setLine(arguments.line);
		setAction(arguments.action);
		setErrors({});

		return this;
	}

	public boolean function hasErrors()
		output="false"
		hint="returns true if any error where found"
	{
		setErrors({});
		validate();

		return !structIsEmpty(getErrors());
	}

	private void function addDriverError(required string message, required numeric index)
		output="false"
		hint="Adds a driver error message"
	{
		addError(application.constants.error.type.driver, arguments.message, arguments.index);
	}

	private void function addError(required string type, required string message, numeric index = 0)
		output="false"
		hint="Adds a new error message"
	{
		if (!structKeyExists(application.constants.error.type, arguments.type)) {
			throw("Invalid error type [#arguments.type#]");
		}

		if (!structKeyExists(getErrors(), arguments.type)) {
			structInsert(getErrors(), arguments.type, {});
		}

		var targetStruct = structFind(getErrors(), arguments.type);

		if (arguments.index > 0) {
			if (!structKeyExists(targetStruct, "item" & arguments.index)) {
				structInsert(targetStruct, "item" & arguments.index, {});
			}

			targetStruct = structFind(targetStruct, "item" & arguments.index);
		}

		structInsert(targetStruct, "error" & structCount(targetStruct)+1, arguments.message);
	}

	private void function addInsuredError(required string message)
		output="false"
		hint="Adds an insured error message"
	{
		addError(application.constants.error.type.insured, arguments.message);
	}

	private void function addLineError(required string message)
		output="false"
		hint="Adds a line error message"
	{
		addError(application.constants.error.type.line, arguments.message);
	}

	private void function addPaymentError(required string message, required numeric index)
		output="false"
		hint="Adds a payment error message"
	{
		addError(application.constants.error.type.payment, arguments.message, arguments.index);
	}

	private void function addPaymentInfoError(required string message, required numeric index)
		output="false"
		hint="Adds a paymentInfo error message"
	{
		addError(application.constants.error.type.paymentInfo, arguments.message, arguments.index);
	}

	private void function addPolicyError(required string message)
		output="false"
		hint="Adds a policy error message"
	{
		addError(application.constants.error.type.policy, arguments.message);
	}

	private void function addVehicleError(required string message, required numeric index)
		output="false"
		hint="Adds a vehicle error message"
	{
		addError(application.constants.error.type.vehicle, arguments.message, arguments.index);
	}

	private void function validate()
		output="false"
		hint="validates data"
	{
		validateLine();
		validatePolicy();
		validateInsured();
		validatePayments();
		validatePaymentInfos();

		if (arrayFind([application.constants.policyType.pAuto], getLine().getPolicy().getPolicyType())) {
			validateVehicles();
			validateDrivers();
		}
	}

	private void function validateDrivers()
		output="false"
		hint="Validates driver information"
	{
		if (isNull(getLine().getDrivers()) || arrayLen(getLine().getDrivers()) == 0) {
			addPolicyError("No drivers found");
			return;
		}
	}

	private void function validateInsured()
		output="false"
		hint="Validates insured information"
	{
		if (!isNull(getLine().getPolicy()) && isNull(getLine().getPolicy().getInsured()) ) {
			addPolicyError("Insured entity is null");
			return;
		}
	}

	private void function validateLine()
		output="false"
		hint="Validates certificate information"
	{
		return;
	}

	private void function validatePayments()
		output="false"
		hint="Validates payment information"
	{
		if (isNull(getLine().getPolicy()) || !arrayFindNoCase([application.constants.action.bind, application.constants.action.payment], getAction())) {
			return;
		}

		var paymentCount = 0;
		paymentCount += !isNull(getLine().getPolicy().getPayments())?arrayLen(getLine().getPolicy().getPayments()):0;
		paymentCount += arrayLen(getPayments());

		if (paymentCount == 0) {
			addPolicyError("One or more payments are required");
			return;
		}

		var i = 0;
		var payment = "";
		var paymentNum = 0;
		var totalPayments = getLine().getPolicy().getTotalPayments();

		if (!isNull(getPayments())) {
			for (i=1;i<=arrayLen(getPayments());i++) {
				payment = getPayments()[i];

				if (!isNull(payment.getPaymentID())) {
					continue;
				}

				paymentNum++;
				totalPayments += isNumeric(payment.getAmount())?payment.getAmount():0;

				if (!isNumeric(payment.getAmount())) {
					addPaymentError("Payment amount #i# is required and must be a valid amount [#payment.getAmount()#]", paymentNum);
				} else if (payment.getAmount() <= 0) {
					addPaymentError("Payment amount #i# is required and cannot be zero or negative [#payment.getAmount()#]", paymentNum);
				}
			}
		}

		if (arrayFindNoCase([application.constants.action.bind], getAction()) ||
			(listFind("#application.constants.policy.status.pending#,#application.constants.policy.status.notwritten#", getLine().getPolicy().getStatus()) && getLine().getPolicy().getIsRenewal() == 1))
		{
			if (totalPayments < (getLine().getDepositAmount() - 5)) {
				addPolicyError("Payment amount is less than the minimum required amount of #dollarFormat(getLine().getDepositAmount())# #totalPayments#");
			}
		}
	}

	private void function validatePaymentInfos()
		output="false"
		hint="Validates paymentInfo information"
	{
		if (isNull(getLine().getPolicy()) || !arrayFindNoCase([application.constants.action.bind, application.constants.action.payment], getAction())) {
			return;
		}

		var i = 0;
		var payment = "";
		var paymentNum = 0;

		if (!isNull(getPaymentInfos())) {
			for (i=1;i<=arrayLen(getPaymentInfos());i++) {
				paymentInfo = getPaymentInfos()[i];

				if (!isNull(paymentInfo.getPaymentInfoID())) {
					continue;
				}

				paymentNum++;

				// check paymentName
				if (!len(trim(paymentInfo.getPaymentName()))) {
					addPaymentInfoError("Payment name #paymentNum# is required [#paymentInfo.getPaymentName()#]", paymentNum);
				}

				// check address1
				if (!len(trim(paymentInfo.getAddress1()))) {
					addPaymentInfoError("Payment address 1 #paymentNum# is required [#paymentInfo.getAddress1()#]", paymentNum);
				}

				// check city
				if (!len(trim(paymentInfo.getCity()))) {
					addPaymentInfoError("Payment city #paymentNum# is required [#paymentInfo.getCity()#]", paymentNum);
				}

				// check state
				if (!getValidator().isStateShort(paymentInfo.getState())) {
					addPaymentInfoError("Payment state #paymentNum# is required [#paymentInfo.getState()#]", paymentNum);
				}

				// check zip
				if (!isValid("zipcode", paymentInfo.getZip())) {
					addPaymentInfoError("Payment zip #paymentNum# is required and must be valid [#paymentInfo.getZip()#]", paymentNum);
				} else if (!getValidator().isZipInState(paymentInfo.getState(), paymentInfo.getZip())) {
					addPaymentInfoError("Payment zip #paymentNum# was not found [#paymentInfo.getZip()#]", paymentNum);
				}

				if (paymentInfo.getPaymentInfoType() == application.constants.payment.method.creditCard) {
					// check ccType
					if (!arrayFind([2,3], paymentInfo.getCCType())) {
						addPaymentInfoError("Payment CC type #paymentNum# is invalid. Only Visa and MasterCard is accepted [#paymentInfo.getCCTypeLongDescription()#]", paymentNum);
					}

					// check ccNumber
					if (!getValidator().isCCNumber(paymentInfo.getCCNumber(), paymentInfo.getCCType())) {
						addPaymentInfoError("Payment CC number #paymentNum# is invalid [#paymentInfo.getCCNumber()#]", paymentNum);
					}

					// check ccExpDate
					if (!len(trim(paymentInfo.getCCExpDate()))) {
						addPaymentInfoError("Payment CC expiration date #paymentNum# is required [#paymentInfo.getCCExpDate()#]", paymentNum);
					} else if (!isDate(paymentInfo.getCCExpDate()) && !getValidator().isCCExpDate(paymentInfo.getCCExpDate())) {
						addPaymentInfoError("Payment CC expiration date #paymentNum# must be valid and formatted as MM/YY [#paymentInfo.getCCExpDate()#]", paymentNum);
					}

					// check ccSecurity1
					if (!len(trim(paymentInfo.getCCSecurity1()))) {
						addPaymentInfoError("Payment CC CVV2 number #paymentNum# is required [#paymentInfo.getCCSecurity1()#]", paymentNum);
					} else if (!getValidator().isCCCVV2(paymentInfo.getCCSecurity1(), paymentInfo.getCCType())) {
						addPaymentInfoError("Payment CC CVV2 number #paymentNum# must be valid [#paymentInfo.getCCSecurity1()#]", paymentNum);
					}
				} else if (paymentInfo.getPaymentInfoType() == application.constants.payment.method.bankDraft) {
					// check routing num
					if (!getValidator().isBankRoutingNum(paymentInfo.getBankRoutingNum())) {
						addPaymentInfoError("Payment bank routing number #paymentNum# is required and must be valid [#paymentInfo.getBankRoutingNum()#]", paymentNum);
					}

					// check bank account num
					if (!getValidator().isBankAcctNum(paymentInfo.getBankAcctNum())) {
						addPaymentInfoError("Payment bank account number #paymentNum# is required and must be valid [#paymentInfo.getBankAcctNum()#]", paymentNum);
					}
				}
			}
		}
	}

	private void function validatePolicy()
		output="false"
		hint="Validates policy information"
	{
		if (isNull(getLine().getPolicy())) {
			addPolicyError("Policy entity is null");
			return;
		}

		// check status
		if ((arrayFindNoCase([application.constants.action.policy], getAction()) && getLine().getPolicy().getStatus() != application.constants.policy.status.quote) ||
			((arrayFindNoCase([application.constants.action.bind], getAction()) && 	getLine().getPolicy().getStatus() != application.constants.policy.status.pending)))
		{
			addPolicyError("Policy is invalid [#getLine().getPolicy().getStatus()#]");
		}
	}

	private void function validateVehicles()
		output="false"
		hint="Validates vehicle information"
	{
		if (isNull(getLine().getVehicles()) || arrayLen(getLine().getVehicles()) == 0) {
			addPolicyError("No vehicles found");
			return;
		}
	}
}