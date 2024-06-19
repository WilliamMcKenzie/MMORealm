extends CanvasLayer

var in_chat = false
var is_inventory_open = false

func _ready():
	$MiniMapContainer/MiniMapButtons/BackpackButton/TextureButton.connect("pressed", self, "ToggleInventory")
	$Inventory/BackpackContainer/CloseButton.connect("pressed", self, "ToggleInventory")

func _physics_process(delta):
	if(Input.is_action_just_released("0")):
		$Inventory.UseItem(0)

func SetCharacterData(character):
	$Inventory.SetInventory(character.inventory)
	$Inventory.SetGear(character.gear)

func ToggleInventory():
	if is_inventory_open:
		$Inventory.CloseInventory()
		$MiniMapContainer.visible = true
		$ExpContainer.visible = true
		$ChatControl.visible = true
		is_inventory_open = false
	else:
		$Inventory.OpenInventory()
		$MiniMapContainer.visible = false
		$ExpContainer.visible = false
		$ChatControl.visible = false
		is_inventory_open = true
