extends Label

func _physics_process(delta):
	if Settings.show_fps:
		set_text("FPS " + str(Engine.get_frames_per_second()))
	else:
		set_text("")
