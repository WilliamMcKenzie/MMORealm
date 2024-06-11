extends Node2D

var player_list = {}
var enemy_list = {}
var object_list = {}

var noise

var chunk_size = 32
var map_size = Vector2(1000,1000)

var tile_cap = 0.5
var environment_caps = Vector3(0.4, 0.3, 0.04)

var map_as_array = []
var map_objects = {}

#Players spawn points
var spawn_points = []
#Enemies spawn points
var enemy_spawn_points = {}

var beach_enemies = ["crab", "snake"]
var forest_enemies = ["snake"]
var plains_enemies = ["tribesman"]
var mountain_enemies = ["shaman"]

#Chunks
var chunk_sensor = preload("res://Scenes/Instances/Island/ChunkSensor.tscn")
var chunks = {}

var player_projectiles = {
	"arrow" : preload("res://Scenes/Instances/Projectiles/Players/Arrow.tscn")	
}
var enemy_projectiles = {
	"arrow" : preload("res://Scenes/Instances/Projectiles/Enemies/Arrow.tscn")
}

var enemy_8x8 = preload("res://Scenes/Instances/Enemies/Enemy_8x8.tscn")

# warning-ignore:unused_argument
var sync_clock_counter = 0
func _physics_process(delta):
	for enemy_id in enemy_list.keys():
		if(enemy_list[enemy_id]["Health"] < 1):
			var enemy_position = enemy_list[enemy_id]["Position"]
			var enemy_coords = Vector2(round((enemy_position/8).x), round((enemy_position/8).y))
			var chunk = Vector2(chunk_size*round((enemy_coords.x)/chunk_size), chunk_size*round((enemy_coords.y)/chunk_size))
			
			if chunks.has(chunk) and chunks[chunk]["E"].has(enemy_id):
				chunks[chunk]["E"].erase(enemy_id)
			
			enemy_list.erase(enemy_id)
			
	sync_clock_counter += 1
	if sync_clock_counter ==  60*5:
		sync_clock_counter = 0
		for chunk in chunks:
			if IsChunkRadiusEmpty(chunk):
				for id in chunks[chunk]["E"].keys():
					enemy_list.erase(id)
					get_node("YSort/Enemies/").remove_child(get_node("YSort/Enemies/"+str(id)))
				chunks[chunk]["E"] = {}
#Check if chunks around chunk have any players
func IsChunkRadiusEmpty(chunk):
	var is_empty = true
	
	var chunk_size = 32
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

func UpdatePlayer(player_id, player_state):
	if player_list.has(str(player_id)):
		player_list[str(player_id)]["Position"] = player_state["P"]
		player_list[str(player_id)]["Animation"] = player_state["A"]
		get_node("YSort/Players/"+str(player_id)).position = player_list[str(player_id)]["Position"]+position
func SpawnPlayer(player_container):
	player_list[player_container.name] = {
			"Name": player_container.name,
			"Position": player_container.position,
			"Animation": { "A" : "Idle", "C" : Vector2.ZERO }
		}
	player_container.position += position
	get_node("YSort/Players").add_child(player_container)
func RemovePlayer(player_container):
	player_list.erase(player_container.name)
	var player_container_node = get_node("YSort/Players").remove_child(player_container)

func SpawnPlayerProjectile(projectile_data, player_id):
	var projectile_instance = player_projectiles["arrow"].instance()
	projectile_instance.player_id = player_id
	projectile_instance.e_name =projectile_nameprojectile_data["Projectile"]
	projectile_instance.pos"res://"ition = projectile_data["Position"] + position
	projectile_instance.tile_range = projectile_data["TileRange"]
	projectile_instance.SetDirection(projectile_data["Direction"])
	projectile_instance.look_at(projectile_data["MousePosition"])
	print(projectile_data["MousePosition"])
	
	var data = ServerData.GetProjectileData(projectile_data["Projectile"])
	projectile_instance.SetData(data)
	
	add_child(projectile_instance)
func SpawnEnemyProjectile(projectile_data, enemy_id):
	var projectile_instance = enemy_projectiles["arrow"].instance()
	projectile_instance.enemy_id = enemy_id
	projectile_instance.projectile_name = projectile_data["Projectile"]
	projectile_instance.position = projectile_data["Position"]
	projectile_instance.tile_range = projectile_data["TileRange"]
	projectile_instance.SetDirection(projectile_data["Direction"])
	projectile_instance.look_at(projectile_data["TargetPosition"])
	
	var data = ServerData.GetProjectileData(projectile_data["Projectile"])
	projectile_instance.SetData(data)
	
	var instance_tree = get_parent().object_list[name]["InstanceTree"].duplicate(true)
	instance_tree.append(name)
	get_node("/root/Server").SendEnemyProjectile(projectile_data, instance_tree, enemy_id, position)
	
	add_child(projectile_instance)

func SpawnEnemy(enemy, enemy_id):
	var new_enemy = enemy_8x8.instance()
	enemy_list[str(enemy_id)] = enemy
	new_enemy.position = enemy["Position"] + position
	new_enemy.name = enemy_id
	new_enemy.set_script(load("res://Scenes/Instances/Enemies/Behavior/"+enemy["Behavior"]+".gd"))
	get_node("YSort/Enemies/").add_child(new_enemy, true)
	
