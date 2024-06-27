extends CanvasLayer

var in_chat = false
var is_in_ui = false
var is_inventory_open = false
var last_opened = 0

var last_character

func _ready():
	$UtilityButtons/BackpackButton/MarginContainer/TextureButton.connect("pressed", self, "ToggleInventory")
	$Inventory/BackpackContainer/CloseButton.connect("pressed", self, "ToggleInventory")
	$Inventory/LootContainer/CloseButton.connect("pressed", self, "ToggleInventory")
	$GameButtons/HomeButton.connect("pressed", Server, "Nexus")
	
	$GameButtons/HelmetButton.connect("button_down", self, "InUI")
	$GameButtons/HomeButton.connect("button_down", self, "InUI")

func InUI():
	is_in_ui = true
	
	var timer = Timer.new()
	timer.wait_time = 0.1
	timer.one_shot = true
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	
	ExitUI()
	
func ExitUI():
	is_in_ui = false

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
		$GameButtons.visible = true
		$UtilityButtons.visible = true
		$ChatControl.visible = true
		is_inventory_open = false
	else:
		$Inventory.OpenInventory()
		$LeftContainer.visible = false
		$GameButtons.visible = false
		$UtilityButtons.visible = false
		$ChatControl.visible = false
		is_inventory_open = true
