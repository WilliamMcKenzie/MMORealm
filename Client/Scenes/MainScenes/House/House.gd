extends "../Map.gd"

func UpdateTiles(tiles):
	var tile_variations = {
		0 : [1,0,0],
		1 : [1,0,0],
		2 : [3,4,0.08],
		3 : [4,2,0.08],
		4 : [1,0,0],
		5 : [1,2,0.05],
		6 : [1,0,0],
	}
	
	for x in range(64):
		for y in range(64):
			if $TileMap.get_cell(x,y) == tiles[x][y]:
				continue
			
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

func PopulateHouse(house_data):
	var tiles = house_data["Tiles"]
	var tile_variations = {
		0 : [1,0,0],
		1 : [1,0,0],
		2 : [3,4,0.08],
		3 : [4,2,0.08],
		4 : [1,0,0],
		5 : [1,2,0.05],
		6 : [1,0,0],
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
