extends Node

var sync_clock_counter = 0
var world_state

func _physics_process(delta):
	sync_clock_counter += 1
	if sync_clock_counter ==  3:
		sync_clock_counter = 0
		if not get_node("/root/Server").player_state_collection.empty():
			world_state = get_node("/root/Server").player_state_collection.duplicate(true)
			for player in world_state:
				world_state[player].erase("T")
			world_state["T"] = OS.get_system_time_msecs()
			
			world_state["Enemies"] = get_node("/root/Server").enemies_state_collection
			
			#Objects
			get_node("/root/Server").objects_state_collection = CleanObjects(get_node("/root/Server").objects_state_collection).duplicate(true)
			world_state["Objects"] = get_node("/root/Server").objects_state_collection
			#We add speed checks here
			
			get_node("/root/Server").SendWorldState(world_state)
func CleanObjects(objects):
	for k in objects.keys():
		if OS.get_system_time_msecs() > objects[k]["T"]:
			objects.erase(k)
	return objects
