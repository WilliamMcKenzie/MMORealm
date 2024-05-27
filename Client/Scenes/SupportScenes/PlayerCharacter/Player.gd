extends KinematicBody2D

var projectile = preload("res://Scenes/SupportScenes/Projectiles/Arrow/Arrow.tscn")
var stats = {
	"dexterity": 50,
	"attack": 50,
	"speed": 50
}
var last_shot_time = 0


func _ready():
	pass # Replace with function body.
func _physics_process(delta):
	var motion = Vector2.ZERO

	if(Input.is_action_pressed("up")):
		motion.y -= 1
	if(Input.is_action_pressed("down")):
		motion.y += 1
	if(Input.is_action_pressed("left")):
		motion.x -= 1
	if(Input.is_action_pressed("right")):
		motion.x += 1
	if(Input.is_action_pressed("shoot")):
		var current_time = OS.get_ticks_msec() / 1000.0
		var time_between_shots = 1 / (2 + (6 * (stats.dexterity/2)) / 75.0)
		if current_time - last_shot_time >= time_between_shots:
			shoot_projectile()
			last_shot_time = current_time

	motion = motion.normalized()
	if(Input.is_action_pressed("shoot")):
		$AnimationTree.get("parameters/playback").travel("Attack")
		$AnimationTree.set("parameters/Idle/blend_position", (get_global_mouse_position()-global_position).normalized())
		$AnimationTree.set("parameters/Walk/blend_position", (get_global_mouse_position()-global_position).normalized())
		$AnimationTree.set("parameters/Attack/blend_position", (get_global_mouse_position()-global_position).normalized())
		var current_time = OS.get_ticks_msec() / 1000.0
		var time_between_shots = 1 / (2 + (6 * (stats.dexterity/2)) / 75.0)
		if current_time - last_shot_time >= time_between_shots:
			shoot_projectile()
			last_shot_time = current_time
	elif motion != Vector2.ZERO:
		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.set("parameters/Idle/blend_position", motion)
		$AnimationTree.set("parameters/Walk/blend_position", motion)
	else:
		$AnimationTree.get("parameters/playback").travel("Idle")
	motion = move_and_slide(motion * stats.speed)

func shoot_projectile():
	var projectile_instance = projectile.instance()
	projectile_instance.position = $Axis.global_position
	
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - position).normalized()
	projectile_instance.set_direction(direction)
	projectile_instance.look_at(mouse_position)
	get_parent().add_child(projectile_instance)
