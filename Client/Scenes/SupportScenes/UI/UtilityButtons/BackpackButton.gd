extends PanelContainer

func _ready():
	$MarginContainer/TextureButton.connect("pressed", self, "OpenLootBag")

func OpenLootBag():
	if OS.get_system_time_msecs() - GameUI.get_node("Inventory").last_opened >= 500:
		GameUI.Toggle("inventory")
	else:
		GameUI.get_node("Inventory").last_opened = OS.get_system_time_msecs()

func _on_TouchScreenButton_pressed():
	if OS.get_system_time_msecs() - GameUI.get_node("Inventory").last_opened >= 500:
		GameUI.Toggle("inventory")
	else:
		GameUI.get_node("Inventory").last_opened = OS.get_system_time_msecs()
