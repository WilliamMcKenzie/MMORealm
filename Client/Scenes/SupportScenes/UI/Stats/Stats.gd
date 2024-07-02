extends CanvasLayer

var inspecting_item = null

func _ready():
	$StatsBackground.connect("button_down", self, "ToggleStats")

func InspectItem(_item):
	if inspecting_item == _item:
		DeInspectItem(_item)
		return
	
	var item = ClientData.GetItem(_item.item)
	
	var animator = $InventoryAnimations
	animator.play("InspectItem")
	inspecting_item = _item
	$InspectItem.visible = true
		
	$InspectItem/MarginContainer/VBoxContainer/ItemName.text = item.name
	$InspectItem/MarginContainer/VBoxContainer/ItemSpriteContainer/ItemSprite.texture.region = Rect2(item.path[3]*10, Vector2(10, 10))
	$InspectItem/MarginContainer/VBoxContainer/ItemDescription.text = item.description + "\n"

	$InspectItem/MarginContainer/VBoxContainer/ItemStats/Tier.text = "Tier: " + item.tier
	if item.has("damage"):
		$InspectItem/MarginContainer/VBoxContainer/ItemStats/Damage.text = "Damage: " + str(item.damage[0]) + "-" + str(item.damage[1])
		$InspectItem/MarginContainer/VBoxContainer/ItemStats/Damage.visible = true
		$InspectItem/MarginContainer/VBoxContainer/ItemStats/Rof.text = "Rate of Fire: " + str(item.rof) + "%"
		$InspectItem/MarginContainer/VBoxContainer/ItemStats/Rof.visible = true
	else:
		$InspectItem/MarginContainer/VBoxContainer/ItemStats/Damage.visible = false
		$InspectItem/MarginContainer/VBoxContainer/ItemStats/Rof.visible = false
	
	var stats_node = $InspectItem/MarginContainer/VBoxContainer/ItemStats
	var item_stats = item.stats
	
	var health_node = stats_node.get_node("HBoxContainer/Stats1/Health")
	var attack_node = stats_node.get_node("HBoxContainer/Stats2/Attack")
	var defense_node = stats_node.get_node("HBoxContainer/Stats1/Defense")
	var speed_node = stats_node.get_node("HBoxContainer/Stats2/Speed")
	var dexterity_node = stats_node.get_node("HBoxContainer/Stats1/Dexterity")
	var vitality_node = stats_node.get_node("HBoxContainer/Stats2/Vitality")
	
	var stats = {
		"health" : health_node,
		"attack" : attack_node,
		"defense" : defense_node,
		"speed" : speed_node,
		"dexterity" : dexterity_node,
		"vitality" : vitality_node
	}
	
	for stat in stats.keys():
		var node = stats[stat]
		var capitalized_stat = stat.substr(0, 1).to_upper() + stat.substr(1).to_lower()
		
		if item_stats.has(stat):
			if item_stats[stat] > 0:
				node.text = capitalized_stat + ": +" + str(item_stats[stat])
			else:
				node.text = capitalized_stat + ": " + str(item_stats[stat])
			node.visible = true
		else:
			node.visible = false
func DeInspectItem(item):
	if inspecting_item == item:
		var animator = $InventoryAnimations
		animator.play("DeInspectItem")
		inspecting_item = null
		
		var timer = Timer.new()
		timer.wait_time = 0.2
		timer.one_shot = true
		add_child(timer)
		timer.start()
		yield(timer, "timeout")
		
		$InspectItem.visible = false

func ToggleStats():
	get_parent().ToggleStats()

