extends TextureButton

export var setting_default = 0
func SetSettings(title, description, default):
	name = title
	setting_default = default
	$HBoxContainer/VBoxContainer/Label.text = title
	$HBoxContainer/VBoxContainer/Label2.text = description
	
	var checkbox = get_node_or_null("HBoxContainer/InputContainer/CheckBox")
	var input = get_node_or_null("HBoxContainer/InputContainer/PanelContainer/MarginContainer/Input")
	var slider = get_node_or_null("HBoxContainer/InputContainer/HSlider")
	var keybind = get_node_or_null("HBoxContainer/InputContainer/PanelContainer/MarginContainer/Label")
	if checkbox:
		checkbox.pressed = default
	if slider:
		slider.value = default
	if input:
		input.text = str(default)
	if keybind:
		keybind.text = OS.get_scancode_string(default)
		current_key = default
	
	if keybind and str(OS.get_model_name()) != 'GenericDevice':
		self.queue_free()

func _on_CheckBox_pressed():
	var checkbox = $HBoxContainer/InputContainer/CheckBox
	GameUI.get_node("Settings").ChangeValue(name, checkbox.pressed)

func _on_Input_text_entered(new_text):
	var input = $HBoxContainer/InputContainer/PanelContainer/MarginContainer/Input
	if float(new_text):
		input.text = str(float(new_text))
	else:
		input.text = str(float(setting_default))
	GameUI.get_node("Settings").ChangeValue(name, float(input.text))

var current_key = ""
var listening = false

func _on_Trigger_pressed():
	listening = true
	$HBoxContainer/InputContainer/PanelContainer/MarginContainer/Label.text = "Listening for key..."

func _input(event):
	if listening and event is InputEventKey and event.pressed:
		current_key = event.scancode
		$HBoxContainer/InputContainer/PanelContainer/MarginContainer/Label.text = OS.get_scancode_string(current_key)
		GameUI.get_node("Settings").ChangeValue(name, current_key)
		listening = false

func _on_Trigger_focus_exited():
	listening = false
	$HBoxContainer/InputContainer/PanelContainer/MarginContainer/Label.text = OS.get_scancode_string(current_key)
