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
				continue
			var node = get_node("/root/Server/Instances/"+get_node("/root/Server").StringifyInstanceTree(instance_tree))
			node.object_list = CleanObjects(node.object_list).duplicate(true)
			
			world_state = {}
			world_state["P"] = node.player_list.duplicate()
			world_state["E"] = node.enemy_list.duplicate()
			world_state["O"] = node.object_list.duplicate()
			world_state["T"] = OS.get_system_time_msecs()
			
			for enemy_id in world_state["E"].keys():
				var enemy = world_state["E"][enemy_id].duplicate()
				enemy.erase("health")
				enemy.erase("max_health")
				enemy.erase("defense")
				enemy.erase("state")
				enemy.erase("behaviour")
				enemy.erase("speed")
				enemy.erase("exp")
				enemy.erase("damage_tracker")
				enemy.erase("target")
				enemy.erase("anchor_position")
				enemy.erase("pattern_index")
				enemy.erase("pattern_timer")
				enemy.erase("phase_index")
				enemy.erase("phase_timer")
				enemy.erase("used_phases")
				world_state["E"][enemy_id] = enemy
			
			for id in get_node("/root/Server").player_instance_tracker[instance_tree]:
				get_node("/root/Server").SendWorldState(id, world_state)

func SendIslandData(instance_tree):
	var node = get_node("/root/Server/Instances/"+get_node("/root/Server").StringifyInstanceTree(instance_tree))
	node.object_list = CleanObjects(node.object_list).duplicate(true)
	
	var chunk_size = 16
	for chunk in node.chunks.keys():
		if node.chunks[chunk]["P"].keys().size() > 0:
			var result = { "E" : {}, "P" : {}, "O" : {} }
			var chunk_data = []
			chunk_data.append(node.GetChunkData(chunk))
			chunk_data.append(node.GetChunkData(chunk + Vector2(chunk_size, 0)))
			chunk_data.append(node.GetChunkData(chunk + Vector2(chunk_size, chunk_size)))
			chunk_data.append(node.GetChunkData(chunk + Vector2(-chunk_size, 0)))
			chunk_data.append(node.GetChunkData(chunk + Vector2(-chunk_size, chunk_size)))
			chunk_data.append(node.GetChunkData(chunk + Vector2(0, chunk_size)))
			chunk_data.append(node.GetChunkData(chunk + Vector2(chunk_size, -chunk_size)))
			chunk_data.append(node.GetChunkData(chunk + Vector2(0, -chunk_size)))
			chunk_data.append(node.GetChunkData(chunk + Vector2(-chunk_size, -chunk_size)))
			
			for chunk_data_value in chunk_data:
				result["E"].merge(chunk_data_value["E"])
				result["P"].merge(chunk_data_value["P"])
				result["O"].merge(chunk_data_value["O"])
			
			world_state = {}
			world_state["P"] = result["P"]
			world_state["E"] = result["E"]
			world_state["O"] = result["O"]
			world_state["T"] = OS.get_system_time_msecs()
			
			for enemy_id in world_state["E"].keys():
				var enemy = world_state["E"][enemy_id].duplicate()
				enemy.erase("health")
				enemy.erase("max_health")
				enemy.erase("defense")
				enemy.erase("state")
				enemy.erase("behaviour")
				enemy.erase("speed")
				enemy.erase("exp")
				enemy.erase("damage_tracker")
				enemy.erase("target")
				enemy.erase("anchor_position")
				enemy.erase("pattern_index")
				enemy.erase("pattern_timer")
				enemy.erase("phase_index")
				enemy.erase("phase_timer")
				enemy.erase("used_phases")
				world_state["E"][enemy_id] = enemy
			
			#We add speed checks here
			for id in node.chunks[chunk]["P"]:
				get_node("/root/Server").SendWorldState(id, world_state)

func CleanObjects(objects):
	for objects_id in objects.keys():
		if OS.get_system_time_msecs() > objects[objects_id]["end_time"]:
			objects.erase(objects_id)
	return objects
