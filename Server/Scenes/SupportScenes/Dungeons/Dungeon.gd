extends "res://Scenes/Main/Nexus.gd"

#Room size accounts for hallways in between
var room_size = 15
var map = {}

var sync_clock_counter = 1

func GetMapSpawnpoint():
	return Vector2(room_size/2*8, room_size/2*8)

func _ready():
	if map != {}:
		PopulateDungeon()

func _physics_process(delta):
	sync_clock_counter += 1
	if sync_clock_counter ==  60:
		sync_clock_counter = 0
		
		var is_empty = get_node("YSort/Players").get_child_count() == 0 and get_child_count() == 1
		var is_open = get_parent().object_list.has(name)
		if is_empty and not is_open:
			get_node("/root/Server").player_instance_tracker.erase(instance_tree)
			get_parent().object_list.erase(name)
			get_parent().remove_child(self)
			queue_free()

#For creating new dungeon instances
func PopulateDungeon():
	var dungeon_name = get_parent().object_list[name]["name"]
	var id = name
	
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
