/**
auto/AutoService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Auto service
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
	public model.auto.AutoService function init() {
		super.init(entityName="Auto");

		return this;
	}
}