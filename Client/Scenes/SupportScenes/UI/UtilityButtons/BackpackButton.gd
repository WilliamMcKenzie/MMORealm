extends PanelContainer

func _ready():
	$MarginContainer/TextureButton.connect("pressed", self, "OpenLootBag")

func OpenLootBag():
	GameUI.Toggle("inventory")

func _on_TouchScreenButton_pressed():
	GameUI.Toggle("inventory")