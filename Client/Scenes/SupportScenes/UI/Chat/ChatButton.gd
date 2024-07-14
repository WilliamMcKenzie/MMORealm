extends PanelContainer

func _ready():
	$MarginContainer/TextureButton.connect("pressed", self, "ToggleChat")
	
func ToggleChat():
	if name == "Open":
		GameUI.OpenChat()
	else:
		GameUI.CloseChat()
