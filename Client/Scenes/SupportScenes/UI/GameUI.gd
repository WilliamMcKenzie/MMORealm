extends CanvasLayer

var in_chat = false
var is_inventory_open = false
var last_opened = 0

var last_character

func _ready():
	$UtilityButtons/BackpackButton/MarginContainer/TextureButton.connect("pressed", self, "ToggleInventory")
	$Inventory/BackpackContainer/CloseButton.connect("pressed", self, "ToggleInventory")
	$Inventory/LootContainer/CloseButton.connect("pressed", self, "ToggleInventory")

func SetCharacterData(character):
	last_character = character
	$Inventory.SetInventory(character.inventory)
	$Inventory.SetGear(character.gear)
	if $Inventory.inspecting_item != null:
		$Inventory.DeInspectItem($Inventory.inspecting_item)

func ToggleInventory():
	if last_opened+100 > OS.get_system_time_msecs():
		return
	last_opened = OS.get_system_time_msecs()
	if is_inventory_open:
		$Inventory.CloseInventory()
		$LeftContainer.visible = true
		$UtilityButtons.visible = true
		$ChatControl.visible = true
		is_inventory_open = false
	else:
		$Inventory.OpenInventory()
		$LeftContainer.visible = false
		$UtilityButtons.visible = false
		$ChatControl.visible = false
		is_inventory_open = true
