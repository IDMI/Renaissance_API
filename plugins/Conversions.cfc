component
	singleton="true"
	output="false"
{
	public Conversions function init()
		output="false"
	{
		setPluginName("Conversions");
		setPluginVersion("1.0");
		setPluginDescription("Contains commonly used conversion functions");
		setPluginAuthor("Peruz Carlsen");
		setPluginAuthorURL("");

		return this;
	}

	public array function queryToArray (required query data)
		output="false"
	{
		// Get the column names as an array.
		local.columns = listToArray(arguments.data.columnList);

		// Create an array that will hold the query equivalent.
		local.queryArray = [];

		// Loop over the query.
		for (local.rowIndex = 1; local.rowIndex <= arguments.data.recordCount; local.rowIndex++) {
			// Create a row structure.
			local.row = {};

			// Loop over the columns in this row.
			for (local.columnIndex = 1; local.columnIndex <= arrayLen(local.columns); local.columnIndex++) {
				// Get a reference to the query column.
				local.columnName = local.columns[local.columnIndex];

				// Store the query cell value into the struct by key.
				local.row[local.columnName] = arguments.data[local.columnName][local.rowIndex];
			}

			// Add the structure to the query array.
			arrayAppend(local.queryArray, local.row);
		}

		// Return the array equivalent.
		return(local.queryArray);
	}

	public struct function toStruct(required any data)
		output="false"
	{
		var result = {};

		if (isSimpleValue(arguments.data)) {
			if (isXML(arguments.data)) {
				result = xmlToStruct(arguments.data);
			} else if (isJSON(arguments.data)) {
				result = deserializeJSON(arguments.data);

				if (!isStruct(result)) {
					result = {"data" = result};
				}
			}
		} else if (isStruct(arguments.data)) {
			result = arguments.data;
		}

		return result;
	}

	public string function xmlToJson(required any xml, boolean includeFormatting = false)
		output="false"
	{
		var xsl = fileRead(expandPath("/includes/templates/XmlToJson.xsl"));
		var result = arguments.xml;

		if (arguments.includeFormatting) { xsl = reReplace(reReplace(reReplace(xsl, "\$\${tab}", "\t", "all"), "\$\${line}", "\n", "all"), "\$\${carriage}", "\r", "all"); 	}

		xsl = reReplace(xsl, "\$\${\w+}", "", "all");
		xsl = xmlParse(reReplace(xsl, "([\s\S\w\W]*)(<\?xml)", "\2", "all"));
		result = reReplace(result, "([\s\S\w\W]*)(<\?xml)", "\2", "all");
		result = xmlTransform(trim(result), xsl);
		result = reReplace(result, "(?i)(\'|\"")\s+(\w+)\s+\1", "\1\2\1", "all");

		return result;
	}

	public struct function xmlToStruct(required any xml, boolean includeFormatting = false)
		output="false"
	{
		return deserializeJSON(xmlToJson(argumentCollection=arguments));
	}
}