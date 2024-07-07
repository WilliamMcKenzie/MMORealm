extends "res://Scenes/Main/Nexus.gd"

var noise
var chunk_size = 16
var map_size = Vector2(1000,1000)
var tile_cap = 0.5
var environment_caps = Vector3(0.4, 0.3, 0.04)

var map_as_array = []
var map_objects = {}

#Players spawn points
var spawn_points = []
#Enemies spawn points
var enemy_spawn_points = {}

#Enemy variety
var beach_enemies = ["crab"]
var forest_enemies = ["goblin_warrior", "goblin_cannon"]
var plains_enemies = ["troll_warrior", "troll_brute"]
var badlands_enemies = ["troll_warrior", "troll_brute"]
var mountain_enemies = ["rock_golem"]

#Chunks
var chunk_sensor = preload("res://Scenes/SupportScenes/Island/ChunkSensor.tscn")
var chunks = {}

# warning-ignore:unused_argument
var sync_clock_counter = 0

func _physics_process(delta):
	use_chunks = true
	
	for i in range(floor((running_time-last_tick)/tick_rate)):
		for enemy_id in enemy_list.keys():
			var enemy = enemy_list[enemy_id]
			if(enemy["health"] < 1):
				CalculateLootPool(enemy_list[enemy_id])
				var chunk = CalculateChunk(enemy["position"])
				
				if chunks.has(chunk) and chunks[chunk]["E"].has(enemy_id):
					chunks[chunk]["E"].erase(enemy_id)
				
				enemy_list.erase(enemy_id)
				continue
		last_tick = running_time
			
	sync_clock_counter += 1
	if sync_clock_counter ==  60*5:
		sync_clock_counter = 0
		for chunk in chunks:
			for id in chunks[chunk]["E"].keys():
				if enemy_list.has(id) and not WithinChunk(chunk, enemy_list[id]["position"]):
					chunks[chunk]["E"].erase(id)
					AddChunkData(CalculateChunk(enemy_list[id]["position"]), id, false)
				elif not enemy_list.has(id):
					chunks[chunk]["E"].erase(id)
			if IsChunkRadiusEmpty(chunk):
				for id in chunks[chunk]["E"].keys():
					enemy_list.erase(id)
				chunks[chunk]["E"] = {}
func SpawnEnemy(enemy, enemy_id):
	enemy_list[str(enemy_id)] = enemy
	AddChunkData(CalculateChunk(enemy["position"]), enemy_id, false)

#Chunks utility

#Check if chunks around chunk have any players
func IsChunkRadiusEmpty(chunk):
	var is_empty = true
	
	var offsets = [
		Vector2(0, 0),
		Vector2(chunk_size, 0),
		Vector2(chunk_size, chunk_size),
		Vector2(-chunk_size, 0),
		Vector2(-chunk_size, chunk_size),
		Vector2(0, chunk_size),
		Vector2(chunk_size, -chunk_size),
		Vector2(0, -chunk_size),
		Vector2(-chunk_size, -chunk_size)
	]
	
	for offset in offsets:
		if chunks.has(chunk + offset) and chunks[chunk + offset]["P"].size() != 0:
			is_empty = false
			
	return is_empty

#Check if a position is within a chunk Vector2
func WithinChunk(chunk, pos):
	var enemy_coords = Vector2(round((pos/8).x), round((pos/8).y))
	var _chunk = Vector2(chunk_size*round((enemy_coords.x)/chunk_size), chunk_size*round((enemy_coords.y)/chunk_size))
	
	return _chunk == chunk
	
func CalculateChunk(pos):
	var enemy_coords = Vector2(round((pos/8).x), round((pos/8).y))
	var chunk = Vector2(chunk_size*round((enemy_coords.x)/chunk_size), chunk_size*round((enemy_coords.y)/chunk_size))
	
	return chunk

func GetMapSpawnpoint():
	randomize()
	return spawn_points[rand_range(0, spawn_points.size())]
