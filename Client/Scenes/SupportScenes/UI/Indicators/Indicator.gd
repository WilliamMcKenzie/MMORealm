extends Node2D

func _ready():
	z_index = 190
	
	var node = get_node("Label")
	var tween = get_node("Tween")
	tween.interpolate_property(node, "rect_position", node.rect_position, Vector2(0, -30)+node.rect_position, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(get_tree().create_timer(1), "timeout")
	
	queue_free()
