extends PanelContainer

func _ready():
	$MarginContainer/TextureButton.connect("pressed", self, "OpenClasses")

func OpenClasses():
	GameUI.ToggleClasses()

func _on_TouchScreenButton_pressed():
	GameUI.ToggleClasses()
