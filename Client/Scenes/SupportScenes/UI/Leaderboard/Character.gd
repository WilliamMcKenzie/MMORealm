extends PanelContainer

func SetData(character, index):
	var data = character.data
	var reputation = character.reputation
	var username = character.name
	var gear = data.gear.duplicate()
	
	$MarginContainer/Container/Data/Name.text = str(index) + ". " + username
	$MarginContainer/Container/Data/HBoxContainer/Reputation.text = str(reputation)
	
	for slot in gear.keys():
		get_node("MarginContainer/Container/Visuals/Gear/"+slot).texture = get_node("MarginContainer/Container/Visuals/Gear/"+slot).texture.duplicate()
		var texture = get_node("MarginContainer/Container/Visuals/Gear/"+slot).texture
		
		if gear[slot]:
			var rect_coords = ClientData.GetItem(character.data.gear[slot].item).path[3]*10
			var rect_dimensions = Vector2(10,10)
			texture.region = Rect2(rect_coords, rect_dimensions)
		else:
			texture.region = Rect2(Vector2(200,200), Vector2(0,0))
	SetCharacterSprite(character.data, gear)

func SetCharacterSprite(character, gear):
	var CharacterSpriteEle = $MarginContainer/Container/Visuals/CharacterContainer/Sprite
	CharacterSpriteEle.material = CharacterSpriteEle.material.duplicate()
	var weapon_type = "Sword"
	
	var temp = gear.duplicate()
	for slot in temp:
		if gear[slot] == null:
			gear.erase(slot)
		else:
			gear[slot] = ClientData.GetItem(gear[slot].item)
	
	CharacterSpriteEle.SetCharacterClass(character.class)
	SetSpriteData(CharacterSpriteEle, ClientData.GetCharacter(character.class).path)
	CharacterSpriteEle.ColorGear(gear, character.class)
	if gear.has("weapon"):
		CharacterSpriteEle.SetCharacterWeapon(gear["weapon"].type)

func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0]) 
	sprite.texture = spriteTexture
	sprite.hframes = path[1]
	sprite.vframes = path[2]
	sprite.frame_coords = path[3]
