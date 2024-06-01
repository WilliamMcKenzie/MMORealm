extends Node2D

var player_spawn = preload("res://Scenes/SupportScenes/PlayerCharacter/PlayerTemplate.tscn")
var last_world_state = 0

var world_state_buffer = []
const interpolation_offset = 50

func _physics_process(delta):
	var render_time = OS.get_system_time_msecs() - interpolation_offset
	if world_state_buffer.size() > 1:
		while(world_state_buffer.size() > 2 and render_time > world_state_buffer[2].T):
			world_state_buffer.remove(0)
		if world_state_buffer.size() > 2:
			var interpolation_factor = float(render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[1]["T"])
			for player in world_state_buffer[2].keys():
				if str(player) == "T":
					continue;
				if str(player) == "Objects":
					UpdateObjects(world_state_buffer[2]["Objects"], world_state_buffer[1][get_tree().get_network_unique_id()]["I"])
					continue;
				if player == get_tree().get_network_unique_id():
					continue;
				if not world_state_buffer[1].has(player):
					continue;
				if world_state_buffer[1][player]["I"] != world_state_buffer[1][get_tree().get_network_unique_id()]["I"]:
					if get_node("YSort/OtherPlayers").has_node(str(player)):
						DespawnPlayer(player)
					else:
						continue
				if get_node("YSort/OtherPlayers").has_node(str(player)):
					var new_position = lerp(world_state_buffer[1][player]["P"], world_state_buffer[2][player]["P"], interpolation_factor)
					get_node("YSort/OtherPlayers/" + str(player)).MovePlayer(new_position, world_state_buffer[2][player]["A"])
				else:
					SpawnNewPlayer(player, world_state_buffer[2][player]["P"])
		elif render_time > world_state_buffer[1]["T"]:
			var extrapolation_factor = float(render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.00
			for player in world_state_buffer[1].keys():
				if str(player) == "T":
					continue;
				if str(player) == "Objects":
					UpdateObjects(world_state_buffer[1]["Objects"], world_state_buffer[0][get_tree().get_network_unique_id()]["I"])
					continue;
				if player == get_tree().get_network_unique_id():
					continue;
				if not world_state_buffer[0].has(player):
					continue;
				if world_state_buffer[0][player]["I"] != world_state_buffer[0][get_tree().get_network_unique_id()]["I"]:
					if get_node("YSort/OtherPlayers").has_node(str(player)):
						DespawnPlayer(player)
					else:
						continue
				if get_node("YSort/OtherPlayers").has_node(str(player)):
					var position_delta = (world_state_buffer[1][player]["P"] - world_state_buffer[0][player]["P"])
					var new_position = world_state_buffer[1][player]["P"] + (position_delta * extrapolation_factor)
					get_node("YSort/OtherPlayers/" + str(player)).MovePlayer(new_position, world_state_buffer[1][player]["A"])
				else:
					SpawnNewPlayer(player, world_state_buffer[1][player]["P"])

func UpdateObjects(objects_dict, current_instance):
	var type
	for instance_id in objects_dict.keys():
		type = objects_dict[instance_id]["Type"]
		var scene_name = objects_dict[instance_id]["N"]+".tscn"
		if scene_name == "test_dungeon.tscn":
		if (not get_node("YSort/Objects").has_node(str(instance_id))) and current_instance == objects_dict[instance_id]["I"]:
			var object_scene = load("res://Scenes/SupportScenes/Objects/"+type+"/"+scene_name)
			var object_instance = object_scene.instance()
			object_instance.name = str(instance_id)
			object_instance.object_id = str(instance_id)
			object_instance.position = objects_dict[instance_id]["P"]
			get_node("YSort/Objects").add_child(object_instance)
	for object_node in get_node("YSort/Objects").get_children():
		if not objects_dict.has(object_node.name):
			get_node("YSort/Objects/"+object_node.name).queue_free()
		
func UpdateWorldState(world_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state_buffer.append(world_state)

func SpawnNewPlayer(player_id, spawn_position):
	if get_tree().get_network_unique_id() == player_id:
		pass
	else:
		if not get_node("YSort/OtherPlayers").has_node(str(player_id)):
			var player_instance = player_spawn.instance()
			player_instance.name = str(player_id)
			player_instance.position = spawn_position
			get_node("YSort/OtherPlayers").add_child(player_instance)

func DespawnPlayer(player_id):
	get_node("YSort/OtherPlayers/" + str(player_id)).queue_free()
	yield(get_tree().create_timer(0.2), "timeout")
	if get_node("YSort/OtherPlayers").has_node(str(player_id)):
		get_node("YSort/OtherPlayers/" + str(player_id)).queue_free()

#For creating new dungeon instances
func PopulateDungeon(instance_data):
	var map = instance_data["Map"]
	var dungeon_name = instance_data["Name"]
	var id = instance_data["Id"]
	
	var room_nodes = {}
	
	for path in map:
		for room in path:
			room_nodes[room] = load("res://Scenes/SupportScenes/Dungeons/"+dungeon_name+"/"+room+".tscn")
	
	var direction_map = {
		0 : Vector2(0, 1),
		1 : Vector2(1, 0),
		2 : Vector2(0, -1),
		3 : Vector2(-1, 0)
	}
	for i in range(map.size()):
		for k in range(map[i].size()):
			var room_to_add = room_nodes[map[i][k]].instance()
			room_to_add.position = direction_map[i]*k*(15)*8
			add_child(room_to_add)
