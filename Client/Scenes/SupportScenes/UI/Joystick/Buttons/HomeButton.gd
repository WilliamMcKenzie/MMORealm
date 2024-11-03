extends TouchScreenButton

var blank_button = preload("res://Assets/ui/blank_button.png")
var helmet_button = preload("res://Assets/ui/home_button.png")

func _physics_process(delta):
	if Settings.buttons:
		visible = true
	else:
		visible = false

func _on_TextureButton_pressed():
	emit_signal("pressed")

func _on_TextureButton_mouse_entered():
	normal = blank_button
	$R.visible = true
func _on_TextureButton_mouse_exited():
	normal = helmet_button
	$R.visible = false
