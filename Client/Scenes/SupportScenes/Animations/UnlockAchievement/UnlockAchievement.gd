extends CanvasLayer

func _ready():
	var timer = Timer.new()
	timer.wait_time = 3
	timer.one_shot = true
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	queue_free()

func SetData(achievement_name):
	var achievement_data = ClientData.GetAchievement(achievement_name)
	get_node("Container/Difficulty/easy").visible = false
	get_node("Container/Difficulty/medium").visible = false
	get_node("Container/Difficulty/hard").visible = false
	get_node("Container/Difficulty/"+achievement_data.difficulty).visible = true
	
	$Container/HBoxContainer/TextureRect.texture.region = Rect2(achievement_data.icon, Vector2(10,10))
	$Container/HBoxContainer/Achievement.text = achievement_name
