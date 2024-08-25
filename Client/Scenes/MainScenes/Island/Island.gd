extends "../Map.gd"

var generating = false
var chunk_size = 16
var loaded_chunks = {}

func GenerateChunk(chunk_data, chunk):
	var tile_map = {
		0 : []
	}
	var tiles = chunk_data["Tiles"]
	var objects = chunk_data["Objects"]
	
	#key is tile id
	#value is 
	#index 0: standard variations (plain grass, plain sand)
	#index 1: unique variations (seashells, flowers etc)
	#index 2: chance of unique variation
	var tile_variations = {
		0 : [1,0,0],
		1 : [1,0,0],
		2 : [2,3,0.01],
		3 : [3,4,0.08],
		4 : [3,4,0.1],
		5 : [3,6,0.1],
		6 : [2,4,0.25],
		7 : [1,0,0],
		8 : [1,0,0],
		9 : [1,0,0],
	}
	
	for x in range(chunk.x-(chunk_size/2), chunk.x+(chunk_size/2)):
		for y in range(chunk.y-(chunk_size/2), chunk.y+(chunk_size/2)):
			var tile = tiles[x-chunk.x+(chunk_size/2)][y-chunk.y+(chunk_size/2)]
			
			var num_variations = tile_variations[tile]
			var random_index = 0
			
			#Standard tile
			if num_variations[0] > 1:
				random_index = randi() % num_variations[0]
				
				#Special tile
				if randf() < num_variations[2]:
					random_index = (randi() % num_variations[1]) + num_variations[0]
			
			$TileMap.set_cell(x,y,tile,false,false,false, Vector2(random_index, 0))
			
	for object in objects:
		var object_node = load("res://Scenes/SupportScenes/Objects/Obstacles/" + object["N"] + ".tscn")
		var object_instance = object_node.instance()
		object_instance.position = object["P"]
		get_node("YSort/Objects").add_child(object_instance)
		
func LoadChunk(position, offset):
	var player_coords = Vector2(round((position/8).x), round((position/8).y))
	var chunk = Vector2(chunk_size*round((player_coords.x+offset.x)/chunk_size), chunk_size*round((player_coords.y+offset.y)/chunk_size))
	if loaded_chunks.has(chunk) or generating == true:
		return
	loaded_chunks[chunk] = true
	Server.FetchIslandChunk(chunk)
