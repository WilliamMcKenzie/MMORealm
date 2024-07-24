extends CanvasLayer

func _ready():
	$PanelContainer/MarginContainer/VBoxContainer/Options/Yes.connect("button_down", self, "Logout")
	$PanelContainer/MarginContainer/VBoxContainer/Options/Cancel.connect("button_down", self, "ClosePopup")
	
func ClosePopup():
	get_node("/root/SceneHandler/Home").CloseLogout()

func Logout():
	get_node("/root/SceneHandler/Home").Logout()
