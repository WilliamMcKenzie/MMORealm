extends Node2D

var room_data = {}

func _ready():
	if room_data.has("start_room") and room_data.has("target_room"):
		HallwaySetup()

func HallwaySetup():
	var start_room = get_parent().get_node(str(room_data.start_room))
	var target_room = get_parent().get_node(str(room_data.target_room))
	var direction = room_data.target_room - room_data.start_room
	
	var tiles = []
	var room_size = get_parent().room_size
	var target_coordinates = direction*Vector2(room_size,room_size)
	
	for x in range(-room_size, room_size*2):
		for y in range(-room_size, room_size*2):
			if $TileMap.get_cell(x,y) > -1:
				tiles.append(Vector2(x, y))
	
	for tile in tiles:
		start_room.get_node("TileMap").set_cell(tile.x,tile.y,-1)
		target_room.get_node("TileMap").set_cell(tile.x-target_coordinates.x,tile.y-target_coordinates.y,-1)
