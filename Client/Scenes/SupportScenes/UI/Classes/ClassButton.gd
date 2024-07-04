extends TextureButton

var character
var activated

func Disable():
	activated = false
	$Icon.modulate = Color(1,1,1,100.0/255)
func Activate():
	activated = true
	$Icon.modulate = Color(1,1,1,1)
func SetClass(_character):
	character = _character
	var icon = ClientData.GetCharacter(character).icon
	$Icon.texture = $Icon.texture.duplicate()
	$Icon.texture.region = Rect2(icon, Vector2(10,10))
