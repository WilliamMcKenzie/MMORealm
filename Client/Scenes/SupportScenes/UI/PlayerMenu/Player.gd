extends PanelContainer

var index
var last_character_data = {}

func OpenPlayerMenu():
	GameUI.get_node("Nearby").OpenPlayerMenu(name, last_character_data)

func SetCharacter(character_data):
	if character_data.hash() == last_character_data.hash():
		return
	last_character_data = character_data
	
	var root = get_node("MarginContainer/HBoxContainer")
	
	var name_node = root.get_node("VBoxContainer/HBoxContainer/Label")
	var level_node = root.get_node("VBoxContainer/HBoxContainer/Label2")
	var level_text = ""
	var gear_node = root.get_node("VBoxContainer/GearContainer")
	
	if character_data.level > 20:
		level_text = "Lv. 20"
	else:
		level_text = "Lv. " + str(character_data.level)
	
	name_node.text = character_data.name
	level_node.text = level_text
	for slot in character_data.gear:
		var slot_node = gear_node.get_node(slot)
		var gear = character_data.gear
		slot_node.SetItem(gear[slot], 1)
		
func _ready():
	$TextureButton.connect("button_down", self, "OpenPlayerMenu")
	
	var stylebox = StyleBoxFlat.new()
	if index % 2 == 0:
		stylebox.bg_color = Color(0,0,0,0)
		add_stylebox_override("panel", stylebox)
		
	if last_character_data.has("gear"):
		UtilityFunctions.SetCharacterSprite(last_character_data, get_node("MarginContainer/HBoxContainer/SpriteContainer/MarginContainer/Sprite"))
