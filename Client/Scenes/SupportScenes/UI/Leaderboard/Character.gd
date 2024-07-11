extends PanelContainer

func SetData(character, index):
	var data = character.data
	var reputation = character.reputation
	var username = character.name
	
	SetCharacterSprite(character.data)
	
	$MarginContainer/Container/Data/Name.text = str(index) + ". " + username
	$MarginContainer/Container/Data/HBoxContainer/Reputation.text = str(reputation)
	
	for slot in character.data.gear.keys():
		if character.data.gear[slot]:
			var rect_coords = ClientData.GetItem(character.data.gear[slot].item).path[3]*10
			var rect_dimensions = Vector2(10,10)
			get_node("MarginContainer/Container/Visuals/Gear/"+slot).texture.region = Rect2(rect_coords, rect_dimensions)
		else:
			get_node("MarginContainer/Container/Visuals/Gear/"+slot).texture.region = Rect2(Vector2(200,200), Vector2(0,0))
func SetCharacterSprite(character):
	var CharacterSpriteEle = $MarginContainer/Container/Visuals/CharacterContainer/Sprite
	var gear = {}
	for slot in character.gear.keys():
		if character.gear[slot]:
			gear[slot] = ClientData.GetItem(character.gear[slot].item)
	
	CharacterSpriteEle.SetCharacterClass(character.class)
	if character.gear.has("weapon") and character.gear.weapon != null: 
		CharacterSpriteEle.SetCharacterWeapon(ClientData.GetItem(character.gear.weapon.item).type)
	SetSpriteData(CharacterSpriteEle, ClientData.GetCharacter(character.class).path)
	CharacterSpriteEle.ColorGear(gear)

func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0]) 
	sprite.texture = spriteTexture
	sprite.hframes = path[1]
	sprite.vframes = path[2]
	sprite.frame_coords = path[3]
