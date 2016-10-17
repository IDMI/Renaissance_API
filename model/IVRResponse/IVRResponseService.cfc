/**
IVRResponse/IVRResponseService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint IVR response service
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
	public model.IVRResponse.IVRResponseService function init() {
		super.init(entityName="IVRResponse");

		return this;
	}
}