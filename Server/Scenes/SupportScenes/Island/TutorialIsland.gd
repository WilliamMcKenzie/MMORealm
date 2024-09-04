extends "res://Scenes/SupportScenes/Island/Island.gd"

var boss_is_alive = false

func PopulateTiles():
	var center = map_size / 2
	var ocean_distance = center.length() * 1.5
	var beach_distance = center.length() * 1.2
	var forest_distance = center.length() * 1
	
	#For wavy edges of island
	var noise_scale = 0.6
	var noise_intensity = 0.05
	
	for x in range(map_size.x):
		map_as_array.append([])
		for y in range(map_size.y):
			map_as_array[x].append([])
			var distance = (Vector2(x, y) - center).length()

			#Base value for a perfect circle
			var ocean_value = 1.0 - (distance / ocean_distance)
			
			var noise_value = noise.get_noise_2d(x * noise_scale, y * noise_scale) * noise_intensity
			var river_value = (1.0 - (distance / 1.5)) + noise_value/3
			
			var beach_value = (1.0 - (distance / beach_distance)) + noise_value/3
			var forest_value = (1.0 - (distance / forest_distance)) + noise_value/3 + rand_range(0,0.03)

			if forest_value > tile_cap:
				map_as_array[x][y] = 3
			elif beach_value > tile_cap:
				map_as_array[x][y] = 2
			elif ocean_value > tile_cap:
				map_as_array[x][y] = 1
			else:
				map_as_array[x][y] = 0

func TutorialInit():
	ruler = "tutorial_troll_king"
	
	beach_enemies = ["tutorial_crab"]
	forest_enemies = ["slime"]
	plains_enemies = []
	badlands_enemies = []
	mountain_enemies = []
