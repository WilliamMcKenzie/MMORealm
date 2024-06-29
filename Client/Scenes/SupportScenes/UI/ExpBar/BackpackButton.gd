extends PanelContainer

func _ready():
	$MarginContainer/TouchScreenButton.connect("pressed", self, "OpenLootBag")

func OpenLootBag():
	GameUI.get_node("Inventory").ToggleInventory()


func _on_TouchScreenButton_pressed():
	GameUI.get_node("Inventory").ToggleInventory()
