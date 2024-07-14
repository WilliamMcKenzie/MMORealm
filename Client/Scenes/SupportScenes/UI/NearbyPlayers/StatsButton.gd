extends PanelContainer

func _ready():
	$MarginContainer/TextureButton.connect("pressed", self, "OpenStats")

func OpenStats():
	GameUI.Toggle("stats")

func _on_TouchScreenButton_pressed():
	GameUI.Toggle("stats")
