extends TextureButton

func can_drop_data(position, data):
	return true
	
func drop_data(position, data):
	GameUI.get_node("Inventory").DropItem(data)

func _unhandled_input(event):
	if event is InputEventScreenTouch and self.visible == true and Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()+"/YSort/player").left_joystick_output != Vector2.ZERO:
		self.emit_signal("button_down")
