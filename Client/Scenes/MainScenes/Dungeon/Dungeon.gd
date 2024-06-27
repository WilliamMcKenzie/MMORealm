extends "../Map.gd"

#Room size accounts for hallways in between
var room_size = 15

#For creating new dungeon instances
func PopulateDungeon(instance_data):
	var map = instance_data["Map"]
	var dungeon_name = instance_data["Name"]
	var id = instance_data["Id"]
	var room_size = instance_data["RoomSize"]
	
	#We add the hallways after so they go on top of the room tiles
	var hallways_to_add = []
	
	var room_nodes = {}
	var hallway_nodes = {
		Vector2(1,0) : load("res://Scenes/SupportScenes/Dungeons/"+dungeon_name+"/Hallways/HallwayRight.tscn"),
		Vector2(0,1) : load("res://Scenes/SupportScenes/Dungeons/"+dungeon_name+"/Hallways/HallwayDown.tscn"),
		Vector2(-1,0) : load("res://Scenes/SupportScenes/Dungeons/"+dungeon_name+"/Hallways/HallwayLeft.tscn"),
		Vector2(0,-1) : load("res://Scenes/SupportScenes/Dungeons/"+dungeon_name+"/Hallways/HallwayUp.tscn"),
	} 
	
	for room in map.keys():
		room_nodes[room] = load("res://Scenes/SupportScenes/Dungeons/"+dungeon_name+"/"+map[room].room_type+".tscn")
	
	#Set initial hallways in spawn room
	var coordinate_map = {
		0 : Vector2(1,0),
		1 : Vector2(0,1),
		2 : Vector2(-1,0),
		3 : Vector2(0,-1),
	}
	for _coordinate in range(4):
		var coordinate = coordinate_map[_coordinate]
		var room_data = map[coordinate]
		
		if room_data.root_path == coordinate:
			var hallway_to_add = hallway_nodes[coordinate].instance()
			hallway_to_add.room_data["start_room"] = Vector2.ZERO
			hallway_to_add.room_data["target_room"] = coordinate
			hallways_to_add.append(hallway_to_add)
		
	for room in map.keys():
		var room_to_add = room_nodes[room].instance()
		var room_data = map[room]
			
		room_to_add.position = room*(room_size)*8
		room_to_add.name = str(room)
		add_child(room_to_add)
		
		if room_data.has("direction"):
			var hallway_to_add = hallway_nodes[room_data.direction].instance()
			
			hallway_to_add.room_data["start_room"] = room
			hallway_to_add.room_data["target_room"] = room+room_data.direction
			hallway_to_add.position = room*(room_size)*8
			hallways_to_add.append(hallway_to_add)
	
	for hallway in hallways_to_add:
		add_child(hallway)
