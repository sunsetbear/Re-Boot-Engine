/// @description Initialize
event_inherited();

itemName = "longBeam";
itemID = 0;

itemHeader = "LONG BEAM";
itemDesc = "Your beam range is extended.";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasBeam[Beam.Long] = true;
		obj_Player.beam[Beam.Long] = true;
	}
}