func GetIslandChunk(chunk):
	var result = []
	var objects = []
	for x in range(chunk.x-(chunk_size/2), chunk.x+(chunk_size/2)):
		result.append([])
		for y in range(chunk.y-(chunk_size/2), chunk.y+(chunk_size/2)):
			if map_as_array.size() >= x and map_as_array[x].size() >= y:
				result[result.size()-1].append(map_as_array[x][y])
				if map_objects.has(Vector2(x*8, y*8)):
					objects.append(map_objects[Vector2(x*8, y*8)])
				
				var full_chunk = chunks.has(chunk) and chunks[chunk]["E"].size() > 10
				if enemy_spawn_points.has(Vector2(x,y)) and not full_chunk:
					var instance_tree = get_parent().object_list[name]["instance_tree"].duplicate(true)
					instance_tree.append(name)
					get_node("/root/Server").SpawnNPC(enemy_spawn_points[Vector2(x,y)]["Enemy"], instance_tree, Vector2(x*8, y*8)-self.position)
			else:
				print("x,y: " + str(Vector2(x,y)))
				print("Map as array size:" + str(map_as_array.size()))
				print("Map as array y size:" + str(map_as_array[x].size()))
				print("Map as array value: " + str(map_as_array[x][y]))
	return {
		"Tiles" : result,
		"Objects" : objects
	}
func GetChunkData(chunk):
	var enemies = {}
	var players = {}
	
	if chunks.has(chunk) and (not chunks[chunk].empty()):
		enemies = chunks[chunk]["E"]
		players = chunks[chunk]["P"]
	
	return {
		"E" : enemies,
		"P" : players,
		"O" : object_list
	}

func GenerateIslandMap():
	noise = OpenSimplexNoise.new()
	noise.octaves = 1.0
	noise.period = 12
	PopulateTiles()
func PopulateTiles():
	var center = map_size / 2
	var ocean_distance = center.length() * 1.5
	var beach_distance = center.length() * 1.3
	var forest_distance = center.length() * 1.2
	var plains_distance = center.length() * 1
	var badlands_distance = center.length() * 0.8
	var mountains_distance = center.length() * 0.5
	for x in range(map_size.x):
		map_as_array.append([])
		for y in range(map_size.y):
			map_as_array[x].append([])
			var distance = (Vector2(x, y) - center).length()

			#Base value for a perfect circle
			var ocean_value = 1.0 - (distance / ocean_distance)
			
			#For wavy edges of island
			var noise_scale = 0.6
			var noise_intensity = 0.1
			
			var noise_value = noise.get_noise_2d(x * noise_scale, y * noise_scale) * noise_intensity
			
			var river_value = (1.0 - (distance / 1.5)) + noise_value/3
			
			var beach_value = (1.0 - (distance / beach_distance)) + noise_value/3
			var forest_value = (1.0 - (distance / forest_distance)) + noise_value/3
			var plains_value = (1.0 - (distance / plains_distance)) + noise_value/3 + rand_range(0,0.01)
			var badlands_value = (1.0 - (distance / badlands_distance)) + noise_value + rand_range(0,0.01)
			var mountains_value = (1.0 - (distance / mountains_distance)) + noise_value*2 + rand_range(0,0.01)

			if mountains_value > tile_cap:
				map_as_array[x][y] = 6
			elif badlands_value > tile_cap:
				map_as_array[x][y] = 5
			elif plains_value > tile_cap:
				map_as_array[x][y] = 4
			elif forest_value > tile_cap:
				map_as_array[x][y] = 3
			elif beach_value > tile_cap:
				map_as_array[x][y] = 2
			elif ocean_value > tile_cap:
				map_as_array[x][y] = 1
			else:
				map_as_array[x][y] = 0

func _ready():
	PopulateChunkSensors()
	ArrayToTiles()
	PopulateObstacles()

func PopulateChunkSensors():
	for x in range(0, map_size.x, chunk_size):
		for y in range(0, map_size.y, chunk_size):
			var chunk_sensor_instance = chunk_sensor.instance()
			chunk_sensor_instance.chunk_size = chunk_size
			chunk_sensor_instance.chunk = Vector2(x, y)
			chunk_sensor_instance.position = Vector2(x*8, y*8)
			get_node("ChunkSensors").add_child(chunk_sensor_instance)
func AddChunkData(chunk, id, player):
	var valid_enemy = (enemy_list.has(str(id))) and (player == false)
	var valid_player = (player_list.has(str(id))) and (player == true)
	
	if not valid_enemy and not valid_player:
		return
	
	if chunks.has(chunk) and player == true:
		chunks[chunk]["P"][id] = player_list[str(id)]
	elif chunks.has(chunk):
		chunks[chunk]["E"][id] = enemy_list[str(id)]

	elif player == true:
		chunks[chunk] = {}
		chunks[chunk]["P"] = {}
		chunks[chunk]["E"] = {}
		chunks[chunk]["P"][id] = player_list[str(id)]
	else:
		chunks[chunk] = {}
		chunks[chunk]["P"] = {}
		chunks[chunk]["E"] = {}
		chunks[chunk]["E"][id] = enemy_list[str(id)]
