/**
IVRConfig/IVRConfigService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint IVR config service
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
	public model.IVRConfig.IVRConfigService function init() {
		super.init(entityName="IVRConfig");

		return this;
	}
}