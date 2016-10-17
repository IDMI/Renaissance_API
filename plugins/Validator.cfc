component
	singleton="true"
	output="false"
{
	public Validator function init()
		output="false"
	{
		setPluginName("Validator");
		setPluginVersion("1.0");
		setPluginDescription("Contains commonly used validation functions");
		setPluginAuthor("Peruz Carlsen");
		setPluginAuthorURL("");

		return this;
	}

	public boolean function isFirstName(required string firstName)
		hint="returns true if the argument is a valid first name"
		output="false"
	{
		return reFind("^\s*[A-Za-z]+-*[A-Za-z]+\s*$", arguments.firstName)?true:false;
	}

	public boolean function isMiddleName(required string middleName)
		hint="returns true if the argument is a valid middle name"
		output="false"
	{
		return reFind("[^A-Za-z\s]", arguments.middleName)?false:true;
	}

	public boolean function isLastName(required string lastName)
		hint="returns true if the argument is a valid last name"
		output="false"
	{
		return reFind("^\s*[A-Za-z]+-*[A-Za-z]+\s*$", arguments.lastName)?true:false;
	}

	public boolean function isPhone(required string phone)
		hint="returns true if the argument is a valid phone number"
		output="false"
	{
		return reFind("^\s*\(\d{3}\)\s?\d{3}\-\d{4}\s*$", arguments.phone)?true:false;
	}

	public boolean function isEmail(required string email)
		hint="returns true if the argument is a valid email address"
		output="false"
	{
		return isValid("email", arguments.email);
	}

	public boolean function isStateShort(required string stateShort)
		hint="returns true if the argument is a valid state short"
		output="false"
	{
		return reFind("^\s*[A-Za-z]{2}\s*$", arguments.stateShort)?true:false;
	}

	public boolean function isVehicleYear(required string vehicleYear)
		hint="returns true if the argument is a valid vehicleYear"
		output="false"
	{
		return reFind("^\s*\d{4}\s*$", arguments.vehicleYear)?true:false;
	}

	public boolean function isLicenseNum(required string stateShort, required string licenseNum)
		hint="returns true if the licNum is valid"
		output="false"
	{
		switch(arguments.stateShort) {
			case "NY":
				return reFind("^\s*[A-Za-z0-9]{9}\s*$", arguments.licenseNum)?true:false;
			default:
				return false;
		}
	}

	public boolean function isVIN(required numeric vehicleYear, required string vin)
		hint="returns true if the vin is valid"
		output="false"
	{
		if (!isVehicleYear(arguments.vehicleYear)) {
			return false;
		} else if (arguments.vehicleYear > 1980) {
			return reFind("^\s*[A-Za-z0-9]{17}\s*$", arguments.vin)?true:false;
		} else {
			return reFind("^\s*[A-Za-z0-9]{5}\s*$", arguments.vin)?true:false;
		}
	}

	public boolean function isZipInState(required string stateShort, required string zip)
		hint="returns true if zip is valid and within the given state"
		output="false"
	{
		var lookup = entityload("ZipCode" , {
			state = entityLoad("State", {stateShort=arguments.stateShort}, true),
			zipCode = listFirst(arguments.zip, "-")
		});

		return arrayLen(lookup) != 0?true:false;
	}

	public boolean function isCCNumber(required string ccNumber, numeric ccType = 0)
		hint="returns true if the CC number is valid"
		output="false"
	{
		arguments.ccNumber = reReplace(arguments.ccNumber, "\s", "", "all");

		if (reFind("[^\d]", arguments.ccNumber) || len(arguments.ccNumber) < 12) {
			return false;
		}

		var rv = reverse(arguments.ccNumber);
		var str = "";

		for (var i = 1; i <= len(arguments.ccNumber);  i++) {
			if(i%2 ==  0) {
				str &= mid(rv, i, 1) * 2;
			} else {
				str &= mid(rv, i, 1);
			}
		}

		var chk = arraySum(listToArray(str, ""));

		if (chk != 0 && chk%10 == 0) {
			switch (arguments.ccType) {
				case 1: // American Express
					if (reFind("^(34|37)\d{13}$", arguments.ccNumber)) {
						return true;
					}
					break;
				case 4: // Discover
					if (reFind("^6011\d{12}*$", arguments.ccNumber)) {
						return true;
					}
					break;
				case 2: // MasterCard
					if (reFind("^(51|52|53|54|55)\d{14}$", arguments.ccNumber)) {
						return true;
					}
					break;
				case 3: // VISA
					if (reFind("^4(\d{12}|\d{15})$", arguments.ccNumber)) {
						return true;
					}
					break;
				default:
					return true;
			}
		}

		return false;
	}

	public boolean function isCCExpDate(required string ccExpDate)
		hint="returns true if the CC expiration date is valid"
		output="false"
	{
		// matches MMYY, MM/YY, MM/YYYY, or MM/DD/YYYY
		if (!reFind("^\s*((\d{4})|(\d{2}\/\d{2})|(\d{2}\/\d{4})|(\d{2}\/\d{2}\/\d{4}))\s*$", arguments.ccExpDate)) {
			return false;
		}

		// matches MM/YYYY, or MM/DD/YYYY
		if (reFind("^\s*((\d{2}\/\d{4})|(\d{2}\/\d{2}\/\d{4}))\s*$", arguments.ccExpDate)) {
			var m = trim(listFirst(arguments.ccExpDate, "/"));
			var y = trim(listLast(arguments.ccExpDate, "/"));
		// matches MM/YY
		} else if (reFind("^\s*\d{2}\/\d{2}\s*$", arguments.ccExpDate)) {
			var m = trim(listFirst(arguments.ccExpDate, "/"));
			var y = left(datePart("yyyy", now()), 2) & trim(listLast(arguments.ccExpDate, "/"));
		// matches MMYY
		} else {
			var m = trim(left(arguments.ccExpDate, 2));
			var y = left(datePart("yyyy", now()), 2) & trim(right(arguments.ccExpDate, 2));
		}

		if (m > 12 || m < 1 || y < datePart("yyyy", now())) {
			return false;
		}

		var expDate = dateFormat(createDate(y, m, daysInMonth(createDate(y, m, 1))), "m/d/yyyy");

		if (dateDiff("d", expDate, dateFormat(now(), "m/d/yyyy")) > 0) {
			return false;
		}

		return true;
	}

	public boolean function isCCCVV2(required string cvv2, numeric ccType = 0)
		hint="returns true if the CCV is valid"
		output="false"
	{
		switch (arguments.ccType) {
			case 1: // American Express
				return reFind("^\s*\d{4}\s*$", arguments.cvv2)?true:false;
			default:
				return reFind("^\s*\d{3}\s*$", arguments.cvv2)?true:false;
		}
	}

	public boolean function isBankRoutingNum(required string bankRoutingNum)
		output="false"
	{
		if (!reFind("^\d{9}$", arguments.bankRoutingNum)) {
			return false;
		}

		var digits = listToArray(arguments.bankRoutingNum, "");
		var checkSum = 0;

		for (var i=1;i<=arrayLen(digits);i += 3) {
			checkSum += digits[i] * 3 + digits[i + 1] * 7 + digits[i + 2];
		}

		return checkSum != 0 && checkSum % 10 == 0;
	}

	public boolean function isBankAcctNum(required string bankAcctNum)
		output="false"
	{
		if (!reFind("^\d+$", arguments.bankAcctNum)) {
			return false;
		}

		if (len(arguments.bankAcctNum) > 25) {
			return false;
		}

		return true;
	}
}