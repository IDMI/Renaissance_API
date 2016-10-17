/**
api/Attachments.cfc
@author Peruz Carlsen
@createdate 20141002
@hint Attachment handler
**/
component  output="false" accessors="true" extends="Base" {
	property name="acceptFileTypes" inject="coldbox:setting:acceptFileTypes";
	property name="attachmentDir" inject="coldbox:setting:attachmentDir";
	property name="attachmentService" inject;
	property name="claimIncidentService" inject;
	property name="fileUtils" inject="coldbox:plugin:FileUtils";
	property name="policyService" inject;
	property name="userService" inject;

	this.aroundHandler_except = "view";

	function index(event, rc, prc) {
		prc.data.message = attachmentService.list(criteria=rc, sortOrder=event.getValue("sort", ""),max=event.getValue("max", 0),asQuery=event.getValue("asQuery", false));
	}

	function show(event, rc, prc) {
		prc.data.message = attachmentService.get(rc.id);
	}

	function create(event, rc, prc) {
		prc.data.message = attachmentService.populate(target=attachmentService.new(), memento=rc, exclude="id,addDate,claimIncident,policy,user");

		if (event.valueExists("policy")) {
			prc.data.message.setPolicy(policyService.get(rc.policy.policyID));
		}

		if (event.valueExists("claimIncident")) {
			prc.data.message.setClaimIncident(claimIncidentService.get(rc.claimIncident.id));
		}

		if (event.valueExists("user")) {
			prc.data.message.setUser(userService.get(rc.user.userID));
		}

		attachmentService.save(entity=prc.data.message, flush=true);
	}

	function view(event, rc, prc) {
		try {
			prc.attachment = attachmentService.get(rc.id);

			if (isNull(prc.attachment)) {
				throw("Attachment Not Found", "HTML_404");
			}

			event.setHTTPHeader(name="Content-Disposition", value=attachmentService.getContentDisposition(prc.attachment.getName()));
			event.renderData(data=attachmentService.attachmentReadBinary(prc.attachment), contentType=attachmentService.getMimeType(prc.attachment.getName()), isBinary=true);
		} catch ("HTML_404" e) {
			event.renderData(data="", statusCode="404", statusText=e.message);
		} catch (any e) {
			rethrow;
		}
	}

	function upload(event, rc, prc) {
		prc.directory = attachmentDir & dateFormat(now(), "yyyy\mm\");
		if (!directoryExists(prc.directory))  {
			directoryCreate(prc.directory);
		}
		prc.data.message = fileUtils.uploadFile("file", prc.directory);
		if (!reFindNoCase(acceptFileTypes, prc.data.message.serverFile)) {
			fileDelete(prc.data.message.serverDirectory & "\" & prc.data.message.serverFile);
			throw("File type not allowed");
		}
	}
}
