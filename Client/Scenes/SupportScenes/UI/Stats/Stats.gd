extends CanvasLayer

var inspecting_item = null

func _ready():
	$StatsBackground.connect("button_down", self, "ToggleStats")
	$StatsContainer/CloseButton.connect("pressed", self, "ToggleStats")

func ToggleStats():
	get_parent().ToggleStats()

func OpenStats(character):
	if not character:
		return
	
	var stats_tween = $StatsTween
	var stats_element = $StatsContainer
	
	SetStats(character)
	
	stats_tween.interpolate_property(stats_element, "rect_position", stats_element.rect_position, Vector2(280, 0)+stats_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
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
	
	stats_tween.interpolate_property(stats_element, "rect_position", stats_element.rect_position, Vector2(-280, 0)+stats_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	stats_tween.start()
	$StatsBackground.visible = false

func SetName(name):
	$StatsContainer/PanelContainer2/MarginContainer/ResizeContainer/CharacterInfo/Name.text = name

func SetStats(character):
	var stats_node = $StatsContainer/PanelContainer2/MarginContainer/ResizeContainer/CharacterStats
	
	var base_stats = character.stats.duplicate(true)
	var total_stats = character.stats.duplicate(true)
	var gear = {}
	
	for slot in character.gear.keys():
		if character.gear[slot] != null:
			gear[slot] = ClientData.GetItem(int(character.gear[slot].item), true)
			for stat in gear[slot].stats.keys():
				base_stats[stat] -= gear[slot].stats[stat]
	
	var info = "Level " + str(character.level) + " " + character.class
	$StatsContainer/PanelContainer2/MarginContainer/ResizeContainer/CharacterInfo/Character/Info.text = info
	
	SetCharacterSprite(character, gear)
	
	var health_node = stats_node.get_node("Health/VBoxContainer/ProgressBar")
	var attack_node = stats_node.get_node("Attack/VBoxContainer/ProgressBar")
	var defense_node = stats_node.get_node("Defense/VBoxContainer/ProgressBar")
	var speed_node = stats_node.get_node("Speed/VBoxContainer/ProgressBar")
	var dexterity_node = stats_node.get_node("Dexterity/VBoxContainer/ProgressBar")
	var vitality_node = stats_node.get_node("Vitality/VBoxContainer/ProgressBar")
	
	var stats = {
		"health" : { "node" : health_node, "abbreviation" : "Hp: ", "threshold" : 500},
		"attack" : { "node" : attack_node, "abbreviation" : "Atk: ", "threshold" : 50},
		"defense" : { "node" : defense_node, "abbreviation" : "Def: ", "threshold" : 50},
		"speed" : { "node" : speed_node, "abbreviation" : "Spd: ", "threshold" : 50},
		"dexterity" : { "node" : dexterity_node, "abbreviation" : "Dex: ", "threshold" : 50},
		"vitality" : { "node" : vitality_node, "abbreviation" : "Vit: ", "threshold" : 50},
	}
	
	var blue = StyleBoxFlat.new()
	var orange = StyleBoxFlat.new()
	var transparent = StyleBoxFlat.new()
	blue.bg_color = Color(187.0/255, 162.0/255, 244.0/255)
	orange.bg_color = Color(66.0/255, 191.0/255, 221.0/255)
	transparent.bg_color = Color(25.0/255, 25.0/255, 35.0/255, 100.0/255)
	
	for stat in stats.keys():
		var node = stats[stat].node
		var stat_node = node.get_parent().get_node("HBoxContainer/Label")
		var max_stat_node = node.get_parent().get_node("HBoxContainer/Label2")
		
		if base_stats[stat] == total_stats[stat]:
			stat_node.text = str(total_stats[stat])
		else:
			stat_node.text = str(total_stats[stat])+" (+"+str(total_stats[stat]-base_stats[stat])+")"
		max_stat_node.text = "/"+str(stats[stat].threshold)
		
		if stats[stat].threshold >= total_stats[stat]:
			stat_node.add_color_override("font_color", Color(1, 1, 1))
			
			node.value = total_stats[stat]
			node.max_value = stats[stat].threshold
			node.add_stylebox_override("fg", orange)
			node.add_stylebox_override("bg", transparent)
		else:
			stat_node.add_color_override("font_color", Color(221.0/255, 207.0/255, 1))
			
			node.value = total_stats[stat]-stats[stat].threshold
			node.max_value = stats[stat].threshold
			node.add_stylebox_override("fg", blue)
			node.add_stylebox_override("bg", orange)

func SetCharacterSprite(character, gear):
	var CharacterSpriteEle = $StatsContainer/PanelContainer2/MarginContainer/ResizeContainer/CharacterInfo/Character/MarginContainer/Sprite
	
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
