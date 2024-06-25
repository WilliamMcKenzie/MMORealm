extends "../Map.gd"

var generating = false
var chunk_size = 32
var loaded_chunks = {}

func GenerateChunk(chunk_data, chunk):
	var tiles = chunk_data["Tiles"]
	var objects = chunk_data["Objects"]
	
	for x in range(chunk.x-(chunk_size/2), chunk.x+(chunk_size/2)):
		for y in range(chunk.y-(chunk_size/2), chunk.y+(chunk_size/2)):
			var tile = tiles[x-chunk.x+(chunk_size/2)][y-chunk.y+(chunk_size/2)]
			$Tiles.set_cell(x,y,tile)
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
