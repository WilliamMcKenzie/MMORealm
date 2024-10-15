extends TextureButton

export var setting_default = 0
func SetSettings(title, description, default):
	name = title
	setting_default = default
	$HBoxContainer/VBoxContainer/Label.text = title
	$HBoxContainer/VBoxContainer/Label2.text = description
	
	var checkbox = $HBoxContainer/InputContainer/CheckBox
	var input = $HBoxContainer/InputContainer/PanelContainer/MarginContainer/Input
	var slider = $HBoxContainer/InputContainer/HSlider
	if checkbox:
		checkbox.pressed = default
	if slider:
		slider.value = default
	if input:
		input.text = str(default)

func _on_CheckBox_pressed():
	var checkbox = $HBoxContainer/InputContainer/CheckBox
	GameUI.get_node("Settings").ChangeValue(name, checkbox.pressed)

func _on_Input_text_entered(new_text):
	var input = $HBoxContainer/InputContainer/PanelContainer/MarginContainer/Input
	if int(new_text):
		input.text = str(int(new_text))
	else:
		input.text = str(int(setting_default))
	GameUI.get_node("Settings").ChangeValue(name, int(input.text))
