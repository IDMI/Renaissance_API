/**
config/autoViolation/AutoViolationService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Auto violation service
@output false
**/
component
	extends="coldbox.system.orm.hibernate.VirtualEntityService"
	accessors="true"
	singleton
{
	property name="autoViolationChargeService" inject="model";

	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint constructor
    @output false
    **/
	public model.config.autoViolation.AutoViolationService function init() {
		super.init(entityName="AutoViolation");

		return this;
	}

	public any function list(
		struct criteria=structnew(),
  		string sortOrder="",
  		numeric offset=0,
  		numeric max=0,
  		numeric timeout=0,
  		boolean ignoreCase=false,
  		boolean asQuery=getDefaultAsQuery())
	{
		var c = newCriteria();

		return c.list(sortOrder=sortOrder, offset=offset, max=max, timeout=timeout, ignoreCase=ignoreCase, asQuery=asQuery);
	}
}