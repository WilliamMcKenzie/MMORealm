extends TextureButton

var achievement
var activated

func Disable():
	activated = false
	$HBoxContainer.modulate = Color(1,1,1,1)
func Activate():
	activated = true
	$HBoxContainer.modulate = Color(158.0/255,158.0/255,158.0/255,1)
func SetAchievement(_achievement):
	achievement = _achievement
	$HBoxContainer/VBoxContainer/Label.text = achievement
	
	var description = ClientData.GetAchievement(achievement).description
	$HBoxContainer/VBoxContainer/Label2.text = description
	
	var gold = ClientData.GetAchievement(achievement).gold
	$HBoxContainer/Gold/Label.text = str(gold)
	
	var ratio = str(GameUI.account_data.statistics[ClientData.GetAchievement(achievement).which]) + "/" + str(ClientData.GetAchievement(achievement).amount)
	$HBoxContainer/Label.text = ratio
	
	var icon = ClientData.GetAchievement(achievement).icon
	$HBoxContainer/Icon.texture = $HBoxContainer/Icon.texture.duplicate()
	$HBoxContainer/Icon.texture.region = Rect2(icon, Vector2(10,10))
