extends "res://Scenes/Main/Nexus.gd"
var server_ref
var self_ref = self

export var map_size = Vector2(780,780)
export var ruler = ""
var ruler_id
var ruler_spawned = false
var ruler_death_position = Vector2.ZERO

var noise
var chunk_size = 16
var tile_cap = 0.5
var environment_caps = Vector3(0.4, 0.3, 0.04)

var map_as_array = []
var map_objects = {}

#Players spawn points
var spawn_points = []
var tile_points = {}
#Enemies spawn points
var enemy_spawn_points = {}

#Enemy variety
var beach_enemies = ["crab", "slime"]
var forest_enemies = ["goblin_cannon", "nature_druid", "slime"]
var plains_enemies = ["troll_king", "cyclops_leader", "imp_warrior", "blue_slime", "fire_druid"]
var badlands_enemies = ["rat_king", "viking_king", "yellow_slime", "shadow_druid"]
var mountain_enemies = ["cacodemon", "basalisk", "phoenix", "archmage"]

#Chunks
var chunks = {}
var loaded_chunks = {}

# warning-ignore:unused_argument
var sync_clock_counter = 0
var sync_clock_counter_2 = 0
var island_close_timer = 10
var island_closed = false

#Handle ruler
func HandleRuler(delta):
	sync_clock_counter_2 += 1
	
	CheckChunks()
	if not ruler:
		return
	
	if island_closed and get_child_count() == 3:
		get_node("/root/Server").player_instance_tracker.erase(instance_tree)
		get_parent().remove_child(self)
		queue_free()
	
	if sync_clock_counter_2 >= 60:
		sync_clock_counter_2 = 0
		
		var ruler_alive = false
		ruler_id = null
		
		for enemy_id in enemy_list:
			var enemy = enemy_list[enemy_id]
			if enemy.name == ruler and (not enemy.has("dead") or not enemy.dead):
				ruler_id = enemy_id
				ruler_alive = true
			elif enemy.name == ruler:
				ruler_death_position = enemy.position
		
		if not ruler_alive and not ruler_spawned and ServerData.GetEnemy(ruler):
			ruler_spawned = true
			var _instance_tree = instance_tree
			if _instance_tree:
				get_node("/root/Server").SpawnNPC(ruler, _instance_tree, map_size/2*8-position)
		elif not ruler_alive and ruler_spawned:
			island_close_timer -= delta*60
	
	if island_close_timer <= 0 and not island_closed and ServerData.GetEnemy(ruler).has("dungeon"):
		island_closed = true
		if get_parent().object_list.has(name):
			get_parent().object_list.erase(name)
		var dungeon = ServerData.GetEnemy(ruler).dungeon.name
		var instance_id = OpenPortal(dungeon, instance_tree, ruler_death_position)
		
		for player_id in player_list.keys():
			get_node("/root/Server").ForcedEnterInstance(instance_id, int(player_id))
	
	if island_close_timer <= 0 and not ServerData.GetEnemy(ruler).has("dungeon"):
		island_close_timer = 10
		get_node("/root/Server").SpawnNPC(ruler, instance_tree, map_size/2*8-position)

#Handle standard stuff
func _physics_process(delta):
	HandleRuler(delta)
	
	#Clock sync
	use_chunks = true
	for i in range(floor((running_time-last_tick)/tick_rate)):
		for enemy_id in enemy_list.keys():
			var enemy_data = enemy_list[enemy_id]
			if(enemy_data["health"] < 1):
				if enemy_data["name"] == ruler and ServerData.GetEnemy(ruler).has("dungeon"):
					enemy_list[enemy_id]["pattern_timer"] = OS.get_system_time_msecs()
					enemy_list[enemy_id]["pattern_timer"] = OS.get_system_time_msecs()
					enemy_list[enemy_id]["dead"] = true
					if GameplayLoop.bosses_status.has(ruler):
						GameplayLoop.bosses_status[ruler] = false
				else:
					CalculateLootPool(enemy_data, enemy_id)
					var chunk = CalculateChunk(enemy_data["position"])
					
					if chunks.has(chunk) and chunks[chunk]["E"].has(enemy_id):
						chunks[chunk]["E"].erase(enemy_id)
					enemy_list.erase(enemy_id)
		last_tick = running_time
	
	sync_clock_counter += 1
	if sync_clock_counter ==  60*5:
		sync_clock_counter = 0
		for chunk in chunks:
			if IsChunkRadiusEmpty(chunk):
				for id in chunks[chunk]["E"].keys():
					var is_ruler = enemy_list[id].origin == ruler_id or enemy_list[id].name == ruler
					if not ruler or not is_ruler:
						enemy_list.erase(id)
						chunks[chunk]["E"].erase(id)
func SpawnEnemy(enemy, enemy_id):
	enemy_list[str(enemy_id)] = enemy

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
	return spawn_points[randi() % len(spawn_points)]
