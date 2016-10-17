/**
companyFinancial/CompanyFinancialService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Company financial service
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
	public model.companyFinancial.CompanyFinancialService function init() {
		super.init(entityName="CompanyFinancial");

		return this;
	}
}