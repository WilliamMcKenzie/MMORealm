extends Node2D

var player_spawn = preload("res://Scenes/SupportScenes/PlayerCharacter/PlayerTemplate.tscn")
var last_world_state = 0

func UpdateWorldState(world_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state.erase("T")
		world_state.erase(get_tree().get_network_unique_id())
		for player in world_state.keys():
			if get_node("YSort/OtherPlayers").has_node(str(player)):
				get_node("YSort/OtherPlayers/" + str(player)).MovePlayer(world_state[player]["P"])
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
	get_node("YSort/OtherPlayers" + str(player_id)).queue_free()