func OpenStats(character):
	if not character:
		return
	
	var stats_tween = $StatsTween
	var stats_element = $StatsContainer
	
	SetStats(character)
	
	stats_tween.interpolate_property(stats_element, "rect_position", stats_element.rect_position, Vector2(260, 0)+stats_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	stats_tween.start()
	
	var timer = Timer.new()
	timer.wait_time = 0.4
	timer.one_shot = true
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	
	$StatsBackground.visible = true

func CloseStats():
	var stats_tween = $StatsTween
	var stats_element = $StatsContainer
	
	stats_tween.interpolate_property(stats_element, "rect_position", stats_element.rect_position, Vector2(-260, 0)+stats_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	stats_tween.start()
	$StatsBackground.visible = false

func SetName(name):
	$StatsContainer/PanelContainer2/MarginContainer/ResizeContainer/CharacterInfo/Name.text = name

func SetStats(character):
	var stats_node = $StatsContainer/PanelContainer2/MarginContainer/ResizeContainer
	
	var base_stats = character.stats
	var total_stats = character.stats.duplicate(true)
	var gear = {}
	
	var info = "Level " + str(character.level) + " " + character.class
	$StatsContainer/PanelContainer2/MarginContainer/ResizeContainer/CharacterInfo/Info.text = info
	
	for slot in character.gear.keys():
		if character.gear[slot] != null:
			$StatsContainer/PanelContainer2/MarginContainer/ResizeContainer/CharacterInfo/Gear.get_node(slot).SetItem(character.gear[slot], 1)
			gear[slot] = ClientData.GetItem(int(character.gear[slot].item))
			for stat in gear[slot].stats.keys():
				total_stats[stat] += gear[slot].stats[stat]
		else:
			$StatsContainer/PanelContainer2/MarginContainer/ResizeContainer/CharacterInfo/Gear.get_node(slot).SetItem(null, 1)
	
	SetCharacterSprite(character, gear)
	
	var health_node = stats_node.get_node("HBoxContainer/Stats1/Health")
	var attack_node = stats_node.get_node("HBoxContainer/Stats2/Attack")
	var defense_node = stats_node.get_node("HBoxContainer/Stats1/Defense")
	var speed_node = stats_node.get_node("HBoxContainer/Stats2/Speed")
	var dexterity_node = stats_node.get_node("HBoxContainer/Stats1/Dexterity")
	var vitality_node = stats_node.get_node("HBoxContainer/Stats2/Vitality")
	
	var stats = {
		"health" : { "node" : health_node, "abbreviation" : "Hp: ", "high" : 900, "step" : 100},
		"attack" : { "node" : attack_node, "abbreviation" : "Atk: ", "high" : 75, "step" : 5},
		"defense" : { "node" : defense_node, "abbreviation" : "Def: ", "high" : 50, "step" : 5},
		"speed" : { "node" : speed_node, "abbreviation" : "Spd: ", "high" : 75, "step" : 5},
		"dexterity" : { "node" : dexterity_node, "abbreviation" : "Dex: ", "high" : 75, "step" : 5},
		"vitality" : { "node" : vitality_node, "abbreviation" : "Vit: ", "high" : 75, "step" : 5},
	}
	var colors = [
		
	]
	
	for stat in stats.keys():
		var node = stats[stat].node
		node.text = stats[stat].abbreviation + str(total_stats[stat])
		var difference = total_stats[stat] - base_stats[stat]
		
		if difference > 0:
			node.text += " (+" + str(difference) + ")"
		elif difference < 0:
			node.text += " (-" + str(difference) + ")"
		
		var interpolation_factor = total_stats[stat]/stats[stat].high
		var low_color = Color(197.0/255, 197.0/255, 197.0/255)
		var high_color = Color(81.0/255, 255.0/255, 156.0/255)
		node.add_color_override("font_color", low_color.linear_interpolate(high_color, interpolation_factor))

func SetCharacterSprite(character, gear):
	var CharacterSpriteEle = $StatsContainer/PanelContainer2/MarginContainer/ResizeContainer/CharacterInfo/HBoxContainer/MarginContainer/Sprite
	
	print(CharacterSpriteEle.region_rect)
	CharacterSpriteEle.SetCharacterClass(character.class)
	if character.gear.has("weapon") and character.gear.weapon != null: 
		CharacterSpriteEle.SetCharacterWeapon(ClientData.GetItem(character.gear.weapon.item).type)
	print(CharacterSpriteEle.region_rect)
	SetSpriteData(CharacterSpriteEle, ClientData.GetCharacter(character.class).path)
	CharacterSpriteEle.ColorGear(gear)

func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0]) 
	sprite.texture = spriteTexture
	sprite.hframes = path[1]
	sprite.vframes = path[2]
	sprite.frame_coords = path[3]
