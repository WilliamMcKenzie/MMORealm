extends CanvasLayer

var in_chat = false
var is_inventory_open = false

func SetCharacterData(character):
	$Inventory.SetInventory(character.inventory)
	$Inventory.SetGear(character.gear)

func ToggleInventory():
	if is_inventory_open:
		$Inventory.visible = false
		is_inventory_open = false
	else:
		$Inventory.visible = true
		is_inventory_open = true
