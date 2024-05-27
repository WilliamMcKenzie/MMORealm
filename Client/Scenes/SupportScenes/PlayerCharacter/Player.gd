extends KinematicBody2D

var projectile = preload("res://Scenes/SupportScenes/Projectiles/Arrow/Arrow.tscn")
var level = 1
var curStats = {}
var stats = {
	"health" : 100,
	"mana" : 100,
	"vitality" : 20,
	"armor" : 0,
	"dexterity": 20,
	"attack": 20,
	"speed": 20
}
var gear = {
	"weapon" : {
		
	},
	"ability" : {
		
	},
	"armor" : {
		
	},
	"ring" : {
		
	}
}

var last_shot_time = 0
onready var animationTree = $AnimationTree


func _ready():
	pass
func _physics_process(delta):
	var motion = Vector2.ZERO

	if(Input.is_action_pressed("ui_up")):
		motion.y -= 1
	if(Input.is_action_pressed("ui_down")):
		motion.y += 1
	if(Input.is_action_pressed("ui_left")):
		motion.x -= 1
	if(Input.is_action_pressed("ui_right")):
		motion.x += 1
	if(Input.is_action_pressed("shoot")):
		var current_time = OS.get_ticks_msec() / 1000.0
		var time_between_shots = 1 / (2 + (6 * (stats.dexterity/2)) / 75.0)
		if current_time - last_shot_time >= time_between_shots:
			shoot_projectile()
			last_shot_time = current_time
	motion = motion.normalized()
	
	#Animations
	if(Input.is_action_pressed("shoot")):
		animationTree.get("parameters/playback").travel("Attack")
		animationTree.set("parameters/Idle/blend_position", (get_global_mouse_position()-global_position).normalized())
		animationTree.set("parameters/Walk/blend_position", (get_global_mouse_position()-global_position).normalized())
		animationTree.set("parameters/Attack/blend_position", (get_global_mouse_position()-global_position).normalized())
	elif motion != Vector2.ZERO:
		animationTree.get("parameters/playback").travel("Walk")
		animationTree.set("parameters/Idle/blend_position", motion)
		animationTree.set("parameters/Walk/blend_position", motion)
	else:
		animationTree.get("parameters/playback").travel("Idle")
	motion = move_and_slide(motion * stats.speed)

func shoot_projectile():
	var projectile_instance = projectile.instance()
	projectile_instance.position = $Axis.global_position
	
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - position).normalized()
	projectile_instance.set_direction(direction)
	projectile_instance.look_at(mouse_position)
	get_parent().add_child(projectile_instance)
