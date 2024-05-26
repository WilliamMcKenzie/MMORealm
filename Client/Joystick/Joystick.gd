extends Area2D

onready var thumb = $Base/Thumb
onready var base = $Base
onready var maxDistance = $CollisionShape2D.shape.radius

var touched = false

func _input(event):
	if event is InputEventScreenTouch:
		var distance = event.position.distance_to(base.global_position)
		if not touched:
			if distance<maxDistance:
				touched = true
		else:
			thumb.position = Vector2()
			touched = false

func _process(delta):
	if touched:
		thumb.global_position = get_global_mouse_position()
		thumb.position = base.position + (thumb.position - base.position).clamped(maxDistance)

func get_velo():
	var res = Vector2(0,0)
	res.x = thumb.position.x/maxDistance
	res.y = thumb.position.y/maxDistance
	return res
