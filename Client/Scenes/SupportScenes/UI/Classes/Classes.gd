extends CanvasLayer

var class_button = preload("res://Scenes/SupportScenes/UI/Classes/ClassButton.tscn")
var class_evolution_button = preload("res://Scenes/SupportScenes/UI/Classes/ClassEvolutionButton.tscn")
var character_map = {
	"Apprentice" : [0],
		
	"Noble" : [0,0],
	"Nomad" : [0,1],
	"Scholar" : [0,2],
	
	"Knight": [0,0,0],
	"Paladin": [0,0,1],
	"Marauder": [0,0,2],
		
	"Ranger": [0,1,0],
	"Sentinel": [0,1,1],
	"Scout": [0,1,2],
		
	"Magician": [0,2,0],
	"Druid": [0,2,1],
	"Warlock": [0,2,2],
}

var character_preview = preload("res://Scenes/SupportScenes/UI/Classes/CharacterPreview.tscn")

func _ready():
	$ExitButton.connect("pressed", self, "ToggleClasses")
	$ExitButton/TouchScreenButton.connect("pressed", self, "ToggleClasses")
func OpenEvolution():
	$ClassEvolution.visible = true
	$NotEnoughStones.visible = false
	$ClassInfo.visible = false
	for button in $MarginContainer/TreeRoot.get_children():
		button.Disable()
	get_node("MarginContainer/TreeRoot/ClassEvolutionButton").Activate()
	var class_data = ClientData.GetCharacter(GameUI.last_character.class)
	
	#Enough stones
	var root = $ClassEvolution/MarginContainer/HBoxContainer
	for child in root.get_children():
		root.remove_child(child)
	for quest in class_data.quests:
		var preview = character_preview.instance()
		preview.SetCharacter(class_data.quests[quest])
		root.add_child(preview)

func SetCharacter(classname):
	$ClassEvolution.visible = false
	$NotEnoughStones.visible = false
	$ClassInfo.visible = true
	var character = ClientData.GetCharacter(classname)
	for button in $MarginContainer/TreeRoot.get_children():
		button.Disable()
	get_node("MarginContainer/TreeRoot/"+classname).Activate()
	SetCharacterSprite(character, classname, character.example_colors, $ClassInfo/MarginContainer/ResizeContainer/TextureRect/Character)
	
	var root = $ClassInfo/MarginContainer/ResizeContainer
	var class_name_node = root.get_node("ClassName/Class")
	var class_icon_node = root.get_node("ClassName/TextureRect")
	var description_node = root.get_node("Description")
	var multipliers_node = root.get_node("Multipliers")
	var strengths_node = root.get_node("Strengths")
	
	class_name_node.text = classname
	class_name_node.add_color_override("font_color", character.color)
	class_icon_node.texture.region = Rect2(character.icon, Vector2(10,10))
	description_node.text = character.description
	
	var multiplier_text = """"""
	var multipliers_tracker = {
	}
	for type in character.multipliers.keys():
		for multiplier in character.multipliers[type].keys():
			var value = (character.multipliers[type][multiplier]-1)*100
			
			if multipliers_tracker.has(multiplier+str(value)):
				multipliers_tracker[multiplier+str(value)].types.append(type)
			else:
				multipliers_tracker[multiplier+str(value)] = { "value" : str(value), "types" : [type], "multiplier" : multiplier}
	
	for code in multipliers_tracker.keys():
		var value = multipliers_tracker[code].value
		var types = multipliers_tracker[code].types
		var multiplier = multipliers_tracker[code].multiplier.capitalize()
		
		var types_string = ""
		for type in types:
			if types_string != "":
				types_string += "/"
			types_string += type
		
		multiplier_text += """
+%s%% %s %s""" % [
			str(value), types_string, multiplier
		]
	
	multipliers_node.text = multiplier_text
	
	strengths_node.visible = false
	for child in strengths_node.get_children():
		child.visible = false
	
	var strength_tracker = {}
	var inverse_character_map = {}
	var stat_totals = {
		"health" : 0,
		"attack" : 0,
		"defense" : 0,
		"speed" : 0,
		"dexterity" : 0,
		"vitality" : 0
	}
	
	for classname in character_map.keys():
		var value = character_map[classname]
		inverse_character_map[value] = classname
	
	var class_key = character_map[classname].duplicate()
	for new_character_num in character_map[classname]:
		for stat in stat_totals.keys():
			var new_character_name = inverse_character_map[class_key]
			var new_character_stats = ClientData.GetCharacter(new_character_name).bonus_stats
			stat_totals[stat] += new_character_stats[stat]
		class_key.pop_back()
		
	for stat in character.bonus_stats:
		var value = stat_totals[stat]
		if (value >= 30 and stat != "health") or (value > 300):
			
			strengths_node.visible = true
			strengths_node.get_node("Label").visible = true
			
			var stat_node = strengths_node.get_node(stat.capitalize())
			stat_node.visible = true
			var stylebox = stat_node.get_stylebox("panel", "PanelContainer").duplicate()
			stylebox.modulate_color = Color(56.0/255,79.0/255,132.0/255,230.0/255)
			#stylebox.modulate_color = Color(122.0/255,78.0/255,185.0/255,230.0/255)
			stat_node.add_stylebox_override("panel", stylebox)
		elif (value > 10 and stat != "health") or (value > 100):
			strengths_node.visible = true
			strengths_node.get_node("Label").visible = true
			
			var stat_node = strengths_node.get_node(stat.capitalize())
			stat_node.visible = true
			var stylebox = stat_node.get_stylebox("panel", "PanelContainer").duplicate()
			stylebox.modulate_color = Color(0.0/255,0.0/255,0.0/255,80.0/255)
			#stylebox.modulate_color = Color(56.0/255,79.0/255,132.0/255,230.0/255)
			stat_node.add_stylebox_override("panel", stylebox)
	
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

func ToggleClasses():
	get_parent().Toggle("classes")

func Open():
	var current_character = GameUI.last_character.class
	var previous_characters = []
	
	for character in character_map.keys():
		previous_characters.append(character)
		
		for i in range(character_map[character].size()):
			var character_digit = character_map[character][i]
			var overshot = character_map[current_character].size() <= i
			if overshot or character_digit != character_map[current_character][i]:
				previous_characters.pop_back()
				break;
	
	for child in $MarginContainer/TreeRoot.get_children():
		$MarginContainer/TreeRoot.remove_child(child)
	for character in previous_characters:
		var button = class_button.instance()
		button.SetClass(character)
		button.name = character
		$MarginContainer/TreeRoot.add_child(button)
		get_node("MarginContainer/TreeRoot/"+character).connect("pressed", self, "SetCharacter", [character])
	
	if ClientData.GetCharacter(current_character).quests.size() > 0:
		var button = class_evolution_button.instance()
		button.SetClass(current_character)
		$MarginContainer/TreeRoot.add_child(button)
		get_node("MarginContainer/TreeRoot/ClassEvolutionButton").connect("pressed", self, "OpenEvolution")
	
	self.visible = true
	SetCharacter(current_character)

func Close():
	self.visible = false
