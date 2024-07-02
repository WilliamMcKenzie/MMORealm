extends CanvasLayer

var in_chat = false
var is_in_ui = false
var is_inventory_open = false
var is_stats_open = false
var last_opened = 0

var last_character

func _ready():
	$UtilityButtons/BackpackButton/MarginContainer/TextureButton.connect("pressed", self, "ToggleInventory")
	$Inventory/BackpackContainer/CloseButton.connect("pressed", self, "ToggleInventory")
	$Inventory/LootContainer/CloseButton.connect("pressed", self, "ToggleInventory")
	$GameButtons/HomeButton.connect("pressed", Server, "Nexus")
	
	$GameButtons/HelmetButton.connect("pressed", self, "InUI")
	$GameButtons/HomeButton.connect("pressed", self, "InUI")

func SetAccountData(account_data):
	$Stats.SetName(account_data.username)

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

func ChangeHealth(max_health, health):
	$LeftContainer/BarContainer/Health.ChangeHealth(max_health, health)
	
func SetCharacterData(character):
	#Exp
	$LeftContainer/BarContainer/ExpContainer/ExpBar.ChangeExp(100*pow(1.1538,character.level), character.exp)
	if not last_character:
		pass
	elif character.exp > last_character.exp:
		var difference = character.exp - last_character.exp
		Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()+"/YSort/player").ShowExpIndicator(difference)
	elif character.level > last_character.level:
		Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()+"/YSort/player").ShowLevelIndicator(character.level)
	#Items
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
	
func ToggleStats():
	if last_opened+100 > OS.get_system_time_msecs():
		return
	last_opened = OS.get_system_time_msecs()
	if is_stats_open:
		$Stats.CloseStats()
		$LeftContainer.visible = true
		$GameButtons.visible = true
		$UtilityButtons.visible = true
		$ChatControl.visible = true
		is_stats_open = false
	else:
		$Stats.OpenStats(last_character)
		$LeftContainer.visible = false
		$GameButtons.visible = false
		$UtilityButtons.visible = false
		$ChatControl.visible = false
		is_stats_open = true
