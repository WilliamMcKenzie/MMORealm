extends "../Map.gd"

var generating = false
var chunk_size = 16

var loaded_chunks = {}
var map_tiles = {}
var map_objects = []

var clock_sync_timer = 0
func _physics_process(delta):
	clock_sync_timer += 1
	if clock_sync_timer >= 20 and Server.player_position:
		clock_sync_timer = 0
		var base_position = Vector2(round(Server.player_position.x/8.0), round(Server.player_position.y/8.0))
		var loading_radius = 24
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
			9 : [4,2,0.5],
			10 : [4,2,0.5],
			11 : [2,6,0.3],
		}
		
		for object in map_objects:
			if (object["P"]).distance_to(Server.player_position) < loading_radius*8:
				var object_node = load("res://Scenes/SupportScenes/Objects/Obstacles/" + object["N"] + ".tscn")
				var object_instance = object_node.instance()
				object_instance.position = object["P"]
				get_node("YSort/Objects").add_child(object_instance)
				map_objects.erase(object)
		
		for x in range(base_position.x-(loading_radius/2), base_position.x+(loading_radius/2)):
			for y in range(base_position.y-(loading_radius/2), base_position.y+(loading_radius/2)):
				if map_tiles.has(Vector2(x,y)):
					var tile = map_tiles[Vector2(x,y)]
					map_tiles.erase(Vector2(x,y))
					
					var num_variations = tile_variations[tile]
					var random_index = 0
					
					#Standard tile
					if num_variations[0] > 1:
						random_index = randi() % num_variations[0]
						
						#Special tile
						if randf() < num_variations[2]:
							random_index = (randi() % num_variations[1]) + num_variations[0]
					
					$TileMap.set_cell(x,y,tile,false,false,false, Vector2(random_index, 0))

func GenerateChunk(chunk_data, chunk):
	map_objects += chunk_data["Objects"]
	var tiles = chunk_data["Tiles"]
	
	for x in range(chunk.x-(chunk_size/2), chunk.x+(chunk_size/2)):
		for y in range(chunk.y-(chunk_size/2), chunk.y+(chunk_size/2)):
			var tile = tiles[x-chunk.x+(chunk_size/2)][y-chunk.y+(chunk_size/2)]
			map_tiles[Vector2(x,y)] = tile

func LoadChunk(position, offset):
	var player_coords = Vector2(round((position/8).x), round((position/8).y))
	var chunk = Vector2(chunk_size*round((player_coords.x+offset.x)/chunk_size), chunk_size*round((player_coords.y+offset.y)/chunk_size))
	if loaded_chunks.has(chunk) or generating == true:
		return
	loaded_chunks[chunk] = true
	Server.FetchIslandChunk(chunk)
