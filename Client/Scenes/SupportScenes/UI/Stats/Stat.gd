extends HBoxContainer
var stat = "health"

func _ready():
	$ButtonContainer/MarginContainer/TextureButton.connect("button_down", self, "IncreaseStat")

func SetStatType(_stat):
	stat = _stat
	var icon_map = {
		"health" : Rect2(Vector2(0,200),Vector2(9,9)),
		"attack" : Rect2(Vector2(10,200),Vector2(10,10)),
		"defense" : Rect2(Vector2(20,200),Vector2(10,10)),
		"speed" : Rect2(Vector2(30,200),Vector2(10,10)),
		"dexterity" : Rect2(Vector2(40,200),Vector2(10,10)),
		"vitality" : Rect2(Vector2(50,200),Vector2(10,10)),
	}
	
	$VBoxContainer/HBoxContainer2/PanelContainer/MarginContainer/TextureRect.texture = $VBoxContainer/HBoxContainer2/PanelContainer/MarginContainer/TextureRect.texture.duplicate()
	$VBoxContainer/HBoxContainer2/PanelContainer/MarginContainer/TextureRect.texture.region = icon_map[stat]

func Activate():
	$ButtonContainer.visible = true
func DeActivate():
	$ButtonContainer.visible = false

func IncreaseStat():
	Server.IncreaseStat(stat)
