extends Node2D

var noise
var map_size = Vector2(1000,1000)
var tile_cap = 0.5
var road_caps = Vector2(0.05, 0.02)
var environment_caps = Vector3(0.4, 0.3, 0.04)

var map_as_array = []
var map_objects = {}

#Players spawn points
var spawn_points = []

#Enemies spawn points
var beach_spawn_points = []
var forest_spawn_points = []
var plains_spawn_points = []
var mountains_spawn_points = []

var beach_npcs = ["snake"]
var forest_npcs = ["snake"]
var plains_npcs = ["snake"]
var mountains_npcs = ["snake"]

var enemy_list = {}

var arrow_projectile = preload("res://Scenes/Instances/Projectiles/ServerArrow.tscn")
var enemy_8x8 = preload("res://Scenes/Instances/Enemies/Enemy_8x8.tscn")

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
func SpawnEnemy(enemy_id, position, hitbox_type):
	var new_enemy = enemy_8x8.instance()
	new_enemy.position = position
	new_enemy.name = enemy_id
	get_node("YSort/Enemies/").add_child(new_enemy, true)

func _physics_process(delta):
	for enemy_id in enemy_list.keys():
		if(enemy_list[enemy_id]["Health"] < 1):
			enemy_list.erase(enemy_id)
			get_node("/root/Server").enemies_state_collection.erase(enemy_id)

func GetMapSpawnpoint():
	randomize()
	return spawn_points[rand_range(0, spawn_points.size())]
func GetIslandChunk(chunk):
	var result = []
	var objects = []
	for x in range(chunk.x-32, chunk.x+32):
		result.append([])
		for y in range(chunk.y-32, chunk.y+32):
			result[result.size()-1].append(map_as_array[x][y])
			if map_objects.has(Vector2(x*8, y*8)):
				objects.append(map_objects[Vector2(x*8, y*8)])
	return {
		"Tiles" : result,
		"Objects" : objects
	}

func GenerateIslandMap():
	noise = OpenSimplexNoise.new()
	noise.octaves = 1.0
	noise.period = 12
	PopulateTiles()
func _ready():
	ArrayToTiles()
	PopulateObstacles()
func ArrayToTiles():
	for x in range(map_size.x):
		for y in range(map_size.y):
			var enemy_seed = rand_range(0, 30)
			var map_tile = map_as_array[x][y]
			
			if map_tile == 2:
				spawn_points.append(Vector2(x*8, y*8))
			
			#Enemy spawning
			if map_tile == 2 and enemy_seed > 29.8:
				get_node("/root/Server").SpawnNPC(beach_npcs[0], get_node("/root/Server").objects_state_collection[name]["I"], Vector2(x*8, y*8))
			elif map_tile == 3 and enemy_seed > 29.8:
				get_node("/root/Server").SpawnNPC(forest_npcs[0], get_node("/root/Server").objects_state_collection[name]["I"], Vector2(x*8, y*8))
			elif map_tile == 4 and enemy_seed > 29.8:
				get_node("/root/Server").SpawnNPC(plains_npcs[0], get_node("/root/Server").objects_state_collection[name]["I"], Vector2(x*8, y*8))
			#For visualizing realms
			#$Tiles.set_cell(x, y, map_as_array[x][y])
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
