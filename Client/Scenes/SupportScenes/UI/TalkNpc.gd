extends PanelContainer

var npc_name
var dialogue_trigger

func _ready():
	$MarginContainer/Button.connect("pressed", self, "TalkNpc")
func TalkNpc():
	GameUI.get_node("NpcDialogue").StartSubject(dialogue_trigger)
	visible = false
