extends PanelContainer

func _ready():
	$MarginContainer/TextureButton.connect("pressed", self, "OpenHome")

func OpenHome():
	print("Home")
	GameUI.GoHome()

func _on_TouchScreenButton_pressed():
	print("Home")
	GameUI.GoHome()
