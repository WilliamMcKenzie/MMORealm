extends Node

var world_state

func _physics_process(delta):
	if not get_node("/root/Server").player_state_collection.empty():
		world_state = get_node("/root/Server").player_state_collection.duplicate(true)
		for player in world_state:
			world_state[player].erase("T")
		world_state["T"] = OS.get_system_time_msecs()
		world_state["Objects"] = get_node("/root/Server").objects_state_collection
		#We add speed checks here
		
		get_node("/root/Server").SendWorldState(world_state)
