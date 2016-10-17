/**
handlers/Base.cfc
@author Peruz Carlsen
@createdate 20131215
@hint Base api handler
@output false
@accessors true
**/
component {
	public function aroundHandler(event, targetAction, eventArguments) {
		var args = {
			event = event,
			rc = event.getCollection(),
			prc = event.getCollection(private=true)
		};

		args.prc.data = {"error" = false, "message" = "", "detail" = ""};
		structAppend(args, eventArguments);

		try {
			targetAction(argumentCollection=args);
		} catch (any e) {
			args.prc.data.error = true;
			args.prc.data.message = e.message & " " & e.detail;
			args.prc.data.detail = e;
		}

		switch (event.getValue("format", "html")) {
		case "json": case "xml":
			event.setHTTPHeader(name="expires", value="#now()#");
			event.setHTTPHeader(name="pragma", value="no-cache");
			event.setHTTPHeader(name="cache-control", value="no-cache, no-store, must-revalidate");
			event.renderData(data=args.prc.data, type=rc.format);
			break;
		case "js":
			event.setHTTPHeader(name="expires", value="#now()#");
			event.setHTTPHeader(name="pragma", value="no-cache");
			event.setHTTPHeader(name="cache-control", value="no-cache, no-store, must-revalidate");
			event.renderData(data="#args.rc.callback#(#serializeJSON(args.prc.data)#)", contentType="text/javascript", encoding="utf-8");
			break;
		default:
			event.noRender();
		}
	}
}