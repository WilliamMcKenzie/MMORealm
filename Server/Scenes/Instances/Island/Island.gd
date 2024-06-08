extends Node2D

#Map generation
var noise
var map_size = Vector2(1000,1000)

var chunk_size = 64
var tile_cap = 0.5
var environment_caps = Vector3(0.4, 0.3, 0.04)

var map_as_array = []
var map_objects = {}

#Players spawn points
var spawn_points = []
#Enemies spawn points
var enemy_spawn_points = {}
var enemy_list = {}

#Chunks
var chunk_sensor = preload("res://Scenes/Instances/Island/ChunkSensor.tscn")
var chunks = {}

var arrow_projectile = preload("res://Scenes/Instances/Projectiles/ServerArrow.tscn")
var enemy_8x8 = preload("res://Scenes/Instances/Enemies/Enemy_8x8.tscn")

func GenerateIslandMap():
	noise = OpenSimplexNoise.new()
	noise.octaves = 1.0
	noise.period = 12
	PopulateChunkSensors()
	PopulateTiles()

func PopulateChunkSensors():
	for x in range(0, map_size.x, chunk_size):
		for y in range(0, map_size.y, chunk_size):
			var chunk_sensor_instance = chunk_sensor.instance()
			chunk_sensor_instance.chunk_size = chunk_size
			chunk_sensor_instance.chunk = Vector2(x, y)
			chunk_sensor_instance.position = Vector2(x*8, y*8)
			get_node("ChunkSensors").add_child(chunk_sensor_instance)
func AddChunkData(chunk, id):
	if chunks.has(chunk):
		chunks[chunk][id] = enemy_list[id]
	else:
		chunks[chunks] = {}
		chunks[chunks][id] = enemy_list[id]
func RemoveChunkData(chunk, id):
	if chunks.has(chunk) and chunks[chunk].has(id):
		chunks[chunk].erase(id)

func PopulateTiles():
	var center = map_size / 2
	var ocean_distance = center.length() * 1.3
	var beach_distance = center.length() * 1
	var forest_distance = center.length() * 0.9
	var plains_distance = center.length() * 0.6
	var mountains_distance = center.length() * 0.4
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
			
			var beach_value = (1.0 - (distance / beach_distance)) + noise_value
			var forest_value = (1.0 - (distance / forest_distance)) + noise_value
			var plains_value = (1.0 - (distance / plains_distance)) + noise_value
			var mountains_value = (1.0 - (distance / mountains_distance)) + noise_value

			if mountains_value > tile_cap:
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
	ArrayToTiles()
	PopulateObstacles()
func ArrayToTiles():
	var spawn_point_index = 0
	for x in range(map_size.x):
		for y in range(map_size.y):
			var enemy_seed = rand_range(0, 30)
			var map_tile = map_as_array[x][y]
			
			if map_tile == 2:
				spawn_points.append(Vector2(x*8, y*8))
			
			#Enemy spawning
			if map_tile == 2 and enemy_seed > 29.8:
				enemy_spawn_points[Vector2(x, y)] = { "Index": spawn_point_index, "Alive":false, "Enemy": "snake"}

			#elif map_tile == 4 and enemy_seed > 29.8:
				#get_node("/root/Server").SpawnNPC(plains_npcs[0], get_node("/root/Server").objects_state_collection[name]["I"], Vector2(x*8, y*8))
			#For visualizing realms
			#$Tiles.set_cell(x, y, map_as_array[x][y])
