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
	var achievement_data = ClientData.GetAchievement(_achievement)
	achievement = _achievement
	$HBoxContainer/VBoxContainer/Label.text = achievement
	
	var description = ClientData.GetAchievement(achievement).description
	$HBoxContainer/VBoxContainer/Label2.text = description
	
	var gold = ClientData.GetAchievement(achievement).gold
	$HBoxContainer/Gold/Label.text = str(gold)
	
	if achievement_data.which == "classes_unlocked" and achievement_data.has("classes"):
		var total = 0
		for _class in achievement_data.classes:
			if GameUI.account_data.classes.has(_class) and GameUI.account_data.classes[_class]:
				total += 1
		var ratio = str(total) + "/" + str(ClientData.GetAchievement(achievement).amount)
		$HBoxContainer/Label.text = ratio
	elif achievement_data.which == "enemies_killed" and achievement_data.has("enemies"):
		var total = 0
		for enemy in achievement_data.enemies:
			if GameUI.account_data.statistics.has(enemy):
				total += GameUI.account_data.statistics[enemy]
		var ratio = str(total) + "/" + str(ClientData.GetAchievement(achievement).amount)
		$HBoxContainer/Label.text = ratio
	elif GameUI.account_data.statistics.has(achievement_data.which):
		var ratio = str(GameUI.account_data.statistics[ClientData.GetAchievement(achievement).which]) + "/" + str(ClientData.GetAchievement(achievement).amount)
		$HBoxContainer/Label.text = ratio
	else:
		$HBoxContainer/Label.text = "0/" + str(ClientData.GetAchievement(achievement).amount)
	
	var icon = ClientData.GetAchievement(achievement).icon
	$HBoxContainer/Icon.texture = $HBoxContainer/Icon.texture.duplicate()
	$HBoxContainer/Icon.texture.region = Rect2(icon, Vector2(10,10))
