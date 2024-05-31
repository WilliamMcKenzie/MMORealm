extends Node2D

var player_spawn = preload("res://Scenes/SupportScenes/PlayerCharacter/PlayerTemplate.tscn")

func SpawnNewPlayer(player_id, spawn_position):
	print("spawning new player")
	if get_tree().get_network_unique_id() == player_id:
		pass
	else:
		var player_instance = player_spawn.instance()
		player_instance.name = str(player_id)
		player_instance.position = spawn_position
		get_node("YSort/OtherPlayers").add_child(player_instance)

func DespawnPlayers(player_id):
	get_node("YSort/OtherPlayers" + str(player_id)).queue_free()
