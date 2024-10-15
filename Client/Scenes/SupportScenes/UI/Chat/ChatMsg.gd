extends HBoxContainer

func _ready():
	yield(get_tree().create_timer(10), "timeout")
	$AnimationPlayer.play("Remove")
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()
