/**
appQuestionResponse/AppQuestionResponseService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint App question response service
@output false
**/
component
	extends="coldbox.system.orm.hibernate.VirtualEntityService"
	singleton
{
	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint constructor
    @output false
    **/
	public model.appQuestionResponse.AppQuestionResponseService function init() {
		super.init(entityName="AppQuestionResponse");

		return this;
	}
}