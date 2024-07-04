extends CanvasLayer

func _ready():
	var timer = Timer.new()
	timer.wait_time = 3
	timer.one_shot = true
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	queue_free()

func SetClass(classname):
	var class_data = ClientData.GetCharacter(classname)
	$Container/Character.SetCharacterClass(classname)
	$Container/HBoxContainer/TextureRect.texture.region = Rect2(class_data.icon, Vector2(10,10))
	$Container/HBoxContainer/Class.text = classname
	$Container/HBoxContainer/Class.add_color_override("font_color", class_data.color)
	
