component
	singleton="true"
	output="false"
{
	public DateUtils function init()
		output="false"
	{
		setPluginName("DateUtils");
		setPluginVersion("1.0");
		setPluginDescription("Contains commonly used date/time functions");
		setPluginAuthor("Peruz Carlsen");
		setPluginAuthorURL("");

		return this;
	}

	public string function formatDate(required string date)
		output="false"
	{
		arguments.date = trim(arguments.date);

		if (isDate(arguments.date)) {
			return dateFormat(arguments.date, "mm/dd/yyyy");
		} else if (reFind("^(\d{2})(\d{2})(\d{4})$", arguments.date)) {
			return dateFormat(createDate(right(arguments.date, 4), left(arguments.date, 2), mid(arguments.date, 3, 2)), "mm/dd/yyyy");
		} else {
			return arguments.date;
		}
	}

	public string function formatTime(required string time)
		output="false"
	{
		arguments.time = trim(arguments.time);

		if (isDate(arguments.time)) {
			return timeFormat(arguments.time, "hh:mm tt");
		} else {
			return arguments.time;
		}
	}

	public string function formatDateTime(required string dateTime)
		output="false"
	{
		arguments.dateTime = trim(arguments.dateTime);

		return formatDate(arguments.dateTime) & " " & formatTime(arguments.dateTime);
	}
}