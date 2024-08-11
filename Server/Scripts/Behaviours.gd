extends Node

func DetermineCollisionSafePoint(pos, point, root):
	var space_state = root.get_world_2d().direct_space_state
	var result = true
	var spots_to_check = [Vector2(-4,0), Vector2(4,0), Vector2(-4,-8), Vector2(4,-8)]
	for spot in spots_to_check:
		var collisions = space_state.intersect_point(point+root.position+spot, 1, [], 1, true, true)
		if collisions.size() > 0:
			for collision in collisions:
				if collision.collider.name == "TileMap":
					result = false
	
	if result:
		return point
	return pos

#Wander
func Wander(enemy, tick_rate, root):
	var target = enemy["target"]
	var pos = enemy["position"]
	var speed = enemy["speed"]
	
	var x_move = -cos(pos.angle_to_point(target))*(0.1/tick_rate)*(speed/10.0)
	var y_move = -sin(pos.angle_to_point(target))*(0.1/tick_rate)*(speed/10.0)
	
	enemy["position"] += Vector2(x_move,y_move)
	
	if (target - pos).length() <= 4:
		if (enemy["anchor_position"]-pos).length() >= 20:
			enemy["target"] = enemy["anchor_position"]
		else:
			enemy["target"] = DetermineCollisionSafePoint(pos, pos + Vector2(rand_range(-7,7),rand_range(-7,7)), root)
	return enemy

#Chase
func Chase(enemy, tick_rate, root):
	var player_list = root.player_list
	var target = enemy["target"]
	var pos = enemy["position"]
	var speed = enemy["speed"]
	
	var closest = 9999999
	for player_id in player_list.keys():
		if player_list[player_id]["position"].distance_to(enemy["position"]) <= closest:
			target = player_list[player_id]["position"]
	
	var x_move = -cos(pos.angle_to_point(target))*(0.1/tick_rate)*(speed/10.0)
	var y_move = -sin(pos.angle_to_point(target))*(0.1/tick_rate)*(speed/10.0)
	
	enemy["position"] += Vector2(x_move,y_move)
	return enemy

