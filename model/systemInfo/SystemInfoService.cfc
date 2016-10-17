/**
systemInfo/SystemInfoService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint SystemInfo service
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
	public model.systemInfo.SystemInfoService function init() {
		super.init(entityName="SystemInfo");

		return this;
	}
}