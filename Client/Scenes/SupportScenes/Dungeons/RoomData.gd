extends Node2D

var room_data = {}
var encounter = false

func _ready():
	if room_data.has("start_room") and room_data.has("target_room"):
		HallwaySetup()
	#We dont actually use this nodes tilemap, we just use the parents tilemap and put all of our data onto it.
	SetParentTilemap()

func SetParentTilemap():
	var parent_tilemap = get_parent().get_node("TileMap")
	var offset = position/8
	var room_size = get_parent().room_size
	
	if encounter:
		for x in range(-100, 100):
			for y in range(-100, 100):
				var autotile_coord = $TileMap.get_cell_autotile_coord(x,y)
				var current_tile = $TileMap.get_cell(x,y)
				
				if current_tile > -1:
					parent_tilemap.set_cell(x + offset.x, y + offset.y, current_tile, false, false, false, autotile_coord)
	else:
		for x in range(-room_size, room_size*2):
			for y in range(-room_size, room_size*2):
				var autotile_coord = $TileMap.get_cell_autotile_coord(x,y)
				var current_tile = $TileMap.get_cell(x,y)
				
				if current_tile > -1:
					parent_tilemap.set_cell(x + offset.x, y + offset.y, current_tile, false, false, false, autotile_coord)
	queue_free()

func HallwaySetup():
	var start_room = get_parent().get_node(str(room_data.start_room))
	var target_room = get_parent().get_node(str(room_data.target_room))
	var direction = room_data.target_room - room_data.start_room
	
	var tiles = {}
	var room_size = get_parent().room_size
	var target_coordinates = direction*Vector2(room_size,room_size)
	
	for x in range(-room_size, room_size*2):
		for y in range(-room_size, room_size*2):
			if $TileMap.get_cell(x,y) > -1:
				tiles[Vector2(x, y)] = $TileMap.get_cell(x,y)
	
	for tile in tiles.keys():
		start_room.get_node("TileMap").set_cell(tile.x,tile.y, tiles[tile])
		target_room.get_node("TileMap").set_cell(tile.x-target_coordinates.x,tile.y-target_coordinates.y, tiles[tile])
	
	get_node("TileMap").queue_free()
