extends PanelContainer

func _ready():
	$MarginContainer/TextureButton.connect("pressed", self, "OpenLootBag")

func OpenLootBag():
	GameUI.get_node("Inventory").ToggleInventory()
