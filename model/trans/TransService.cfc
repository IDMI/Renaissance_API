/**
trans/TransService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Trans service
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
	public model.trans.TransService function init() {
		super.init(entityName="Trans");

		return this;
	}
}