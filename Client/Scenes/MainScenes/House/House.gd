extends "../Map.gd"

var generating = false
var chunk_size = 16
var loaded_chunks = {}

func PopulateHouse(house_data):
	var tiles = house_data["Tiles"]
	var tile_variations = {
		0 : [1,0,0],
		1 : [1,0,0],
		2 : [2,3,0.01],
		3 : [3,4,0.08],
		4 : [3,4,0.1],
		5 : [3,6,0.1],
		6 : [2,4,0.25],
		7 : [3,2,0.1],
		8 : [2,4,0.25],
		9 : [1,0,0],
	}
	
	for x in range(64):
		for y in range(64):
			var tile = tiles[x][y]
			var num_variations = tile_variations[int(tile)]
			var random_index = 0
			
			#Standard tile
			if num_variations[0] > 1:
				random_index = randi() % num_variations[0]
				
				#Special tile
				if randf() < num_variations[2]:
					random_index = (randi() % num_variations[1]) + num_variations[0]
			
			$TileMap.set_cell(x,y,tile,false,false,false, Vector2(random_index, 0))
