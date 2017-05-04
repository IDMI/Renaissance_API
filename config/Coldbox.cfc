<cfcomponent output = "false" hint = "My App Configuration">
<cfscript>
/**
structures/arrays to create for configuration

- coldbox (struct)
- settings (struct)
- conventions (struct)
- environments (struct)
- ioc (struct)
- models (struct) DEPRECATED use Wirebox instead
- wirebox (struct)
- debugger (struct)
- mailSettings (struct)
- i18n (struct)
- webservices (struct)
- datasources (struct)
- layoutSettings (struct)
- layouts (array of structs)
- cacheBox (struct)
- interceptorSettings (struct)
- interceptors (array of structs)
- modules (struct)
- logBox (struct)

Available objects in variable scope
- controller
- logBoxConfig
- appMapping (auto calculated by ColdBox)

Required Methods
- configure() : The method ColdBox calls to configure the application.
Optional Methods
- detectEnvironment() : If declared the framework will call it and it must return the name of the environment you are on.
- {environment}() : The name of the environment found and called by the framework.

*/

	// Configure ColdBox Application
	function configure(){

		var appMappingWithDots = reReplace(appMapping, "(/|\\)", ".", "all");
		if (len(appMappingWithDots)) {
			appMappingWithDots &= ".";
		}

		// coldbox directives
		coldbox = {
			//Application Setup
			appName = "windhaven API",
			eventName = "event",

			//Development Settings
			debugMode = false,
			debugPassword = "6tCYMX",
			reinitPassword = "FoRfV6",
			handlersIndexAutoReload = false,
			configAutoReload = false,

			//Implicit Events
			defaultEvent = "home.index",
			requestStartHandler = "Main.onRequestStart",
			requestEndHandler = "",
			applicationStartHandler = "Main.onAppInit",
			applicationEndHandler = "",
			sessionStartHandler = "Main.onSessionStart",
			sessionEndHandler = "",
			missingTemplateHandler = "",

			//Extension Points
			UDFLibraryFile = "",
			coldboxExtensionsLocation = "",
			modulesExternalLocation = [],
			pluginsExternalLocation = "",
			viewsExternalLocation = "",
			layoutsExternalLocation = "",
			handlersExternalLocation = "",
			requestContextDecorator = "model.decorators.RequestContext",

			//Error/Exception Handling
			exceptionHandler = "Main.onException",
			onInvalidEvent = "Main.onInvalidEvent",
			customErrorTemplate = "",

			//Application Aspects
			handlerCaching = false,
			eventCaching = false,
			proxyReturnCollection = false,
			flashURLPersistScope = "session"
		};

		// custom settings
		settings = {
			appMappingWithDots = appMappingWithDots,
			appUrl = "https://windhaven.live.ptsapp.com",
			defaultFormat = "json",
			requiresSSL = false,
			rootDrive = "D:",
			attachmentDir = "D:\pts\attachment\",
			acceptFileTypes = "(\.|\/)(gif|jpe?g|png|pdf|mp3|mov|mpe?g|m4a|wav|wma|mp4|avi|doc|docx|zip|eml|msg|ppt|pptx|xlsx|xls|txt|tiff|tif)$"
		};

		// environment settings, create a detectEnvironment() method to detect it yourself.
		// create a function with the name of the environment so it can be executed if that environment is detected
		// the value of the environment is a list of regex patterns to match the cgi.http_host.
		environments = {
			localdev = "\.local",
			localalt = "\.local\.",
			development = "\.dev\.",
			qa = "\.qa\.",
			er = "\.er\.",
			cycle = "\.cycle\.",
			staging = "\.staging",
			stagingalt = "\.staging\."
		};

		// Module Directives
		modules = {
			//Turn to false in production
			autoReload = false,
			// An array of modules names to load, empty means all of them
			include = [],
			// An array of modules names to NOT load, empty means none
			exclude = []
		};

		//LogBox DSL
		logBox = {
			// Define Appenders
			appenders = {
				coldboxTracer = { class = "coldbox.system.logging.appenders.ColdboxTracerAppender" }
			},
			// Root Logger
			root = { levelmax = "INFO", appenders = "*" },
			// Implicit Level Categories
			info = [ "coldbox.system" ]
		};

		//Layout Settings
		layoutSettings = {
			defaultLayout = "Layout.Main.cfm",
			defaultView = ""
		};

		//WireBox Integration
		wireBox = {
			enabled = true,
			//binder = "config.WireBox",
			singletonReload = true
		};

		//Interceptor Settings
		interceptorSettings = {
			throwOnInvalidStates = false,
			customInterceptionPoints = ""
		};

		//Register interceptors as an array, we need order
		interceptors = [
			//Autowire
			{class = "coldbox.system.interceptors.Autowire",
			 properties = {}
			},
			//SES
			{class = "coldbox.system.interceptors.SES",
			 properties = {}
			},
			//Security
			{
				class="coldbox.system.interceptors.Security",
			 	properties = {
				 	useRoutes=true,
				 	rulesSource="json",
				 	rulesFile="config/Security.json.cfm",
					debugMode=false,
					validatorModel="SecurityService"
				}
			}
		];

		//Datasources
		datasources = {
			main = {name = "PTSS55", dbType = "mssql", username = "", password = ""}
		};

		/*
		//Register Layouts
		layouts = [
			{ name = "login",
		 	  file = "Layout.tester.cfm",
			  views = "vwLogin,test",
			  folders = "tags,pdf/single"
			}
		];

		//Conventions
		conventions = {
			handlersLocation = "handlers",
			pluginsLocation = "plugins",
			viewsLocation = "views",
			layoutsLocation = "layouts",
			modelsLocation = "model",
			modulesExternalLocation = "",
			eventAction = "index"
		};

		//IOC Integration
		ioc = {
			framework = "lightwire",
			reload = true,
			objectCaching = false,
			definitionFile = "config/coldspring.xml.cfm",
			parentFactory = {
				framework = "coldspring",
				definitionFile = "config/parent.xml.cfm"
			}
		};

		//Debugger Settings
		debugger = {
			enableDumpVar = false,
			persistentRequestProfilers = true,
			maxPersistentRequestProfilers = 10,
			maxRCPanelQueryRows = 50,
			//Panels
			showTracerPanel = true,
			expandedTracerPanel = true,
			showInfoPanel = true,
			expandedInfoPanel = true,
			showCachePanel = true,
			expandedCachePanel = true,
			showRCPanel = true,
			expandedRCPanel = true,
			showModulesPanel = true,
			expandedModulesPanel = false
		};

		//Mailsettings
		mailSettings = {
			server = "",
			username = "",
			password = "",
			port = 25
		};

		//i18n & Localization
		i18n = {
			defaultResourceBundle = "includes/i18n/main",
			defaultLocale = "en_US",
			localeStorage = "session",
			unknownTranslation = "**NOT FOUND**"
		};

		//webservices
		webservices = {
			testWS = "http://www.test.com/test.cfc?wsdl",
			AnotherTestWS = "http://www.coldbox.org/distribution/updatews.cfc?wsdl"
		};
		*/
	}

	function localdev() {
		coldbox.debugPassword = "";
		coldbox.reinitPassword = "";
		coldbox.debugMode = false;
		coldbox.handlersIndexAutoReload = true;
		coldbox.handlerCaching = false;
		coldbox.eventCaching = false;

		//modules.autoReload = true;

		logBox.root = { levelmax = "DEBUG", appenders = "*" };

		debugger.expandedTracerPanel = false;
		debugger.expandedInfoPanel = false;
		debugger.expandedCachePanel = false;
		debugger.expandedRCPanel = false;
		debugger.expandedModulesPanel = false;

		settings.appUrl = "http://windhaven.local";
		settings.requiresSSL = false;
		settings.rootDrive = "C:";
		settings.attachmentDir = "C:\pts\attachment\";
	}

	function localalt() {
		localdev();
	}

	function development() {
		settings.appUrl = "http://windhaven.dev.ptsapp.com";
		settings.requiresSSL = false;
	}

	function qa() {
		settings.appUrl = "http://windhaven.qa.ptsapp.com";
		settings.requiresSSL = false;
	}

	function cycle() {
		settings.appUrl = "http://windhaven.cycle.ptsapp.com";
		settings.requiresSSL = false;
	}

	function er() {
		settings.appUrl = "http://windhaven.er.ptsapp.com";
		settings.requiresSSL = false;
	}

	function staging() {
		settings.appUrl = "http://windhaven.staging.ptsapp.com";
		settings.requiresSSL = false;
	}

	function stagingalt() {
		staging();
	}
</cfscript>
</cfcomponent>