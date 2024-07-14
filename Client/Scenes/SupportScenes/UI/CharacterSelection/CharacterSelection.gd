extends CanvasLayer

var CharacterButton = preload("res://Scenes/SupportScenes/UI/CharacterSelection/CharacterButton.tscn")
var CreateCharacterButton = preload("res://Scenes/SupportScenes/UI/CharacterSelection/CreateCharacterButton.tscn")
var BuyCharacterSlot = preload("res://Scenes/SupportScenes/UI/CharacterSelection/BuyCharacterSlot.tscn")

onready var ScrollLeft = $UI/Control/ScrollLeft
onready var ScrollRight = $UI/Control2/ScrollRight

var characters = []
var character_slots = 1

var scroll_index = 0
onready var active_node = "-1"

func _ready():
	ScrollLeft.connect("pressed", self, "ScrollLeftAction")
	ScrollRight.connect("pressed", self, "ScrollRightAction")

func AddCharacterSlot():
	var price = 500 + (character_slots*200)
	character_slots += 1
	get_parent().gold -= price
	get_parent().UpdateGold()

func Populate():
	if get_node(active_node):
		get_node(active_node).queue_free()
	UpdateScrollButtons()
	
	if characters.size() > 0 and scroll_index < characters.size():
		AddCharacterButton(scroll_index)
	else:
		AddCreateCharacterButton()

func UpdateScrollButtons():
	if scroll_index < 1:
		ScrollLeft.modulate.a = 0.3
	else:
		ScrollLeft.modulate.a = 1
	
	if scroll_index > characters.size()-1:
		ScrollRight.modulate.a = 0.3
	else:
		ScrollRight.modulate.a = 1

func ScrollLeftAction():
	if scroll_index < 1:
		pass
	else:
		get_node(active_node).queue_free()
		scroll_index -= 1		
		AddCharacterButton(scroll_index)
		UpdateScrollButtons()

func ScrollRightAction():
	if scroll_index > characters.size()-1:
		pass
	elif scroll_index == characters.size()-1:
		get_node(active_node).queue_free()
		scroll_index += 1
		AddCreateCharacterButton()
		UpdateScrollButtons()
	else:
		get_node(active_node).queue_free()
		scroll_index += 1
		AddCharacterButton(scroll_index)
		UpdateScrollButtons()
	
func AddCharacterButton(i):
	var button_instance = CharacterButton.instance()
	button_instance.AssignParameters(characters[i])
	button_instance.character_index = i
	button_instance.name = str(i)
	add_child(button_instance)
	move_child(button_instance, 0)
	active_node = str(i)

func AddCreateCharacterButton():
	if character_slots > scroll_index:
		var button_instance = CreateCharacterButton.instance()
		button_instance.name = str(-1)
		add_child(button_instance)
		move_child(button_instance, 0)
		active_node = str(-1)
	else:
		var button_instance = BuyCharacterSlot.instance()
		button_instance.name = str(-2)
		add_child(button_instance)
		move_child(button_instance, 0)
		active_node = str(-2)
