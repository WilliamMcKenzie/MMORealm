extends CanvasLayer

var character_scene = preload("res://Scenes/SupportScenes/UI/Graveyard/Character.tscn")

var graveyard = []
#If there are no open character slots, cannot revive
var can_revive
var current = "recent"

func _ready():
	$HBoxContainer/top.connect("pressed", self, "SwitchGraveyard", ["top"])
	$HBoxContainer/recent.connect("pressed", self, "SwitchGraveyard", ["recent"])
	$Back.connect("button_down", self, "CloseGraveyard")

func SwitchGraveyard(which):
	get_node("HBoxContainer/"+current).modulate = Color(199.0/255,199.0/255,199.0/255)
	get_node("HBoxContainer/"+which).modulate = Color(1,1,1)
	
	current = which
	var container = $MarginContainer/ScrollContainer/Top
	for child in container.get_children():
		container.remove_child(child)
	
	var index = 0
	for character in graveyard:
		character.index = index
		index += 1
		
	var temp_graveyard = graveyard.duplicate()
	if which == "top":
		temp_graveyard.sort_custom(SortByReputation, "sort_by_reputation")
	if which == "recent":
		temp_graveyard.invert()
	
	for character in temp_graveyard:
		var character_instance = character_scene.instance()
		character_instance.index = character.index
		container.add_child(character_instance)
		character_instance.SetData(character, character.index)

class SortByReputation:
	static func sort_by_reputation(a, b):
		if a.level > b.level:
			return true
		return false
	
func SetGraveyard(_graveyard):
	var container = $MarginContainer/ScrollContainer/Top
	for child in container.get_children():
		container.remove_child(child)
	
	SwitchGraveyard(current)
	
func CloseGraveyard():
	get_parent().CloseGraveyard()
