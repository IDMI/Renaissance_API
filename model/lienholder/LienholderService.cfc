/**
lienholder/LienholderService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Lienholder service
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
	public model.lienholder.LienholderService function init() {
		super.init(entityName="Lienholder");

		return this;
	}
}