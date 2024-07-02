extends Node2D

func _ready():
	var damage_node = get_node("DamageLabel")
	var damage_tween = get_node("Tween")
	damage_tween.interpolate_property(damage_node, "rect_position", damage_node.rect_position, Vector2(0, -30)+damage_node.rect_position, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	damage_tween.start()