func GetIslandChunk(chunk):
	var result = []
	var objects = []
	
	var full_chunk = chunks.has(chunk) and chunks[chunk]["E"].size() > 10000
	var player_chunk = chunks.has(chunk) and chunks[chunk]["P"].size() == 0
	
	for x in range(chunk.x-(chunk_size/2), chunk.x+(chunk_size/2)):
		result.append([])
		for y in range(chunk.y-(chunk_size/2), chunk.y+(chunk_size/2)):
			if map_as_array.size() > x and map_as_array[x].size() > y:
				result[result.size()-1].append(map_as_array[x][y])
				if map_objects.has(Vector2(x*8, y*8)):
					objects.append(map_objects[Vector2(x*8, y*8)])
				
				if enemy_spawn_points.has(Vector2(x,y)) and not full_chunk and not player_chunk:
					var selection = enemy_spawn_points[Vector2(x,y)]["Selection"]
					var enemy_index = round(rand_range(0, selection.size()-1))
					
					#For spawning bots. to laggy rn
					#if false == true and (chunks.has(chunk) and chunks[chunk]["P"].size() == 0) or not chunks.has(chunk):
					if false:
						var container = PlayerVerification.CreateFakePlayerContainer(Vector2(x*8, y*8))
						container.GiveEffect("invincible", 99999)
						get_node("/root/Server").ForcedEnterInstance(name, int(container.name))
						container.position = Vector2(x*8, y*8)
						UpdatePlayer(container.name, {"T":OS.get_system_time_msecs(), "P":container.position, "A":{ "A" : "Idle", "C" : Vector2.ZERO }, "S":{ "R" : Rect2(Vector2(0,0), Vector2(80,40)), "C" : "Apprentice", "P" : {"ColorParams" : {}, "TextureParams" : {}}}})
					
					if selection.size() > 0 and Behaviors.DetermineCollisionSafePoint(Vector2(x*8, y*8), Vector2(x*8, y*8), self, selection[enemy_index]):
						get_node("/root/Server").SpawnNPC(selection[enemy_index], instance_tree, Vector2(x*8, y*8)-self.position)
	return {
		"Tiles" : result,
		"Objects" : objects
	}
func GetChunkData(chunk):
	var res = {
		"E" : {},
		"P" : {},
		"O" : object_list,
	}
	
	if chunks.has(chunk) and (not chunks[chunk].empty()):
		res["E"]= chunks[chunk]["E"]
		res["P"] = chunks[chunk]["P"]
	
	return res

func _ready():
	if ruler and load("res://Scenes/SupportScenes/Island/Structures/" + ruler + ".tscn"):
		var setpiece = load("res://Scenes/SupportScenes/Island/Structures/" + ruler + ".tscn").instance()
		CreateStructure(setpiece, Vector2(round(map_size.x/2), round(map_size.y/2)))
		setpiece.queue_free()

func GenerateIslandMap():
	if get_script().resource_path.get_file().get_basename() == "TutorialIsland" and has_method("TutorialInit"):
		self_ref.TutorialInit()
	
	noise = OpenSimplexNoise.new()
	noise.octaves = 1.0
	noise.period = 12
	PopulateTiles()
	ArrayToTiles()
	PopulateObstacles()

func PopulateTiles():
	var center = map_size / 2
	var ocean_distance = center.length() * 1.5
	var beach_distance = center.length() * 1.25
	var forest_distance = center.length() * 1.2
	var plains_distance = center.length() * 1
	var badlands_distance = center.length() * 0.8
	var mountains_distance = center.length() * 0.5
	
	#For wavy edges of island
	var noise_scale = 0.6
	var noise_intensity = 0.05
	
	for x in range(map_size.x):
		map_as_array.append([])
		for y in range(map_size.y):
			var distance = (Vector2(x, y) - center).length()
			var noise_offset = rand_range(0,0.03)

			#Base value for a perfect circle
			var ocean_value = 1.0 - (distance / ocean_distance)
			var noise_value = noise.get_noise_2d(x * noise_scale, y * noise_scale) * noise_intensity
			
			var beach_value = (1.0 - (distance / beach_distance)) + noise_value/3
			var forest_value = (1.0 - (distance / forest_distance)) + noise_value/3
			var plains_value = (1.0 - (distance / plains_distance)) + noise_value/3 + noise_offset
			var badlands_value = (1.0 - (distance / badlands_distance)) + noise_value + noise_offset
			var mountains_value = (1.0 - (distance / mountains_distance)) + noise_value*2 + noise_offset
			
			if mountains_value > tile_cap:
				map_as_array[x].append(6)
			elif badlands_value > tile_cap:
				map_as_array[x].append(5)
			elif plains_value > tile_cap:
				map_as_array[x].append(4)
			elif forest_value > tile_cap:
				map_as_array[x].append(3)
			elif beach_value > tile_cap:
				map_as_array[x].append(2)
			elif ocean_value > tile_cap:
				map_as_array[x].append(1)
			else:
				map_as_array[x].append(0)
	
	var structures = ["ruins_0", "ruins_1", "ruins_2"]
	for x in range(0, map_size.x, chunk_size):
		for y in range(0, map_size.y, chunk_size):
			var tile = map_as_array[x][y]
			var structure_seed = randf()
			var structure_index = round(rand_range(0, structures.size()-1))
			if tile == 6 and structure_seed < 0.3:
				var structure = load("res://Scenes/SupportScenes/Island/Structures/" + structures[structure_index] + ".tscn").instance()
				CreateStructure(structure, Vector2(x,y))
				structure.queue_free()

