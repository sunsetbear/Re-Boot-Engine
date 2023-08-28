/// @description Initialize
event_inherited();

itemName = "spinBoost";
itemID = 0;

itemHeader = "SPIN BOOST";
itemDesc = "Jump in midair.";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasBoots[Boots.SpinBoost] = true;
		obj_Player.boots[Boots.SpinBoost] = true;
	}
}