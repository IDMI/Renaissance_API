/*
model/VehicleSurcharge.cfc
@author Peruz Carlsen
@createdate 20111004
@description VehicleSurcharge entity
*/
component
	persistent="true"
	table="PolicySurcharges"
	extends="Surcharge"
	discriminatorvalue="Vehicle"
	output="false"
{
	// relations
	property name="parent" fieldtype="many-to-one" fkcolumn="parentID" joincolumn="vehicleID" cfc="model.vehicle.Vehicle" lazy="true" inverse="true";
}