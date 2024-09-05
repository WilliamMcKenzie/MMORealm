extends PanelContainer

var portal_id
var portal_name

func _ready():
	$MarginContainer/Button.connect("pressed", self, "EnterInstance")
func EnterInstance():
	Server.EnterInstance(portal_id, portal_name)
