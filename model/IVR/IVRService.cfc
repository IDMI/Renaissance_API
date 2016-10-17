/**
IVR/IVRService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint IVR service
@output false
**/
component
	accessors="true"
	singleton
{
	property initTime;
	property name="dateUtils" inject="model";
	property name="IVRConfigs" inject="model:IVRConfigService:getAll";
	property name="IVRPaymentAttemptService" inject="model";
	property name="transactionRefund" inject;
	property name="transactionSale" inject;
	property name="transactionStoreCard" inject;
	property name="systemUser" inject="model";

	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint Constructor
    @output false
    **/
	public model.IVR.IVRService function init() {
		setInitTime(now());

		return this;
	}

	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint Handles refund requests
    @output false
    **/
	public any function refund(
		required model.policy.Policy policy,
		required model.payment.Payment payment,
		required model.IVRPayment.IVRPayment IVRPayment,
		required model.IVRResponse.IVRResponse IVRResponse,
		string retryID = "",
		boolean isTest = false,
		string callID = "")
	{
		var result = getTransactionRefund().init(
			policyID = arguments.policy.getPolicyID(),
			IVR_PaymentID = arguments.IVRPayment.getIVRPaymentID(),
			paymentAmount = arguments.payment.getAmount(),
			transactionID = arguments.IVRResponse.getSent_policyNum(),
			clientUserID = getSystemUser().getUserID(),
			clientReferenceID = arguments.policy.getInsured().getInsuredID(),
			retryID = arguments.retryID,
			isTest = arguments.isTest,
			callID = arguments.callID
		);

		if (structKeyExists(local, "result")) {
			return result;
		}
	}

	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint Handles sale requests
    @output false
    **/
	public any function sale(
		required model.policy.Policy policy,
		required model.payment.Payment payment,
		required model.paymentInfo.PaymentInfo paymentInfo,
		string retryID = "",
		boolean isTest = false,
		numeric saleType = 0,
		numeric isInsuredWeb = 0,
		string callID = "")
	{
		var result = getTransactionSale().init(
			policyID = arguments.policy.getPolicyID(),
			paymentMethod = arguments.paymentInfo.getPaymentInfoType(),
			paymentName = arguments.paymentInfo.getPaymentName(),
			paymentAmount = arguments.payment.getAmount(),
			cardType = arguments.paymentInfo.getCCType(),
			cardNumber = arguments.paymentInfo.getCCNumber(),
			cardCVV = arguments.paymentInfo.getCCSecurity1(),
			cardExpirationDate = arguments.paymentInfo.getCCExpDate(),
			cardHolderStreetAddress = arguments.paymentInfo.getAddress1(),
			cardholderZip = arguments.paymentInfo.getZip(),
			cardID = arguments.paymentInfo.getCardID(),
			routingNumber = "",
			accountNumber = "",
			memo= "",
			checkNumber= "",
			address1 = arguments.paymentInfo.getAddress1(),
			address2 = arguments.paymentInfo.getAddress2(),
			city = arguments.paymentInfo.getCity(),
			zip = arguments.paymentInfo.getZip(),
			email = arguments.policy.getInsured().getEmail(),
			phone = arguments.policy.getInsured().getPhone(),
			clientUserID = getSystemUser().getUserID(),
			clientReferenceID = arguments.policy.getInsured().getInsuredID(),
			apiKey = generateAPIKey(),
			IVR_PaymentAttemptID = getIVRPaymentAttempt(arguments.policy.getInsured()).getIVRPaymentAttemptID(),
			isInsuredWeb = arguments.isInsuredWeb,
			paymentInfoID = arguments.paymentInfo.getPaymentInfoID(),
			retryID = arguments.retryID,
			isTest = arguments.isTest,
			saleType = arguments.saleType,
			callID = arguments.callID
		);

		if (structKeyExists(local, "result")) {
			return result;
		}
	}

	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint Handles store card requests
    @output false
    **/
	public any function storeCard(
		required model.policy.Policy policy,
		required model.paymentInfo.PaymentInfo paymentInfo,
		string retryID = "",
		boolean isTest = false,
		numeric isInsuredWeb = 0,
		string callID = ""	)
	{
		var result = getTransactionStoreCard().init(
			policyID = arguments.policy.getPolicyID(),
			paymentInfoID = arguments.paymentInfo.getPaymentInfoID(),
			recurringPayment = arguments.paymentInfo.getRecurringPayment(),
			paymentName = arguments.paymentInfo.getPaymentName(),
			ccType = arguments.paymentInfo.getCCType(),
			ccNumber = arguments.paymentInfo.getCCNumber(),
			ccSecurity1 = arguments.paymentInfo.getCCSecurity1(),
			ccExpDateMonth = datePart("m", arguments.paymentInfo.getCCExpDate()),
			ccExpDateYear = datePart("yyyy", arguments.paymentInfo.getCCExpDate()),
			address1 = arguments.paymentInfo.getAddress1(),
			zip = arguments.paymentInfo.getZip(),
			clientUserID = getSystemUser().getUserID(),
			clientReferenceID = arguments.policy.getInsured().getInsuredID(),
			retryID = arguments.retryID,
			isTest = arguments.isTest,
			apiKey = generateAPIKey(),
			IVR_PaymentAttemptID = getIVRPaymentAttempt(arguments.policy.getInsured()).getIVRPaymentAttemptID(),
			isInsuredWeb = arguments.isInsuredWeb,
			callID = arguments.callID
		);

		if (structKeyExists(local, "result")) {
			return result;
		}
	}

	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint Generates IVR API key
    @output false
    **/
	private string function generateAPIKey() {
		return encrypt(arrayToList([getSystemUser().getUserID(), getPaymentSeed(), getDateUtils().formatDateTime(getInitTime())], "|"), getServerKey(), "AES", "HEX");
	}

	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint Creates an IVRPaymentAttempt entry
    @output false
    **/
	private model.IVRPaymentAttempt.IVRPaymentAttempt function getIVRPaymentAttempt(required model.insured.Insured insured, boolean isPayment = false) {
		var IVRPaymentAttempt = getIVRPaymentAttemptService().findWhere({insured = arguments.insured});

		if (!structKeyExists(local, "IVRPaymentAttempt")) {
			var IVRPaymentAttempt = getIVRPaymentAttemptService().new();
			IVRPaymentAttempt.setInsured(arguments.insured);
		}

		IVRPaymentAttempt.setUser(getSystemUser());
		IVRPaymentAttempt.setTimeAtInitiation(getDateUtils().formatDateTime(getInitTime()));
		IVRPaymentAttempt.setIsPayment(arguments.isPayment);
		IVRPaymentAttempt.setMessage(IVRPaymentAttempt.getIsPayment()?"Posting Payment":"Storing Card");
		getIVRPaymentAttemptService().save(IVRPaymentAttempt);

		return IVRPaymentAttempt;
	}

	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint Returns payment seed used in the API key
    @output false
    **/
	private string function getPaymentSeed() {
		return "process" & getPTSName() & getServerInstance() & "payment";
	}

	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint Returns PTS name used in the API key
    @output false
    **/
	private string function getPTSName() {
		if (arrayLen(getIVRConfigs())) {
			return getIVRConfigs()[1].getDatasource();
		}

		return "";
	}

	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint Returns server instance used in the API key
    @output false
    **/
	private string function getServerInstance() {
		if (arrayLen(getIVRConfigs())) {
			return getIVRConfigs()[1].getServerInstance();
		}

		return "";
	}

	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint Returns server key used in the API key
    @output false
    **/
	private string function getServerKey() {
		if (arrayLen(getIVRConfigs())) {
			return getIVRConfigs()[1].getServerKey();
		}

		return "";
	}
}