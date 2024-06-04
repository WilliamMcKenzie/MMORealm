extends Node2D

var noise
var map_size = Vector2(1000,1000)
var grass_cap = 0.5
var road_caps = Vector2(0.05, 0.02)
var environment_caps = Vector3(0.4, 0.3, 0.04)

var map_as_array = []
var map_objects = []

var spawn_points = []

var enemy_list = {}

func _physics_process(delta):
	for enemy_id in enemy_list.keys():
		if(enemy_list[enemy_id]["Health"] < 1):
			enemy_list.erase(enemy_id)
			get_node("/root/Server").enemies_state_collection.erase(enemy_id)

func GetMapSpawnpoint():
	randomize()
	return spawn_points[rand_range(0, spawn_points.size())]
func GetMapData():
	return {
		"Tiles" : map_as_array,
		"Objects" : map_objects
	}

func GenerateIslandMap():
	noise = OpenSimplexNoise.new()
	noise.octaves = 1.0
	noise.period = 12
	MakeOcean()
	MakeBeachMap()
	MakeForestMap()
	MakePlainsMap()
	MakeMountainsMap()
	ArrayToTiles()
func ArrayToTiles():
	for x in range(map_size.x):
		for y in range(map_size.y):
			if map_as_array[x][y] == 2:
				spawn_points.append(Vector2(x*8, y*8))
			#For visualizing realms
			#$Tiles.set_cell(x, y, map_as_array[x][y])
func MakeOcean():
	var center = map_size / 2
	var max_distance = center.length() * 1.3  # Adjust 0.8 to change the island's radius

	for x in range(map_size.x):
		map_as_array.append([])
		for y in range(map_size.y):
			map_as_array[x].append([])
			var distance = (Vector2(x, y) - center).length()

			# Base value for a perfect circle
			var base_value = 1.0 - (distance / max_distance)

			if base_value > grass_cap:
				map_as_array[x][y] = 1
			else:
				map_as_array[x][y] = 0
func MakeBeachMap():
	var center = map_size / 2
	var max_distance = center.length() * 1  # Adjust 0.8 to change the island's radius

	for x in range(map_size.x):
		for y in range(map_size.y):
			var distance = (Vector2(x, y) - center).length()

			# Base value for a perfect circle
			var base_value = 1.0 - (distance / max_distance)

			# Noise to create wavy edges
			var noise_scale = 0.6
			var noise_intensity = 0.1
			
			var noise_value = noise.get_noise_2d(x * noise_scale, y * noise_scale) * noise_intensity
			var combined_value = base_value + noise_value

			if combined_value > grass_cap:
				map_as_array[x][y] = 2
func MakeForestMap():
	var center = map_size / 2
	var max_distance = center.length() * 0.9  # Adjust 0.8 to change the island's radius

	for x in range(map_size.x):
		for y in range(map_size.y):
			var distance = (Vector2(x, y) - center).length()

			# Base value for a perfect circle
			var base_value = 1.0 - (distance / max_distance)

			# Noise to create wavy edges
			var noise_scale = 0.6
			var noise_intensity = 0.1
			
			var noise_value = noise.get_noise_2d(x * noise_scale, y * noise_scale) * noise_intensity
			var combined_value = base_value + noise_value

			if combined_value > grass_cap:
				map_as_array[x][y] = 3
func MakePlainsMap():
	var center = map_size / 2
	var max_distance = center.length() * 0.6  # Adjust 0.8 to change the island's radius

	for x in range(map_size.x):
		for y in range(map_size.y):
			var distance = (Vector2(x, y) - center).length()

			# Base value for a perfect circle
			var base_value = 1.0 - (distance / max_distance)

			# Noise to create wavy edges
			var noise_scale = 0.6
			var noise_intensity = 0.1
			
			var noise_value = noise.get_noise_2d(x * noise_scale, y * noise_scale) * noise_intensity
			var combined_value = base_value + noise_value

			if combined_value > grass_cap:
				map_as_array[x][y] = 4
func MakeMountainsMap():
	var center = map_size / 2
	var max_distance = center.length() * 0.4  # Adjust 0.8 to change the island's radius

	for x in range(map_size.x):
		for y in range(map_size.y):
			var distance = (Vector2(x, y) - center).length()

			# Base value for a perfect circle
			var base_value = 1.0 - (distance / max_distance)

			# Noise to create wavy edges
			var noise_scale = 0.6
			var noise_intensity = 0.1
			
			var noise_value = noise.get_noise_2d(x * noise_scale, y * noise_scale) * noise_intensity
			var combined_value = base_value + noise_value

			if combined_value > grass_cap:
				map_as_array[x][y] = 5
