extends Node2D

enum {
	IDLE,
	ENGAGE
}

var current_state = ENGAGE

var wander_range = 15
var initial_position
var target
var velocity

func _ready():
	initial_position = position
	target = position
	

func DealDamage(damage, player_id):
	get_parent().get_parent().get_parent().enemy_list[name]["Health"] -= damage
	if get_parent().get_parent().get_parent().enemy_list[name]["Health"] < 1:
		queue_free()

func ShootProjectile():
	var projectile_data = {
		"Damage":0,
		"Position":position,
		"Projectile":"Arrow",
		"TargetPosition":target,
		"Direction":(target - position).normalized(),
		"TileRange":1
	}
	get_parent().get_parent().get_parent().SpawnEnemyProjectile(projectile_data, name)

var shot_cooldown = {
	"Arrow" : [0, 0.5]
}
func EnemyCombat():
	if OS.get_system_time_secs() - shot_cooldown["Arrow"][0] > shot_cooldown["Arrow"][1]:
		shot_cooldown["Arrow"][0] = OS.get_system_time_secs()
		ShootProjectile()

<<<<<<< Updated upstream
func movement(delta):
		if current_state == ENGAGE:
		
			EnemyCombat()
			
			var y_move = -sin(position.angle_to_point(target)) * delta * 5
			var x_move = -cos(position.angle_to_point(target)) * delta * 5
			velocity = Vector2(x_move, y_move)
			
			position += velocity
			if get_parent().get_parent().get_parent().enemy_list.has(name):
				get_parent().get_parent().get_parent().enemy_list[name]["Position"] = position - get_parent().get_parent().get_parent().position

			if (target - position).length() <= 5:
				if (initial_position-position).length() >= wander_range:
					target = initial_position
				else:
					target = position + Vector2(rand_range(-7,7),rand_range(-7,7))
=======
func movement(NPC_tick):
	if current_state == ENGAGE:
		
		EnemyCombat()
		
		var y_move = -sin(position.angle_to_point(target)) * 0.2 * NPC_tick
		var x_move = -cos(position.angle_to_point(target)) * 0.2 * NPC_tick
		velocity = Vector2(x_move, y_move)
		
		position += velocity
		if get_parent().get_parent().get_parent().enemy_list.has(name):
			get_parent().get_parent().get_parent().enemy_list[name]["Position"] = position

		if (target - position).length() <= 2:
			if (initial_position-position).length() >= wander_range:
				target = initial_position
			else:
				target = position + Vector2(rand_range(-7,7),rand_range(-7,7))

>>>>>>> Stashed changes
func _on_PlayerDetection_area_entered(area):
	pass
	
func _on_PlayerDetection_area_exited(area):
	pass
