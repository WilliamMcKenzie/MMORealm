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
		
		
func UpdateWorldState(world_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state_buffer.append(world_state)

func UpdateWorldStateOld(world_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state.erase("T")
		world_state.erase(get_tree().get_network_unique_id())
		for player in world_state.keys():
			if get_node("YSort/OtherPlayers").has_node(str(player)):
				get_node("YSort/OtherPlayers/" + str(player)).MovePlayer(world_state[player]["P"], world_state[player]["A"])
			else:
				SpawnNewPlayer(player, world_state[player]["P"])

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
