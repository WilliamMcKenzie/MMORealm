extends Node

var sync_clock_counter = 0
var world_state

func _physics_process(delta):
	
	sync_clock_counter += 1
	if sync_clock_counter ==  3:
		sync_clock_counter = 0
		var server = get_node("/root/Server")
		for instance_tree in server.player_instance_tracker.keys():
			if instance_tree[instance_tree.size()-1].split(" ")[0] == "island":
				SendIslandData(instance_tree)
				continue
			var node_string = "/root/Server/Instances/"+server.StringifyInstanceTree(instance_tree)
			if not has_node(node_string):
				continue
			
			var node = get_node(node_string)
			node.object_list = CleanObjects(node.object_list).duplicate(true)
			
			world_state = {
				"P" : node.player_list,
				"E" : node.enemy_list.duplicate(true),
				"O" : node.object_list,
				"T" : OS.get_system_time_msecs()
			}
			
			for enemy_id in world_state["E"].keys():
				var enemy = world_state["E"][enemy_id]
				world_state["E"][enemy_id] = {
					"name": enemy.name,
					"position": enemy.position,
					"effects": enemy.effects,
					"dead": enemy.dead
				}
			
			for id in server.player_instance_tracker[instance_tree]:
				server.SendWorldState(id, world_state, instance_tree)

func SendIslandData(instance_tree):
	var server = get_node("/root/Server")
	var world_state_base = { "E" : {}, "P" : {}, "O" : {}, "T" : OS.get_system_time_msecs() }
	if not has_node("/root/Server/Instances/"+server.StringifyInstanceTree(instance_tree)):
		return
	
	var node = get_node("/root/Server/Instances/"+server.StringifyInstanceTree(instance_tree))
	node.object_list = CleanObjects(node.object_list).duplicate(true)
	
	var chunk_size = 16
	var chunk_offsets = [
		Vector2(chunk_size, 0),
		Vector2(chunk_size, chunk_size),
		Vector2(-chunk_size, 0),
		Vector2(-chunk_size, chunk_size),
		Vector2(0, chunk_size),
		Vector2(chunk_size, -chunk_size),
		Vector2(0, -chunk_size),
		Vector2(-chunk_size, -chunk_size)
	]
	
	for chunk in node.chunks.keys():
		var players = node.chunks[chunk]["P"]
		if players.keys().size() > 0:
			var world_state = world_state_base.duplicate(true)
			var chunk_data = [node.GetChunkData(chunk)]
			for offset in chunk_offsets:
				chunk_data.append(node.GetChunkData(chunk + offset))
			
			for chunk_data_value in chunk_data:
				world_state["E"].merge(chunk_data_value["E"])
				world_state["P"].merge(chunk_data_value["P"])
				world_state["O"].merge(chunk_data_value["O"])
			
			for enemy_id in world_state["E"]:
				var enemy = world_state["E"][enemy_id]
				world_state["E"][enemy_id] = {
					"name": enemy.name,
					"position": enemy.position,
					"effects": enemy.effects,
					"dead": enemy.dead
				}
			
			for id in players:
				server.SendWorldState(id, world_state, instance_tree)

func CleanObjects(objects):
	for objects_id in objects.keys():
		if objects[objects_id].has("end_time") and OS.get_system_time_msecs() > objects[objects_id]["end_time"]:
			objects.erase(objects_id)
	return objects
