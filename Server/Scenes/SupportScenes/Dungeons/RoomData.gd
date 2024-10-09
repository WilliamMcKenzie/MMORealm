extends Node2D

var encounter = false
var room_data = {}

func _ready():
	if room_data.has("start_room") and room_data.has("target_room"):
		HallwaySetup()
	else:
		SpawnEnemies()
		
func SpawnEnemies():
	var instance_node = get_parent().get_parent()
	var tile_translation = instance_node.tile_translation
	var room_size = instance_node.room_size
	
	for x in range(-room_size, room_size):
		for y in range(-room_size, room_size):
			var current_tile = $TileMap.get_cell(x,y)
			var current_position = position + Vector2(x*8, y*8) - instance_node.position + Vector2(4,4)
			
			if tile_translation.has(current_tile):
				if ServerData.GetEnemy(tile_translation[current_tile]):
					var enemy_name = tile_translation[current_tile]
					if not tile_translation[current_tile] is String:
						enemy_name = tile_translation[randi() % len(tile_translation)]
					get_node("/root/Server").SpawnNPC(enemy_name, instance_node.instance_tree, current_position-Vector2(4,0))
				else:
					var obstacle_name = tile_translation[current_tile]
					if not tile_translation[current_tile] is String:
						obstacle_name = tile_translation[current_tile][randi() % len(tile_translation[current_tile])]
					CreateObstacle(obstacle_name, instance_node.instance_tree, current_position, load("res://Scenes/SupportScenes/Obstacles/Small.tscn").instance(), instance_node.name)
	
func CreateObstacle(obstacle_name, instance_tree, obstacle_position, obstacle, island_id):
	var instance_node = get_parent().get_parent()
	var obstacle_id = get_node("/root/Server").generate_unique_id()
	var instance_tree_str = get_node("/root/Server").StringifyInstanceTree(instance_tree)
	if get_node("/root/Server/Instances/"+instance_tree_str):
		obstacle.name = obstacle_id
		obstacle.position = obstacle_position + instance_node.position - Vector2(-4,-8)
		
		get_node("/root/Server/Instances/"+instance_tree_str+"/YSort/Objects").add_child(obstacle)
		instance_node.object_list[obstacle_id] = {
			"name": obstacle_name,
			"type": "Obstacles",
			"end_time": OS.get_system_time_msecs()+OS.get_system_time_msecs(),
			"position": obstacle_position + instance_node.position - Vector2(-4,-8),
			"instance_tree": instance_tree
		}

func HallwaySetup():
	var instance_node = get_parent().get_parent()
	var start_room = get_parent().get_node(str(room_data.start_room))
	var target_room = get_parent().get_node(str(room_data.target_room))
	var direction = room_data.target_room - room_data.start_room
	
	var tiles = []
	var room_size = instance_node.room_size
	var target_coordinates = direction*Vector2(room_size,room_size)
	
	for x in range(-room_size*2, room_size*2):
		for y in range(-room_size*2, room_size*2):
			if $TileMap.get_cell(x,y) > -1:
				tiles.append(Vector2(x, y))
	
	for tile in tiles:
		start_room.get_node("TileMap").set_cell(tile.x,tile.y,-1)
		target_room.get_node("TileMap").set_cell(tile.x-target_coordinates.x,tile.y-target_coordinates.y,-1)
