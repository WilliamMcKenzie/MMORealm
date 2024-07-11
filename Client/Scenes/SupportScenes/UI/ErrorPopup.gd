extends CanvasLayer

func _ready():
	$PanelContainer/MarginContainer/VBoxContainer/Close.connect("button_down", self, "ClosePopup")
	
func OpenPopup(error):
	$PanelContainer.visible = true
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ErrorName.text = error
	
func ClosePopup():
	$PanelContainer.visible = false
