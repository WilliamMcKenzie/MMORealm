extends Node

func GetClosestPlayer(pos, root):
	var player_list = root.player_list
	var closest = 9999999
	var closest_position
	for player_id in player_list.keys():
		if player_list[player_id]["position"].distance_to(pos) <= closest:
			closest = player_list[player_id]["position"].distance_to(pos)
			closest_position = player_list[player_id]["position"]
	if closest > 16*8:
		return false
	return closest_position

func DegreesToVector(degrees):
	var radians = deg2rad(degrees)
	var vector = Vector2(cos(radians), sin(radians))
	return vector
func DetermineCollisionSafePoint(pos, point, root, enemy_type):
	var space_state = root.get_world_2d().direct_space_state
	var result = true
	var enemy_data = ServerData.GetEnemy(enemy_type)
	var dimensions = Vector2(enemy_data.res, enemy_data.height)
	
	var spots_to_check = [Vector2(0,-dimensions.y/2), Vector2(-dimensions.x/2,0), Vector2(dimensions.x/2,0), Vector2(-dimensions.x/2,-dimensions.y), Vector2(dimensions.x/2,-dimensions.y)]
	for spot in spots_to_check:
		var collisions = space_state.intersect_point(point+root.position+spot, 1, [], 1, true, true)
		if collisions.size() > 0:
			for collision in collisions:
				if collision.collider.name == "TileMap":
					result = false
	
	return result

#Stationary
func Stationary(enemy, tick_rate, root):
	return enemy

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
			var point = pos + Vector2(rand_range(-7,7),rand_range(-7,7))
			if DetermineCollisionSafePoint(pos, point, root, enemy["name"]):
				enemy["target"] = point
	return enemy

#Chase
func Chase(enemy, tick_rate, root):
	var pos = enemy["position"]
	var speed = enemy["speed"]
	
	var closest_position = GetClosestPlayer(pos, root)
	if not closest_position:
		return enemy
	
	var x_move = -cos(pos.angle_to_point(closest_position))*(0.1/tick_rate)*(speed/10.0)
	var y_move = -sin(pos.angle_to_point(closest_position))*(0.1/tick_rate)*(speed/10.0)
	
	enemy["target"] = closest_position
	var point1 = enemy["position"] + Vector2(x_move,y_move)
	var point2 = enemy["position"] + Vector2(0,y_move)
	var point3 = enemy["position"] + Vector2(x_move,0)
	if DetermineCollisionSafePoint(pos, point1, root, enemy["name"]):
		enemy["position"] = point1
	elif DetermineCollisionSafePoint(pos, point2, root, enemy["name"]):
		enemy["position"] = point2
	elif DetermineCollisionSafePoint(pos, point3, root, enemy["name"]):
		enemy["position"] = point3
	
	return enemy