func CreateStructure(structure, placement):
	for x in range(-32, 32*2):
		for y in range(-32, 32*2):
			var current_tile = structure.get_cell(x,y)
			
			if current_tile > -1:
				var pos = Vector2(x + placement.x, y + placement.y)
				if map_objects.has(Vector2(pos.x*8, pos.y*8)):
					map_objects.erase(Vector2(pos.x*8, pos.y*8))
				map_as_array[pos.x][pos.y] = current_tile
				$TileMap.set_cell(pos.x, pos.y, map_as_array[pos.x][pos.y])

var chunk_sync_clock_counter = 0
func CheckChunks():
	chunk_sync_clock_counter += 1
	if chunk_sync_clock_counter >= 60:
		chunk_sync_clock_counter = 0
		chunks = {}
		for player_id in player_list.keys():
			var chunk = CalculateChunk(player_list[player_id].position)
			if not chunks.has(chunk):
				chunks[chunk] = {}
				chunks[chunk]["P"] = {}
				chunks[chunk]["E"] = {}
				chunks[chunk]["O"] = {}
			chunks[chunk]["P"][player_id] = player_list[player_id]
		for enemy_id in enemy_list.keys():
			var chunk = CalculateChunk(enemy_list[enemy_id].position)
			if not chunks.has(chunk):
				chunks[chunk] = {}
				chunks[chunk]["P"] = {}
				chunks[chunk]["E"] = {}
				chunks[chunk]["O"] = {}
			chunks[chunk]["E"][enemy_id] = enemy_list[enemy_id]
		for object_id in object_list.keys():
			var chunk = CalculateChunk(object_list[object_id].position)
			if not chunks.has(chunk):
				chunks[chunk] = {}
				chunks[chunk]["P"] = {}
				chunks[chunk]["E"] = {}
				chunks[chunk]["O"] = {}
			chunks[chunk]["O"][object_id] = object_list[object_id]

func ArrayToTiles():
	var spawn_point_index = 0
	for x in range(map_size.x):
		for y in range(map_size.y):
			var map_tile = map_as_array[x][y]
			var spawnpoint_tile = x%12 == 0 and y%12 == 0
			var spawnpoint_position = Vector2(x+round(rand_range(-4, 4)), y+round(rand_range(-4, 4)))
			
			if tile_points.has(map_tile):
				tile_points[map_tile].append(Vector2(x*8, y*8))
			else:
				tile_points[map_tile] = [Vector2(x*8, y*8)]
			if map_tile == 2:
				spawn_points.append(Vector2(x*8, y*8))
			
			if not spawnpoint_tile:
				continue
			elif map_tile == 2:
				enemy_spawn_points[spawnpoint_position] = { "Index": spawn_point_index, "Alive":false, "Selection":beach_enemies}
				spawn_point_index += 1
			elif map_tile == 3:
				enemy_spawn_points[spawnpoint_position] = { "Index": spawn_point_index, "Alive":false, "Selection":forest_enemies}
				spawn_point_index += 1
			elif map_tile == 4:
				enemy_spawn_points[spawnpoint_position] = { "Index": spawn_point_index, "Alive":false, "Selection":plains_enemies}
				spawn_point_index += 1
			elif map_tile == 5:
				enemy_spawn_points[spawnpoint_position] = { "Index": spawn_point_index, "Alive":false, "Selection":badlands_enemies}
				spawn_point_index += 1
			elif map_tile == 6:
				enemy_spawn_points[spawnpoint_position] = { "Index": spawn_point_index, "Alive":false, "Selection":mountain_enemies}
				spawn_point_index += 1
			#For visualizing realms
			#$TileMap.set_cell(x, y, map_as_array[x][y])

func PopulateObstacles():
	randomize()
	var obstacle_small = load("res://Scenes/SupportScenes/Obstacles/Small.tscn")
	var chance = 1.0
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
	
	for x in range(map_size.x):
		for y in range(map_size.y):
			var map_tile = map_as_array[x][y]
			var obstacle_seed = rand_range(0, 100)
			
			if obstacles.has(map_tile):
				var obstacle_list = obstacles[map_tile]
				
				var i = 0
				for obstacle in obstacle_list:
					i += 1
					if obstacle_seed < chance*i and not enemy_spawn_points.has(Vector2(x, y)):
						CreateObstacle(obstacle, instance_tree, Vector2(x, y), name)
						break

func CreateObstacle(obstacle_name, instance_tree, obstacle_position, island_id):
	var obstacle_id = server_ref.generate_unique_id()
	var instance_tree_str = server_ref.StringifyInstanceTree(instance_tree)
	$TileMap.set_cell(obstacle_position.x, obstacle_position.y-1, 7)
	map_objects[Vector2(obstacle_position.x*8, obstacle_position.y*8)] = {"P": Vector2((obstacle_position.x*8)+4, (obstacle_position.y*8)+6), "I": instance_tree, "N":obstacle_name, "Type":"Obstacles"}
