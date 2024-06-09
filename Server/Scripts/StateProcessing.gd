extends Node

var sync_clock_counter = 0
var world_state

func _physics_process(delta):
	sync_clock_counter += 1
	if sync_clock_counter ==  3:
		sync_clock_counter = 0
		for instance_tree in get_node("/root/Server").player_instance_tracker.keys():
			var node = get_node("/root/Server/Instances/"+get_node("/root/Server").StringifyInstanceTree(instance_tree))
			node.object_list = CleanObjects(node.object_list).duplicate(true)
			
			world_state = {}
			world_state["P"] = node.player_list
			world_state["E"] = node.enemy_list
			world_state["O"] = node.object_list
			world_state["T"] = OS.get_system_time_msecs()
				
			#We add speed checks here
			for id in get_node("/root/Server").player_instance_tracker[instance_tree]:
				get_node("/root/Server").SendWorldState(id, world_state)
func CleanObjects(objects):
	for k in objects.keys():
		if OS.get_system_time_msecs() > objects[k]["EndTime"]:
			objects.erase(k)
	return objects
