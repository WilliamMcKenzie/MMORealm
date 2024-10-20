extends PanelContainer

var npc_name
var dialogue_trigger

func _physics_process(delta):
	if visible and (Input.is_action_pressed("interact")) and not GameUI.in_chat:
		TalkNpc()

func _ready():
	$MarginContainer/Button.connect("pressed", self, "TalkNpc")
func TalkNpc():
	GameUI.get_node("NpcDialogue").StartSubject(dialogue_trigger)
	visible = false
