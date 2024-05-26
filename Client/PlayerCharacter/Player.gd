extends KinematicBody2D


var facingDirection = "right"

func _ready():
	pass # Replace with function body.
func _physics_process(delta):
	var motion = Vector2()

	if(Input.is_action_pressed("up")):
		motion.y -= 1
	if(Input.is_action_pressed("down")):
		motion.y += 1
	if(Input.is_action_pressed("left")):
		motion.x -= 1
	if(Input.is_action_pressed("right")):
		motion.x += 1
	motion = motion.normalized()
	$AnimationTree.set("parameters/Idle/blend_position", motion)
	
	motion = move_and_slide(motion * 50)
func _process(delta):
	var velocity = $UI/Joystick.get_velo()
	move_and_slide(velocity*500, Vector2.UP)
