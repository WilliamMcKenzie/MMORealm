extends TextureButton

var category
var activated

func Disable():
	activated = false
	$HBoxContainer.modulate = Color(1,1,1,100.0/255)
func Activate():
	activated = true
	$HBoxContainer.modulate = Color(1,1,1,1)
func SetCategory(_category):
	category = _category
	$HBoxContainer/Label.text = category
	
	var icon = ClientData.achievement_catagories[category].icon
	$HBoxContainer/Icon.texture = $HBoxContainer/Icon.texture.duplicate()
	$HBoxContainer/Icon.texture.region = Rect2(icon, Vector2(10,10))
