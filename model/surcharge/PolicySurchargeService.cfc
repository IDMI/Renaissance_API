/**
surcharge/PolicySurchargeService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Policy surcharge service
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
	public model.surcharge.PolicySurchargeService function init() {
		super.init(entityName="PolicySurcharge");

		return this;
	}
}