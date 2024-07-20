extends Node2D

func _ready():
	z_index = 2
	
	var node = get_node("Label")
	var tween = get_node("Tween")
	tween.interpolate_property(node, "rect_position", node.rect_position, Vector2(0, -30)+node.rect_position, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