func RemoveChunkData(chunk, id):
	if chunks.has(chunk) and chunks[chunk]["P"].has(id):
		chunks[chunk]["P"].erase(id)
	elif chunks.has(chunk):
		chunks[chunk]["E"].erase(id)

func ArrayToTiles():
	var spawn_point_index = 0
	for x in range(map_size.x):
		for y in range(map_size.y):
# warning-ignore:unused_variable
			var enemy_seed = rand_range(0, 30)
			var map_tile = map_as_array[x][y]
			
			if map_tile == 2:
				spawn_points.append(Vector2(x*8, y*8))

			if map_tile == 2 and enemy_seed > 29.8:
				var enemy_index = round(rand_range(0, beach_enemies.size()-1))
				enemy_spawn_points[Vector2(x, y)] = { "Index": spawn_point_index, "Alive":false, "Enemy": beach_enemies[0]}
				spawn_point_index += 1
			if map_tile == 3 and enemy_seed > 29.8:
				var enemy_index = round(rand_range(0, forest_enemies.size()-1))
				enemy_spawn_points[Vector2(x, y)] = { "Index": spawn_point_index, "Alive":false, "Enemy": forest_enemies[enemy_index]}
				spawn_point_index += 1
			if map_tile == 4 and enemy_seed > 29.8:
				var enemy_index = round(rand_range(0, plains_enemies.size()-1))
				enemy_spawn_points[Vector2(x, y)] = { "Index": spawn_point_index, "Alive":false, "Enemy": plains_enemies[enemy_index]}
				spawn_point_index += 1
			if map_tile == 5 and enemy_seed > 29.8:
				var enemy_index = round(rand_range(0, mountain_enemies.size()-1))
				enemy_spawn_points[Vector2(x, y)] = { "Index": spawn_point_index, "Alive":false, "Enemy": badlands_enemies[enemy_index]}
				spawn_point_index += 1
			if map_tile == 6 and enemy_seed > 29.8:
				var enemy_index = round(rand_range(0, mountain_enemies.size()-1))
				enemy_spawn_points[Vector2(x, y)] = { "Index": spawn_point_index, "Alive":false, "Enemy": mountain_enemies[enemy_index]}
				spawn_point_index += 1
			#For visualizing realms
			#$Tiles.set_cell(x, y, map_as_array[x][y])
func PopulateObstacles():
	for x in range(map_size.x):
		for y in range(map_size.y):
			var map_tile = map_as_array[x][y]
			var obstacle_seed = rand_range(0, 100)
			
			var obstacles = {
				3 : [
					"tree1",
					"shrub1",
					"shrub2",
				],
				4 : [
					"rock4",
					"rock3",
				],
				5 : [
					"shroom1",
					"shroom2",
				],
				6 : [
					"rock1",
					"rock2",
					"twig1",
				]
			}
			var chance = 0.66
			
			if obstacles.has(map_tile):
				var obstacle_list = obstacles[map_tile]
				chance = chance/obstacle_list.size()
				
				var i = 0
				for obstacle in obstacle_list:
					i += 1
					if obstacle_seed < chance*i:
						CreateObstacle(obstacle, get_parent().object_list[name]["instance_tree"], Vector2(x*8, y*8), "Small", name)
						break
	
func CreateObstacle(obstacle_name, instance_tree, obstacle_position, hitbox_size, island_id):
	var obstacle_id = get_node("/root/Server").generate_unique_id()
	var instance_tree_str = get_node("/root/Server").StringifyInstanceTree(instance_tree)+"/"+str(island_id)
	if get_node("/root/Server/Instances/"+instance_tree_str):
		var obstacle = load("res://Scenes/SupportScenes/Obstacles/"+hitbox_size+".tscn").instance()
		obstacle.name = obstacle_id
		obstacle.position = obstacle_position + self.position
		get_node("/root/Server/Instances/"+instance_tree_str+"/YSort/Objects").add_child(obstacle)
		map_objects[obstacle_position] = {"P": obstacle_position, "I": instance_tree, "N":obstacle_name, "Type":"Obstacles"}
