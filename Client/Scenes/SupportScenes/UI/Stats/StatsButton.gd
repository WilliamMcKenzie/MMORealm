extends PanelContainer

func _ready():
	$MarginContainer/TextureButton.connect("pressed", self, "OpenStats")

func OpenStats():
	GameUI.ToggleStats()

func _on_TouchScreenButton_pressed():
	GameUI.ToggleStats()
