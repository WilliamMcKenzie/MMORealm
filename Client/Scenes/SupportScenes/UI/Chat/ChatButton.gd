extends PanelContainer

func _ready():
	$MarginContainer/TextureButton.connect("pressed", self, "FocusChat")
	
func FocusChat():
	get_parent().get_node("PanelContainer/MarginContainer/ChatInput").grab_focus()
