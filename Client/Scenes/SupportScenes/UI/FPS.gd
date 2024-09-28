extends Label

func _physics_process(delta):
	set_text("FPS " + str(Engine.get_frames_per_second()))
