extends Node

func AddInstanceToTracker(instance_tree, instance_id):
	var new_tree = instance_tree.duplicate(true)
	new_tree.append(instance_id)
	get_node("/root/Server").player_instance_tracker[new_tree] = []
