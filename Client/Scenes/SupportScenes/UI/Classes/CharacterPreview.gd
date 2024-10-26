extends VBoxContainer

var classname

func SetAchievement(_achievement):
	var achievement_data = ClientData.GetAchievement(_achievement)
	var bar = $ProgressBar
	
	if achievement_data.which == "enemies_killed" and achievement_data.has("enemies"):
		var total = 0
		for enemy in achievement_data.enemies:
			if GameUI.last_character.statistics.has(enemy):
				total += GameUI.last_character.statistics[enemy]
		bar.max_value = ClientData.GetAchievement(_achievement).amount
		bar.value = total
	elif GameUI.last_character.statistics.has(achievement_data.which):
		bar.max_value = ClientData.GetAchievement(_achievement).amount
		bar.value = GameUI.last_character.statistics[ClientData.GetAchievement(_achievement).which]
	else:
		bar.max_value = ClientData.GetAchievement(_achievement).amount
		bar.value = 0

func SetCharacter(_classname):
	SetAchievement("Unlock " + _classname)
	
	classname = _classname
	var class_data = ClientData.GetCharacter(classname)
	$Description.text = class_data.teaser
	
	SetCharacterSprite(class_data, classname, {}, $TextureRect/Character)
	if GameUI.account_data.classes[classname]:
		$TextureRect/Character.modulate = Color(184.0/255,184.0/255,184.0/255,1)
		$ClassName.modulate = Color(184.0/255,184.0/255,184.0/255,1)
		
		$ClassName/Class.text = _classname
		$ClassName/Class.add_color_override("font_color", class_data.color)
		$ClassName/TextureRect.visible = true
		$ClassName/TextureRect.texture = $ClassName/TextureRect.texture.duplicate()
		$ClassName/TextureRect.texture.region = Rect2(class_data.icon, Vector2(10,10))
		
		$Description.text = class_data.teaser.replace("Discover", "Unlock")
		
func SetCharacterSprite(character, classname, gear, ele):
	var CharacterSpriteEle = ele
	
	CharacterSpriteEle.SetCharacterClass(classname)
	SetSpriteData(CharacterSpriteEle, character.path)
	CharacterSpriteEle.ColorGear(gear)

func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0]) 
	sprite.texture = spriteTexture
	sprite.hframes = path[1]
	sprite.vframes = path[2]
	sprite.frame_coords = path[3]
