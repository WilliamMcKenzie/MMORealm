extends PanelContainer

var portal_id

func _ready():
	$MarginContainer/Button.connect("pressed", self, "EnterInstance")
func EnterInstance():
	Server.EnterInstance(portal_id)
