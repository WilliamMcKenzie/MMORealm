extends PanelContainer

var portal_id
var portal_name

func _physics_process(delta):
	if visible and (Input.is_action_pressed("interact")) and not GameUI.in_chat:
		EnterInstance()

func _ready():
	$MarginContainer/Button.connect("pressed", self, "EnterInstance")
func EnterInstance():
	Server.EnterInstance(portal_id, portal_name)
