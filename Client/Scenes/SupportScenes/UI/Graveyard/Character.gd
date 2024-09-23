extends PanelContainer

var cost = 9999999
var index = 0

func PermaDisable():
	if get_node("MarginContainer/Container/PanelContainer").visible == true:
		get_node("MarginContainer/Container/PanelContainer").visible = false
		get_node("MarginContainer/Container/Permadead").visible = true
func Activate():
	get_node("MarginContainer/Container/PanelContainer/MarginContainer/ReviveContainer/Revive").disabled = false
	get_node("MarginContainer/Container/PanelContainer").modulate = Color(1,1,1)
func Deactivate():
	get_node("MarginContainer/Container/PanelContainer/MarginContainer/ReviveContainer/Revive").disabled = true
	get_node("MarginContainer/Container/PanelContainer").modulate = Color(199.0/255,199.0/255,199.0/255)

func _physics_process(delta):
	var home = get_node("/root/SceneHandler/Home")
	if home.get_node("Graveyard").visible and GameUI.account_data:
		var not_enough_slots = home.get_node("CharacterSelection").characters.size() >= home.get_node("CharacterSelection").character_slots
		var not_enough_gold = home.gold < cost
		var permadead = cost == 9999999
		
		if permadead:
			PermaDisable()
		elif not_enough_gold or not_enough_slots:
			Deactivate()
		else:
			Activate()

func SetData(character, index):
	var reputation = character.level
	var gear = character.gear.duplicate()
	cost = character.revive_cost
	$MarginContainer/Container/PanelContainer/MarginContainer/ReviveContainer/Revive.text = "Revive " + str(cost)
	$MarginContainer/Container/Data/HBoxContainer/Reputation.text = str(reputation)
	
	for slot in gear.keys():
		get_node("MarginContainer/Container/Visuals/Gear/"+slot).texture = get_node("MarginContainer/Container/Visuals/Gear/"+slot).texture.duplicate()
		var texture = get_node("MarginContainer/Container/Visuals/Gear/"+slot).texture
		
		if gear[slot]:
			var rect_coords = ClientData.GetItem(character.gear[slot].item).path[3]*10
			var rect_dimensions = Vector2(10,10)
			texture.region = Rect2(rect_coords, rect_dimensions)
		else:
			texture.region = Rect2(Vector2(200,200), Vector2(0,0))
	SetCharacterSprite(character, gear)

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

func _on_Revive_pressed():
	Gateway.index = index
	var home_node = get_node("/root/SceneHandler/Home")
	var email = home_node.email
	var password = home_node.password
	
	Gateway.GatewayRequest(email, password, 7)
