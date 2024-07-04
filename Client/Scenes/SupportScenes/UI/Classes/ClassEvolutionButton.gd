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
	character = ClientData.GetCharacter(_character)
	var icon = Vector2(40, 210)
	if character.ascension_stones <= GameUI.last_character.ascension_stones:
		icon = Vector2(50, 210)
	
	$Icon.texture = $Icon.texture.duplicate()
	$Icon.texture.region = Rect2(icon, Vector2(10,10))

