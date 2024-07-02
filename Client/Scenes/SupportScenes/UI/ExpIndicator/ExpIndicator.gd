extends Node2D

func _ready():
	var exp_node = get_node("ExpLabel")
	var exp_tween = get_node("Tween")
	exp_tween.interpolate_property(exp_node, "rect_position", exp_node.rect_position, Vector2(0, -30)+exp_node.rect_position, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	exp_tween.start()
