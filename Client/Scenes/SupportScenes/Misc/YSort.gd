extends YSort

var npc = preload("res://Scenes/SupportScenes/Npcs/BasicEnemy.tscn")

var clock_sync_timer = 0
onready var target = get_child_count()
func _physics_process(delta):
	clock_sync_timer += 1
	if clock_sync_timer%20 == 0 and get_child_count() < target:
		add_child(npc.instance())
	if clock_sync_timer >= 60:
		var active_nodes = 0
		for enemy_node in get_children():
			if enemy_node.is_active:
				active_nodes += 1
		if active_nodes >= get_child_count()*0.75:
			target = get_child_count()*1.3