func OpenPortal(portal_name, instance_tree, position):
	var instance_id = get_node("/root/Server").generate_unique_id()
	if portal_name == "island":
		instance_id = "island " + get_node("/root/Server").generate_unique_id()
		var island_instance = load("res://Scenes/Instances/Island/Island.tscn").instance()
		island_instance.name = instance_id
		
		object_list[instance_id] = {
			"Name":"island",
			"Type":"DungeonPortals",
			"EndTime": OS.get_system_time_msecs()+99999999999999,
			"Position": position,
			"InstanceTree": instance_tree
		}
		
		island_instance.GenerateIslandMap()
		island_instance.position = Instances.GetFreeInstancePosition()
		add_child(island_instance)
		Instances.AddInstanceToTracker(instance_tree, instance_id)
	else:
		var instance_map = Dungeons.GenerateDungeon(portal_name)
		var dungeon_instance = load("res://Scenes/Instances/Dungeons/Dungeon.tscn").instance()
		dungeon_instance.name = instance_id
		dungeon_instance.map = instance_map
		dungeon_instance.position = Instances.GetFreeInstancePosition()
		
		object_list[instance_id] = {
			"Name":portal_name,
			"Type":"DungeonPortals",
			"EndTime": OS.get_system_time_msecs()+10000,
			"Position": position,
			"InstanceTree": instance_tree
		}
		
		add_child(dungeon_instance)
		Instances.AddInstanceToTracker(instance_tree, instance_id)

func GetMapSpawnpoint():
	randomize()
	return spawn_points[rand_range(0, spawn_points.size())]
func GetIslandChunk(chunk):
	var result = []
	var objects = []
	for x in range(chunk.x-(chunk_size/2), chunk.x+(chunk_size/2)):
		result.append([])
		for y in range(chunk.y-(chunk_size/2), chunk.y+(chunk_size/2)):
			result[result.size()-1].append(map_as_array[x][y])
			if map_objects.has(Vector2(x*8, y*8)):
				objects.append(map_objects[Vector2(x*8, y*8)])
			
			var full_chunk = chunks.has(chunk) and chunks[chunk]["E"].size() > 10
			if enemy_spawn_points.has(Vector2(x,y)) and not full_chunk:
				var instance_tree = get_parent().object_list[name]["InstanceTree"].duplicate(true)
				instance_tree.append(name)
				get_node("/root/Server").SpawnNPC(enemy_spawn_points[Vector2(x,y)]["Enemy"], instance_tree, Vector2(x*8, y*8))
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
				var enemy_index = randi() % beach_enemies.size()-1
				enemy_spawn_points[Vector2(x, y)] = { "Index": spawn_point_index, "Alive":false, "Enemy": beach_enemies[0]}
				spawn_point_index += 1
			if map_tile == 3 and enemy_seed > 29.8:
				var enemy_index = randi() % forest_enemies.size()-1
				enemy_spawn_points[Vector2(x, y)] = { "Index": spawn_point_index, "Alive":false, "Enemy": forest_enemies[enemy_index]}
				spawn_point_index += 1
			if map_tile == 4 and enemy_seed > 29.8:
				var enemy_index = randi() % plains_enemies.size()-1
				enemy_spawn_points[Vector2(x, y)] = { "Index": spawn_point_index, "Alive":false, "Enemy": plains_enemies[enemy_index]}
				spawn_point_index += 1
			if map_tile == 5 and enemy_seed > 29.8:
				var enemy_index = randi() % mountain_enemies.size()-1
				enemy_spawn_points[Vector2(x, y)] = { "Index": spawn_point_index, "Alive":false, "Enemy": mountain_enemies[enemy_index]}
				spawn_point_index += 1
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
				CreateObstacle("tree", get_parent().object_list[name]["InstanceTree"], Vector2(x*8, y*8), "Small", name)
			elif map_tile == 4 and obstacle_seed > 29.8:
				CreateObstacle("twig", get_parent().object_list[name]["InstanceTree"], Vector2(x*8, y*8), "Small", name)
			elif map_tile == 5 and obstacle_seed > 29.9:
				CreateObstacle("rock1", get_parent().object_list[name]["InstanceTree"], Vector2(x*8, y*8), "Small", name)
			elif map_tile == 5 and obstacle_seed > 29.8:
				CreateObstacle("rock2", get_parent().object_list[name]["InstanceTree"], Vector2(x*8, y*8), "Small", name)
func CreateObstacle(obstacle_name, instance_tree, obstacle_position, hitbox_size, island_id):
	var obstacle_id = get_node("/root/Server").generate_unique_id()
	var instance_tree_str = get_node("/root/Server").StringifyInstanceTree(instance_tree)+"/"+str(island_id)
	if get_node("/root/Server/Instances/"+instance_tree_str):
		var obstacle = load("res://Scenes/Instances/Obstacles/"+hitbox_size+".tscn").instance()
		obstacle.name = obstacle_id
		obstacle.position = obstacle_position + position
		get_node("/root/Server/Instances/"+instance_tree_str+"/YSort/Objects").add_child(obstacle)
		map_objects[obstacle_position] = {"P": obstacle_position, "I": instance_tree, "N":obstacle_name, "Type":"Obstacles"}
