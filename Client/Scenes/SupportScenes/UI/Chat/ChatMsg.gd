extends Label

func _ready():
	var timer = Timer.new()
	timer.wait_time = 6
	timer.one_shot = true
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	
	$AnimationPlayer.play("Remove")
	
	timer.wait_time = 0.5
	timer.one_shot = true
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	
	queue_free()
