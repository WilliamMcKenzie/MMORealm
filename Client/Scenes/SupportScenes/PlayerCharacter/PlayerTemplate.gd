extends KinematicBody2D

onready var animationTree = $AnimationTree

func MovePlayer(new_position, animation):
	set_position(new_position)
	
	if animation is Dictionary and animation.has("A") and animation.has("C"):
		var animationType = animation["A"]
		var animationDirection = animation["C"]
		
		animationTree.get("parameters/playback").travel(animationType)
		animationTree.set("parameters/Idle/blend_position", animationDirection)
		animationTree.set("parameters/Walk/blend_position", animationDirection)
		animationTree.set("parameters/Attack/blend_position", animationDirection)
