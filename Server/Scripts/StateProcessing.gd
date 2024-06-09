extends Node

var sync_clock_counter = 0
var world_state

func _physics_process(delta):
	sync_clock_counter += 1
	if sync_clock_counter ==  3:
		sync_clock_counter = 0
		for instance_tree in get_node("/root/Server").player_instance_tracker.keys():
			if instance_tree[instance_tree.size()-1].split(" ")[0] == "island":
				SendIslandData(instance_tree)
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

func SendIslandData(instance_tree):
	var node = get_node("/root/Server/Instances/"+get_node("/root/Server").StringifyInstanceTree(instance_tree))
	node.object_list = CleanObjects(node.object_list).duplicate(true)
		
	for chunk in node.chunks.keys():
		if node.chunks[chunk]["P"].keys().size() > 0:
			var chunk_data = node.GetChunkData(chunk)
			
			world_state = {}
			world_state["P"] = chunk_data["P"]
			world_state["E"] = chunk_data["E"]
			world_state["O"] = chunk_data["O"]
			world_state["T"] = OS.get_system_time_msecs()
						
			#We add speed checks here
			for id in node.world_state["P"]:
				get_node("/root/Server").SendWorldState(id, world_state)

func CleanObjects(objects):
	for k in objects.keys():
		if OS.get_system_time_msecs() > objects[k]["EndTime"]:
			objects.erase(k)
	return objects
