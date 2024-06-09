extends Node2D

enum {
	IDLE,
	ENGAGE
}

var current_state = IDLE
onready var player_detection_zone = $Ai/PlayerDetection
onready var hitbox_zone = $Hitbox
var target = position
var velocity
func DealDamage(damage):
	get_parent().get_parent().get_parent().enemy_list[name]["Health"] -= damage
	if get_parent().get_parent().get_parent().enemy_list[name]["Health"] < 1:
		queue_free()

func _physics_process(delta):
	if current_state == ENGAGE:
		
		
		var y_move = -sin(position.angle_to_point(target)) * 0.2
		var x_move = -cos(position.angle_to_point(target)) * 0.2
		velocity = Vector2(x_move, y_move)
		print(target)
		
		position += velocity
		if get_parent().get_parent().get_parent().enemy_list.has(name):
			get_parent().get_parent().get_parent().enemy_list[name]["Position"] = position
		
		if (target - position).length() >= 10:
			target = position + Vector2(rand_range(0,100),rand_range(0,100))

func _on_Hitbox_area_entered(area):
	if "player_id" in area.get_parent():
		DealDamage(area.get_parent().damage)
