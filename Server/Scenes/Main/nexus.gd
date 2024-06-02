extends Node

var enemy_list = {}

func _physics_process(delta):
	for enemy_id in enemy_list.keys():
		if(enemy_list[enemy_id]["Health"] < 1):
			enemy_list.erase(enemy_id)
			get_node("/root/Server").enemies_state_collection.erase(enemy_id)
