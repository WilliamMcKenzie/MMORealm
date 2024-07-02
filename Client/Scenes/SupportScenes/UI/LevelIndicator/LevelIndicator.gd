extends Node2D

func _ready():
	var level_node = get_node("LevelIndicator")
	var level_tween = get_node("Tween")
	level_tween.interpolate_property(level_node, "rect_position", level_node.rect_position, Vector2(0, -30)+level_node.rect_position, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	level_tween.start()
