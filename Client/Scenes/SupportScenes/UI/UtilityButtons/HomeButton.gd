extends PanelContainer

func _ready():
	$MarginContainer/TextureButton.connect("pressed", self, "OpenHome")

func OpenHome():
	GameUI.Toggle("settings")

func _on_TouchScreenButton_pressed():
	GameUI.Toggle("settings")
