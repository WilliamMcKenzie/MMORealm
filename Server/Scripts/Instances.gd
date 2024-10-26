extends Node

var chunk_sensors = {}
var free_position = Vector2(1500*8,0)
func GetFreeInstancePosition():
	free_position += Vector2(1500*8,0)
	get_node("/root/Server").instance_positions[free_position] = true
	return free_position

func AddInstanceToTracker(instance_tree, instance_id):
	var new_tree = instance_tree.duplicate(true)
	new_tree.append(instance_id)
	get_node("/root/Server").player_instance_tracker[new_tree] = []
