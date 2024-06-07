extends Node2D

enum {
	IDLE,
	ENGAGE
}

var current_state = IDLE
onready var player_detection_zone = $Ai/PlayerDetection
onready var hitbox_zone = $Hitbox

func DealDamage(damage):
	get_parent().get_parent().get_parent().enemy_list[name]["Health"] -= damage
	if get_parent().get_parent().get_parent().enemy_list[name]["Health"] < 1:
		queue_free()

func _physics_process(delta):
	if current_state == ENGAGE:
		position += Vector2(0.1, 0.1)
		if get_parent().get_parent().get_parent().enemy_list.has(name):
			get_parent().get_parent().get_parent().enemy_list[name]["Position"] = position
			get_node("/root/Server").enemies_state_collection[name]["P"] = position

func _on_PlayerDetection_area_entered(body):
	if body.get_parent().name == "PlayerCharacter":
		current_state = ENGAGE
		print("Switching...")
		print(current_state)

func _on_PlayerDetection_area_exited(body):
	if body.get_parent().name == "PlayerCharacter":
		current_state = IDLE
		print("Switching...")
		print(current_state)

func _on_Hitbox_area_entered(area):
	if "player_id" in area.get_parent():
		DealDamage(area.get_parent().damage)

