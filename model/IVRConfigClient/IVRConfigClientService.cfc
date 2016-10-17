/**
IVRConfigClient/IVRConfigClientService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint IVR config client service
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
	public model.IVRConfigClient.IVRConfigClientService function init() {
		super.init(entityName="IVRConfigClient");

		return this;
	}
}