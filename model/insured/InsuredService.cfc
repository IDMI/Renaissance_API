/**
insured/InsuredService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Insured service
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
	public model.insured.InsuredService function init() {
		super.init(entityName="Insured");

		return this;
	}
}