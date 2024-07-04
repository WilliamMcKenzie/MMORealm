extends VBoxContainer

var classname

func SetCharacter(_classname):
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
