extends CanvasLayer

func _ready():
	$PanelContainer/MarginContainer/VBoxContainer/Close.connect("button_down", self, "ClosePopup")
	$PanelContainer/MarginContainer/VBoxContainer/Home.connect("button_down", self, "GoHome")
	
func OpenPopup(error):
	$PanelContainer.visible = true
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ErrorName.text = error
	if GameUI.visible:
		$PanelContainer/MarginContainer/VBoxContainer/Home.visible = true
		$PanelContainer/MarginContainer/VBoxContainer/Close.visible = false
	else:
		$PanelContainer/MarginContainer/VBoxContainer/Home.visible = false
		$PanelContainer/MarginContainer/VBoxContainer/Close.visible = true
	
func ClosePopup():
	$PanelContainer.visible = false

func GoHome():
	$PanelContainer.visible = false
	GameUI.GoHome()
