/// @description 

lhc_inherit_interface("IMovingSolid");

canGrip = true;

entityList = ds_list_create();

ignoredEntity = noone;

function UpdatePosition(_x,_y)
{
	// round x and y just in case
	x = scr_round(x);
	y = scr_round(y);
	
	var newPosX = scr_round(_x),
		newPosY = scr_round(_y);
	
	var bVelX = newPosX-x,
		bVelY = newPosY-y;
	
	//isSolid = false;
	asset_remove_tags(obj_MovingTile,"IMovingSolid",asset_object);
	asset_remove_tags(obj_MovingSlope,"IMovingSolid",asset_object);
	asset_remove_tags(obj_MovingSlope_4th,"IMovingSolid",asset_object);
	
	var tNumX = 0,
		tNumY = -1,
		bNumX = 0,
		bNumY = 1,
		lNumX = -1,
		lNumY = 0,
		rNumX = 1,
		rNumY = 0;
	if(object_index == obj_MovingSlope || object_is_ancestor(object_index,obj_MovingSlope))
	{
		if(image_yscale > 0)
		{
			tNumX = sign(image_xscale);
		}
		else
		{
			bNumX = sign(image_xscale);
		}
		if(image_xscale > 0)
		{
			rNumY = -sign(image_yscale);
		}
		else
		{
			lNumY = -sign(image_yscale);
		}
	}
	
	var num = instance_place_list(newPosX,newPosY,obj_Entity,entityList,false);
		num += instance_place_list(x+tNumX,y+tNumY,obj_Entity,entityList,false);
		num += instance_place_list(x+bNumX,y+bNumY,obj_Entity,entityList,false);
		num += instance_place_list(x+lNumX,y+lNumY,obj_Entity,entityList,false);
		num += instance_place_list(x+rNumX,y+lNumY,obj_Entity,entityList,false);
	for(var i = 0; i < num; i++)
	{
		if(instance_exists(entityList[| i]) && array_contains(entityList[| i].solids,"IMovingSolid") && entityList[| i] != ignoredEntity)
		{
			var entity = entityList[| i];
			var tileCollide = true;
			if(object_is_ancestor(entity,obj_NPC))
			{
				tileCollide = entity.tileCollide;
			}
			if(object_is_ancestor(entity,obj_Projectile))
			{
				tileCollide = false;
			}
			if(entity.object_index == obj_Player && entity.passthroughMovingSolids)
			{
				tileCollide = false;
			}
			if(tileCollide)
			{
				var moveX = 0,
					moveY = 0;
				var moveXFlag = false,
					moveYFlag = false;
				
				if(place_meeting(newPosX,y,entity) || (place_meeting(newPosX,newPosY,entity) && !place_meeting(x,y+sign(bVelY),entity)))
				{
					moveXFlag = true;
				}
				if(place_meeting(x,newPosY,entity) || (place_meeting(newPosX,newPosY,entity) && !place_meeting(x+sign(bVelX),y,entity)))
				{
					moveYFlag = true;
				}
				
				var edgeTop = place_meeting(x+tNumX*2,y+tNumY*2,entity),
					edgeBottom = place_meeting(x+bNumX*2,y+bNumY*2,entity),
					edgeLeft = place_meeting(x+lNumX*2,y+lNumY*2,entity),
					edgeRight = place_meeting(x+rNumX*2,y+rNumY*2,entity);
				var entityEdgeBottom = (entity.colEdge == Edge.Bottom),
					entityEdgeTop = (entity.colEdge == Edge.Top),
					entityEdgeRight = (entity.colEdge == Edge.Right),
					entityEdgeLeft = (entity.colEdge == Edge.Left);
				if(entity.object_index == obj_Player)
				{
					entityEdgeBottom = (entity.colEdge == Edge.Bottom);
					entityEdgeTop = (entity.colEdge == Edge.Top);
					entityEdgeRight = (entity.colEdge == Edge.Right || (entity.state == State.Grip && entity.dir == 1));
					entityEdgeLeft = (entity.colEdge == Edge.Left || (entity.state == State.Grip && entity.dir == -1));
					
					if(entity.spiderBall)
					{
						moveXFlag = true;
						moveYFlag = true;
					}
				}
				if(object_is_ancestor(entity.object_index,obj_NPC_Crawler))
				{
					moveXFlag = true;
					moveYFlag = true;
				}
				if ((edgeTop && entityEdgeBottom) ||
					(edgeBottom && entityEdgeTop) ||
					(edgeLeft && (entityEdgeRight || bVelX < 0)) || 
					(edgeRight && (entityEdgeLeft || bVelX > 0)))
				{
					moveXFlag = true;
				}
				if ((edgeTop && (entityEdgeBottom || bVelY < 0)) || 
					(edgeBottom && (entityEdgeTop || bVelY > 0)) ||
					(edgeLeft && entityEdgeRight) || 
					(edgeRight && entityEdgeLeft))
				{
					moveYFlag = true;
				}
				
				if(moveXFlag)
				{
					moveX = bVelX;
				}
				if(moveYFlag)
				{
					moveY = bVelY;
				}
				
				with(entity)
				{
					if(moveXFlag)
					{
						moveX -= shiftedVelX;
					}
					if(moveYFlag)
					{
						moveY -= shiftedVelY;
					}
					var tempShiftX = shiftedVelX,
						tempShiftY = shiftedVelY;
					Collision_Basic(moveX,moveY,15,15,5,5,5,5);
					if(moveXFlag)
					{
						shiftedVelX = x-xprevious;
					}
					else
					{
						shiftedVelX = tempShiftX;
					}
					if(moveYFlag)
					{
						shiftedVelY = y-yprevious;
					}
					else
					{
						shiftedVelY = tempShiftY;
					}
				}
			}
		}
	}
	ds_list_clear(entityList);
	
	x = newPosX;
	y = newPosY;
	
	//isSolid = true;
	asset_add_tags(obj_MovingTile,"IMovingSolid",asset_object);
	asset_add_tags(obj_MovingSlope,"IMovingSolid",asset_object);
	asset_add_tags(obj_MovingSlope_4th,"IMovingSolid",asset_object);
}