func PopulateObstacles():
	for x in range(map_size.x):
		for y in range(map_size.y):
			var map_tile = map_as_array[x][y]
			var obstacle_seed = rand_range(0, 30)
			
			if map_tile <= 2:
				pass
			elif map_tile == 3 and obstacle_seed > 29.9:
				CreateObstacle("tree", get_node("/root/Server").objects_state_collection[name]["I"], Vector2(x*8, y*8), "small", name)
			elif map_tile == 3 and obstacle_seed > 29.8:
				CreateObstacle("red_shroom1", get_node("/root/Server").objects_state_collection[name]["I"], Vector2(x*8, y*8), "small", name)
			elif map_tile == 3 and obstacle_seed < 0.1:
				CreateObstacle("red_shroom2", get_node("/root/Server").objects_state_collection[name]["I"], Vector2(x*8, y*8), "small", name)
			elif map_tile == 4 and obstacle_seed > 29.8:
				CreateObstacle("twig", get_node("/root/Server").objects_state_collection[name]["I"], Vector2(x*8, y*8), "small", name)
			elif map_tile == 5 and obstacle_seed > 29.9:
				CreateObstacle("rock1", get_node("/root/Server").objects_state_collection[name]["I"], Vector2(x*8, y*8), "small", name)
			elif map_tile == 5 and obstacle_seed > 29.8:
				CreateObstacle("rock2", get_node("/root/Server").objects_state_collection[name]["I"], Vector2(x*8, y*8), "small", name)

func CreateObstacle(obstacle_name, instance_tree, obstacle_position, hitbox_size, island_id):
	var obstacle_id = get_node("/root/Server").generate_unique_id()
	var instance_tree_str = get_node("/root/Server").StringifyInstanceTree(instance_tree)+"/"+str(island_id)
	if get_node("/root/Server/Instances/"+instance_tree_str):
		var obstacle = load("res://Scenes/Instances/Obstacles/"+hitbox_size+".tscn").instance()
		obstacle.name = obstacle_id
		obstacle.position = obstacle_position
		get_node("/root/Server/Instances/"+instance_tree_str+"/YSort/Objects").add_child(obstacle)
		map_objects[obstacle_position] = {"P": obstacle_position, "I": instance_tree, "N":obstacle_name, "Type":"Obstacles"}

#Enemies
func SpawnEnemy(enemy_id, position, hitbox_type):
	var new_enemy = enemy_8x8.instance()
	new_enemy.position = position
	new_enemy.name = enemy_id
	get_node("YSort/Enemies/").add_child(new_enemy, true)

func SpawnProjectile(projectile_data, player_id):
	var projectile_instance = arrow_projectile.instance()
	projectile_instance.player_id = player_id
	projectile_instance.projectile_name = projectile_data["Projectile"]
	projectile_instance.position = projectile_data["Position"]
	projectile_instance.tile_range = projectile_data["TileRange"]
	projectile_instance.SetDirection(projectile_data["Direction"])
	projectile_instance.look_at(projectile_data["MousePosition"])
	
	var data = ServerData.GetProjectileData(projectile_data["Projectile"])
	projectile_instance.SetData(data)
	
	add_child(projectile_instance)

func GetMapSpawnpoint():
	randomize()
	return spawn_points[rand_range(0, spawn_points.size())]
func GetChunk(chunk):
	var tiles = []
	var objects = []
	
	for x in range(chunk.x-(chunk_size/2), chunk.x+(chunk_size/2)):
		tiles.append([])
		for y in range(chunk.y-(chunk_size/2), chunk.y+(chunk_size/2)):
			tiles[tiles.size()-1].append(map_as_array[x][y])
			if map_objects.has(Vector2(x*8, y*8)):
				objects.append(map_objects[Vector2(x*8, y*8)])
			if enemy_spawn_points.has(Vector2(x,y)) and enemy_spawn_points[Vector2(x,y)]["Alive"] == false:
				var instance_tree = get_node("/root/Server").objects_state_collection[name]["I"].duplicate(true)
				instance_tree.append(name)
				get_node("/root/Server").SpawnNPC(enemy_spawn_points[Vector2(x,y)]["Enemy"], instance_tree, Vector2(x*8, y*8))
	return {
		"Tiles" : tiles,
		"Objects" : objects
	}
func GetChunkData(chunk):
	var enemies = {}
	
	if chunks.has(chunk) and (not chunks[chunk].empty()):
		enemies = chunks[chunk]
	
	return {
		"Enemies" : enemies
	}
