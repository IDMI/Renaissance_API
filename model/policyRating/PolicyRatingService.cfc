/**
policyRating/PolicyRatingService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Policy rating service
@output false
**/
component
	accessors="true"
	singleton
{
	property name="entityService" inject="EntityService";

	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint Constructor
    @output false
    **/
    public model.policyRating.PolicyRatingService function init() {
    	return this;
    }

    /**
    @author Peruz Carlsen
    @createdate 20120307
    @hint Rates the incoming policy
    @output false
    **/
	public struct function execute(required model.policy.Policy policy, required numeric ratingType, numeric updateData = 1, numeric forceLogEntry = 1) {
		var result = {
			"policyID" = arguments.policy.getPolicyID(),
			"before" = {
				"premiumTotal" = arguments.policy.getPremiumTotal(),
				"termPremiumsDue" = arguments.policy.getTermPremiumsDue()
			},
			"after" = {
				"premiumTotal" = -1,
				"termPremiumsDue" = -1
			}
		};

		var rateProc = new storedproc(procedure="PolicyRating");
		rateProc.addParam(cfsqltype="cf_sql_integer", type="in", value=arguments.policy.getPolicyID());
		rateProc.addParam(cfsqltype="cf_sql_tinyint", type="in", value=arguments.ratingType);
		rateProc.addParam(cfsqltype="cf_sql_tinyint", type="in", value=arguments.updateData);
		rateProc.addParam(cfsqltype="cf_sql_tinyint", type="in", value=arguments.forceLogEntry);
		rateProc.execute();

		getEntityService().refresh(arguments.policy);
		result.after.premiumTotal = arguments.policy.getPremiumTotal();
		result.after.termPremiumsDue = arguments.policy.getTermPremiumsDue();

		return result;
	}
}