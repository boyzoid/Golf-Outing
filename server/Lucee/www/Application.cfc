component extends="framework.one" {
	
	/*
		This is provided for illustration only - YOU SHOULD NOT USE THIS IN
		A REAL PROGRAM! ONLY SPECIFY THE DEFAULTS YOU NEED TO CHANGE!
	variables.framework = {
		// the name of the URL variable:
		action = 'action',
		// whether or not to use subsystems:
		usingSubsystems = false,
		// default subsystem name (if usingSubsystems == true):
		defaultSubsystem = 'home',
		// default section name:
		defaultSection = 'main',
		// default item name:
		defaultItem = 'default',
		// if using subsystems, the delimiter between the subsystem and the action:
		subsystemDelimiter = ':',
		// if using subsystems, the name of the subsystem containing the global layouts:
		siteWideLayoutSubsystem = 'common',
		// the default when no action is specified:
		home = defaultSubsystem & ':' & defaultSection & '.' & defaultItem,
		-- or --
		home = defaultSection & '.' & defaultItem,
		// the default error action when an exception is thrown:
		error = defaultSubsystem & ':' & defaultSection & '.error',
		-- or --
		error = defaultSection & '.error',
		// the URL variable to reload the controller/service cache:
		reload = 'reload',
		// the value of the reload variable that authorizes the reload:
		password = 'true',
		// debugging flag to force reload of cache on each request:
		reloadApplicationOnEveryRequest = false,
		// whether to force generation of SES URLs:
		generateSES = false,
		// whether to omit /index.cfm in SES URLs:
		SESOmitIndex = false,
		// location used to find layouts / views:
		base = ... relative path from Application.cfc to application files ...
		// either CGI.SCRIPT_NAME or a specified base URL path:
		baseURL = 'useCgiScriptName',
		// location used to find controllers / services:
		// cfcbase = essentially base with / replaced by .
		// list of file extensions that FW/1 should not handle:
		unhandledExtensions = 'cfc',
		// list of (partial) paths that FW/1 should not handle:
		unhandledPaths = '/flex2gateway',
		// flash scope magic key and how many concurrent requests are supported:
		preserveKeyURLKey = 'fw1pk',
		maxNumContextsPreserved = 10,
		// set this to true to cache the results of fileExists for performance:
		cacheFileExists = false,
		// change this if you need multiple FW/1 applications in a single CFML application:
		applicationKey = 'framework.one',
        // change this if you want a different dependency injection engine:
        diEngine = 'di1',
        // change this if you want different locations to be scanned by the D/I engine:
        diLocations = 'model,controllers',
        // optional configuration for your dependency injection engine:
        diConfig = { },
        // routes (for fancier SES URLs) - see the documentation for details:
        routes = [ ],
        routesCaseSensitive = true
	};
	*/
	this.name = "golf_outing";
	this.sessionManagement = true;
	this.sessionManagement = true;
	this.datasource = "golfOuting";
	this.ORMEnabled = "true";
	this.invokeImplicitAccessor = true;
	this.sessionTimeout = CreateTimeSpan(0,1,0,0);
	rootDir = getDirectoryFromPath(getCurrentTemplatePath());

	this.mappings['/wwwapp'] = rootDir & '../wwwapp';
	this.mappings['/model'] = rootDir & '../wwwapp/model';
	this.mappings['/controllers'] = rootDir & '../wwwapp/controllers';
	this.mappings['/validateThis'] = rootDir & '../wwwapp/validateThis';
	this.mappings[ '/root' ] = rootDir;


	this.tag = {
		dump:{ format: 'classic'},
		location: {addtoken: false }
	};

	variables.framework = {
		base: "/wwwapp",
		generateSES: true,
		SESOmitIndex: true,
		defaultSection: 'api',
		applicationKey: "golf_outing",
		diLocations: ['/model'],
		reloadApplicationOnEveryRequest = true,
		unhandledPaths: '/flex2gateway,/assets',
		reloadApplicationOnEveryRequest: getEnvironment() == 'dev',
		decodeRequestBody: true,
		routes:[
				{ '$POST/login' = '/api/login' },
				{ '$GET/course/list' = '/api/courses' },
				{ '$GET/course/{id:[0-9]*}' = '/api/course/id/:id'},
				{ '$PUT/course/' = '/api/putCourse'},
				{ '$GET/outing/list' = '/api/outings' },
				{ '$GET/outing/{id:[0-9]*}' = '/api/outing/id/:id'},
				{ '$PUT/outing/addGolfers' = '/api/addToOuting'},
				{ '$GET/outing/deleteGolfer/{golferId:[0-9]*}' = '/api/removeGolferFromOuting/id/:golferId'},
				{ '$PUT/outing/' = '/api/putOuting'},
				{ '$GET/outingdetails/{id:[0-9]*}' = 'api/outingDetails/id/:id'},
				{ '$GET/golfer/list' = '/api/golfers' },
				{ '$PUT/golfer'  = '/api/putGolfer' },
				{ '$POST/updateHandicap' = '/api/updateHandicap' },
				{ '$POST/postScore' = '/api/postScore' },
				{ '$POST/putOutingTeams' = '/api/putOutingTeams' }
			]
	};

	ormPaths=["/model/orm"];
	this.ormSettings = {dialect="MySQL",cfclocation=ormPaths,logsql=false,flushatrequestend=false,eventhandling=true,saveMapping=false, dbcreate="none", caheProvider="HashTable", secondaryCacheEnabled=false};

	function setupRequest( rc ) {
		if( structkeyExists( url, "reload" ) ){
			setupApplication();
		}
		controller( 'setup.default' );
		cfheader( name="Access-Control-Allow-Origin", value="*");
		cfheader( name="Access-Control-Allow-Headers", value="Content-Type, Access-Control-Allow-Headers, X-Requested-With, token, content-type");
		cfheader( name="Access-Control-Allow-Methods", value="OPTIONS,POST,PUT,GET" );
	}

	function setUpApplication( rc ){
		ormReload();

		application.applicationKey = variables.framework.applicationKey;
	}

	function getEnvironment(){
		return listLast(cgi.server_name, '.') == 'local' || findNocase('127', cgi.server_name) ? 'dev' : 'prod';
	}

}
