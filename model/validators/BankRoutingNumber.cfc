/**
validators/BankRoutingNumber.cfc
@author Peruz Carlsen
@createdate 20120328
@hint Validation logic for Bank Routing Number
**/
component
	implements="coldbox.system.validation.validators.IValidator"
	accessors="true"
	singleton
{
	property name="name";

	/**
    @author Peruz Carlsen
    @createdate 20120328
    @hint Constructor
    **/
	BankRoutingNumber function init(){
		name = "BankRoutingNumber";
		return this;
	}

	/**
    @author Peruz Carlsen
    @createdate 20120328
    @hint Tests the value
    **/
	boolean function validate(
		required coldbox.system.validation.result.IValidationResult validationResult,
		required any target, required string field,
		any targetValue,
		any validationData)
	{
		if (reFind("^\d{9}$", arguments.targetValue)) {
			var digits = listToArray(arguments.targetValue, "");
			var checkSum = 0;

			for (var i=1;i<=arrayLen(digits);i += 3) {
				checkSum += digits[i] * 3 + digits[i + 1] * 7 + digits[i + 2];
			}

			if (checkSum != 0 && checkSum % 10 == 0) {
				return true;
			}
		}

		var args = {message="The '#arguments.field#' value is not a valid bank routing number", field=arguments.field, validationType=getName(), validationData=arguments.validationData};
		validationResult.addError(validationResult.newError(argumentCollection=args).setErrorMetadata({regex=arguments.validationData}));

		return false;
	}

	/**
    @author Peruz Carlsen
    @createdate 20120328
    @hint Returns validation name
    **/
	string function getName(){
		return name;
	}
}