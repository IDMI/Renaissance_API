component
	output="false"
{
	public Utils function init()
		output="false"
	{
		setPluginName("Utils");
		setPluginVersion("1.0");
		setPluginDescription("Contains commonly used utility functions");
		setPluginAuthor("Peruz Carlsen");
		setPluginAuthorURL("");

		return this;
	}

	public string function newLine()
		hint="returns new line feed"
		output="false"
	{
		return chr(13) & chr(10);
	}

	public numeric function toYesNoValue(required string yesNo)
		output="false"
	{
		arguments.yesNo = trim(arguments.yesNo);

		switch (arguments.yesNo) {
			case "Y":
				return 1;
			default:
				return 0;
		}
	}

	public any function eval(required any data)
		output="false"
	{
		arguments.data = trim(arguments.data);

		if (isNumeric(arguments.data)) {
			return arguments.data * 1;
		} else {
			return arguments.data;
		}
	}

	public string function cleanSQL(required string sqlStatement)
		output="false"
	{
		return trim(reReplace(arguments.sqlStatement, "\t|\n", " ", "all"));
	}

	array function arrayReverse(required array oldArray)
		output="false"
	{
		var newArray = [];

		for (var i=arrayLen(arguments.oldArray);i>=1;i--) {
			arrayAppend(newArray, arguments.oldArray[i]);
		}

		return newArray;
	}

	public numeric function smartArrayFind(required array array, required any search, numeric start = 1)
		output="false"
	{
		if (isSimpleValue(arguments.search)) {
			return arrayFind(arguments.array, arguments.search);
		} else if (isArray(arguments.search)) {
			for (var e in arguments.search) {
				if (arrayFind(arguments.array, e)) {
					if (arrayFindNoCase(arguments.array, e) < arguments.start) {
						continue;
					}

					return arrayFind(arguments.array, e);
				}
			}
		}

		return 0;
	}

	public numeric function smartArrayFindNoCase(required array array, required any search, numeric start = 1)
		output="false"
	{
		if (isSimpleValue(arguments.search)) {
			return arrayFindNoCase(arguments.array, arguments.search);
		} else if (isArray(arguments.search)) {
			for (var e in arguments.search) {
				if (arrayFindNoCase(arguments.array, e)) {
					if (arrayFindNoCase(arguments.array, e) < arguments.start) {
						continue;
					}

					return arrayFindNoCase(arguments.array, e);
				}
			}
		}

		return 0;
	}

	public numeric function reArrayFind(required array array, required string regex, numeric start = 1)
		output="false"
	{
		for (var i=arguments.start;i<=arrayLen(arguments.array);i++) {
			if (reFind(arguments.regex, arguments.array[i])) {
				return i;
			}
		}

		return 0;
	}

	public array function smartArrayReplace(required array array, required any search, required string replace, string scope="one")
		output="false"
	{
		var pos = smartArrayFind(arguments.array, arguments.search);

		while(pos != 0) {
			arraySet(arguments.array, pos, pos, replace(arguments.array[pos], arguments.search, arguments.replace));
			pos = smartArrayFind(arguments.array, arguments.search, pos+1);

			if (arguments.scope != "all") {
				break;
			}
		}

		return arguments.array;
	}

	public array function smartArrayReplaceNoCase(required array array, required any search, required string replace, string scope="one")
		output="false"
	{
		var pos = smartArrayFindNoCase(arguments.array, arguments.search);

		while(pos != 0) {
			arraySet(arguments.array, pos, pos, replaceNoCase(arguments.array[pos], arguments.search, arguments.replace));
			pos = smartArrayFindNoCase(arguments.array, arguments.search, pos+1);

			if (arguments.scope != "all") {
				break;
			}
		}

		return arguments.array;
	}

	public array function reArrayReplace(required array array, required string regex, required string replace, string scope="one")
		output="false"
	{
		var pos = reArrayFind(arguments.array, arguments.regex);

		while(pos != 0) {
			arraySet(arguments.array, pos, pos, reReplace(arguments.array[pos], arguments.regex, arguments.replace));
			pos = reArrayFind(arguments.array, arguments.regex, pos+1);

			if (arguments.scope != "all") {
				break;
			}
		}

		return arguments.array;
	}

	public struct function resultNew(required boolean error, required string message, required any data)
		output="false"
	{
		var result = {
			"error" = false,
			"message" = "",
			"data" = ""
		};

		structAppend(result, arguments, true);

		return result;
	}

	public struct function successResult(required any data)
		output="false"
	{
		return resultNew(false, "Success", arguments.data);
	}

	public struct function errorResult(any data = "")
		output="false"
	{
		return resultNew(true, "Error", arguments.data);
	}

	public array function arrayConcat()
		output="false"
	{
		var arrays = structKeyArray(arguments);
		var newArray = [];

		arraySort(arrays, "numeric");

		for (var i=1;i<=arrayLen(arrays);i++) {
			var oldArray = arguments[arrays[i]];

			for (var j=1;j<=arrayLen(oldArray);j++) {
				arrayAppend(newArray, oldArray[j]);
			}
		}

		return newArray;
	}

	public array function getComponentProperties(required any bean, array properties = [])
		output="false"
	{
		var metaData = !isObject(arguments.bean)?getComponentMetaData(arguments.bean):getMetaData(arguments.bean);
		var extends = structKeyExists(metaData, "extends")?structFind(metaData, "extends"):{};

		arguments.properties = arrayConcat(arguments.properties, structKeyExists(metaData, "properties")?structFind(metaData, "properties"):[]);

		return structKeyExists(extends, "name")?getComponentProperties(structFind(extends, "name"), arguments.properties):arguments.properties;
	}

	public struct function exportBean(required any bean, numeric level=1, array cfcChain = [])
		output="false"
	{
		var properties = getComponentProperties(arguments.bean);
		var memento = {};

		arrayAppend(arguments.cfcChain, arguments.bean);

		for (var i=1;i<=arrayLen(properties);i++) {
			var name = properties[i]["name"];
			var hasCFC = structKeyExists(properties[i], "cfc");
			var value = "";

			if (!isNull(evaluate("arguments.bean.get#name#()"))) {
				value = evaluate("arguments.bean.get#name#()");

				if (hasCFC) {
					if (arrayFind(arguments.cfcChain, value) || arrayLen(arguments.cfcChain) >= arguments.level) {
						continue;
					} else if (isArray(value)) {
						value = exportBeans(value, arguments.level, arguments.cfcChain);
					} else {
						value = exportBean(value, arguments.level, arguments.cfcChain);
					}
				}
			}

			structInsert(memento, name, value, true);
		}

		return memento;
	}

	public array function exportBeans(required array beans, numeric level = 1, array cfcChain = [])
		output="false"
	{
		var data = [];

		for (var i=1;i<=arrayLen(arguments.beans);i++) {
			arrayAppend(data, exportBean(arguments.beans[i], arguments.level, arguments.cfcChain));
		}

		return data;
	}
}