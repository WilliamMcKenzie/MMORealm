extends PanelContainer

func _ready():
	$MarginContainer/TextureButton.connect("pressed", self, "OpenLootBag")

func OpenLootBag():
	GameUI.ToggleInventory()

func _on_TouchScreenButton_pressed():
	GameUI.ToggleInventory()
