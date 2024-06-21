extends CanvasLayer

var in_chat = false
var is_inventory_open = false

var last_character

func _ready():
	$MiniMapContainer/MiniMapButtons/BackpackButton/TextureButton.connect("pressed", self, "ToggleInventory")
	$Inventory/BackpackContainer/CloseButton.connect("pressed", self, "ToggleInventory")

func _physics_process(delta):
	if(Input.is_action_just_released("0")):
		$Inventory.EquipItem(0)

func SetCharacterData(character):
	last_character = character
	$Inventory.SetInventory(character.inventory)
	$Inventory.SetGear(character.gear)
	if $Inventory.inspecting_item != null:
		$Inventory.DeInspectItem($Inventory.inspecting_item)

func ToggleInventory():
	if is_inventory_open:
		$Inventory.CloseInventory()
		$MiniMapContainer.visible = true
		$LeftContainer.visible = true
		$ChatControl.visible = true
		is_inventory_open = false
	else:
		$Inventory.OpenInventory()
		$MiniMapContainer.visible = false
		$LeftContainer.visible = false
		$ChatControl.visible = false
		is_inventory_open = true
