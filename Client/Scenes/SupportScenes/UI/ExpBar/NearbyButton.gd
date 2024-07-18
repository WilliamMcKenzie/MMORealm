extends PanelContainer

func _ready():
	$MarginContainer/TextureButton.connect("pressed", self, "OpenNearby")

func OpenNearby():
	GameUI.Toggle("nearby")

func _on_TouchScreenButton_pressed():
	GameUI.Toggle("nearby")
