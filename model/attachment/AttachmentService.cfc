/**
attachment/AttachmentService.cfc
@author Peruz Carlsen
@createdate 20141118
@hint Attachment service
**/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton accessors="true" output="false"  {
	property name="mimeTypeUtils";

	public AttachmentService function init() {
		super.init(entityName="Attachment");
	    setUseQueryCaching(false);
	    setQueryCacheRegion('ORMService.defaultCache');
	    setEventHandling(true);
	    setMimeTypeUtils(createObject("java","coldfusion.util.MimeTypeUtils"));

	    return this;
	}

	public any function list(
		struct criteria=structnew(),
  		string sortOrder="",
  		numeric offset=0,
  		numeric max=0,
  		numeric timeout=0,
  		boolean ignoreCase=false,
  		boolean asQuery=getDefaultAsQuery())
	{
		var c = newCriteria();

		if (structKeyExists(criteria, "claimIncidentID") && isNumeric(criteria.claimIncidentID) && criteria.claimIncidentID) {
			c.isEQ("claimIncidentID", javaCast("int", criteria.claimIncidentID));
		}

		if (structKeyExists(criteria, "policyID") && isNumeric(criteria.policyID) && criteria.policyID) {
			c.isEQ("policyID", javaCast("int", criteria.policyID));
		}

		if (structKeyExists(criteria, "isViewableByInsured") && isNumeric(criteria.isViewableByInsured)) {
			c.isEQ("isViewableByInsured", javaCast("boolean", criteria.isViewableByInsured));
		}

		return c.list(sortOrder=sortOrder, offset=offset, max=max, timeout=timeout, ignoreCase=ignoreCase, asQuery=asQuery);
	}

	public string function getSaveAsName(required attachment) {
		var saveAsName = attachment.getName();

		if (len(trim(attachment.getSaveAsName())) && len(trim(attachment.getExtension()))) {
			saveAsName = attachment.getSaveAsName() & "." & attachment.getExtension();
		}

		return saveAsName;
	}

	public string function getMimeType(required string fileName) {
		var mimeType = getMimeTypeUtils().guessMimeType(arguments.fileName);
		var extension = getExtension(arguments.fileName);

		if (isDefined("mimeType")) {
			return mimeType;
		} else {
			return "application/#extension#";
		}
	}

	public string function getContentDisposition(required string fileName) {
		var mimeType = getMimeType(arguments.fileName);

		switch (mimeType) {
		case "audio/mpeg": case "audio/x-ms-wma": case "audio/x-wav":
			return "attachment; filename=#scrubFileName(fileName)#";
		default:
			return "inline; filename=#scrubFileName(fileName)#";
		}
	}

	public string function scrubFileName(required string fileName){
		var extension = getExtension(arguments.fileName);

		arguments.fileName = reverse(listrest(reverse(arguments.fileName),"."));
		arguments.fileName = replace(arguments.fileName, ' ', '_', 'all');
		arguments.fileName = reReplace(arguments.fileName, '\W', '', 'all');

		return arguments.fileName & "." & extension;
	}

	public string function getExtension(required string fileName) {
		return reverse(listFirst(reverse(arguments.fileName), "."));
	}

	public function attachmentReadBinary(required attachment) {
		if (!fileExists(attachment.getPath())) {
			throw("File Not Found", "HTML_404");
		}

		return fileReadBinary(attachment.getPath());
	}
}