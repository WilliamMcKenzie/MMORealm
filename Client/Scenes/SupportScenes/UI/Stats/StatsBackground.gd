extends TextureButton

func _unhandled_input(event):
	if event is InputEventScreenTouch and self.visible == true and Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()+"/YSort/player").left_joystick_output != Vector2.ZERO:
		self.emit_signal("button_down")
