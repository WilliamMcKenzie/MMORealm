extends CanvasLayer

var in_chat = false
var is_in_ui = false
var is_inventory_open = false
var is_stats_open = false
var is_classes_open = false
var last_opened = 0

var last_character
var account_data

var animation_timer = 0
var animation_tracker = []

func _ready():
	$UtilityButtons/BackpackButton/MarginContainer/TextureButton.connect("pressed", self, "ToggleInventory")
	$Inventory/BackpackContainer/CloseButton.connect("pressed", self, "ToggleInventory")
	$Inventory/LootContainer/CloseButton.connect("pressed", self, "ToggleInventory")
	$GameButtons/HomeButton.connect("pressed", Server, "Nexus")
	
	$GameButtons/HelmetButton.connect("pressed", self, "InUI")
	$GameButtons/HomeButton.connect("pressed", self, "InUI")

func _physics_process(delta):
	animation_timer -= delta
	if animation_timer <= 0 and animation_tracker.size() > 0:
		var animation = animation_tracker[0]
		
		if animation.name == "discover":
			DiscoverClass(animation.data.class)
			
		animation_tracker.pop_front()
		animation_timer = 3

func SetAccountData(_account_data):
	account_data = _account_data
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

func DiscoverClass(classname):
	var animation_node = load("res://Scenes/SupportScenes/Animations/DiscoverClass/DiscoverClass.tscn").instance()
	animation_node.SetClass(classname)
	add_child(animation_node)

func SetCharacterData(character):
	
	#Classes
	if not last_character or last_character.class == character.class:
		pass
	else:
		ClientData.current_class = character.class
		animation_tracker.append({ "name" : "discover", "data" : {"class" : character.class}})
	
	#Exp
	$LeftContainer/BarContainer/ExpContainer/ExpBar.ChangeExp(100*pow(1.1538,character.level), character.exp)
	if not last_character:
		pass
	elif character.exp > last_character.exp:
		var difference = character.exp - last_character.exp
		Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()+"/YSort/player").ShowIndicator("exp", difference)
	elif character.level > last_character.level:
		var difference = character.level - last_character.level
		Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()+"/YSort/player").ShowIndicator("level", difference)
	elif character.ascension_stones > last_character.ascension_stones:
		var difference = character.ascension_stones - last_character.ascension_stones
		Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()+"/YSort/player").ShowIndicator("ascension", difference)
	#Items
	last_character = character.duplicate()
	$Inventory.SetInventory(character.inventory)
	$Inventory.SetGear(character.gear)
	if $Inventory.inspecting_item != null:
		$Inventory.DeInspectItem($Inventory.inspecting_item)
	
	var timer = Timer.new()
	timer.wait_time = 0.01
	timer.one_shot = true
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	
	if is_stats_open:
		$Stats.SetStats(last_character)

func ToggleInventory():
	if not last_character:
		ErrorPopup.OpenPopup("Server Disconnected")
		return
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
	if not last_character:
		ErrorPopup.OpenPopup("Server Disconnected")
		return
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
		
func ToggleClasses():
	if not last_character:
		ErrorPopup.OpenPopup("Server Disconnected")
		return
	if last_opened+100 > OS.get_system_time_msecs():
		return
	last_opened = OS.get_system_time_msecs()
	if is_classes_open:
		$Classes.CloseClasses()
		$LeftContainer.visible = true
		$GameButtons.visible = true
		$UtilityButtons.visible = true
		$ChatControl.visible = true
		is_classes_open = false
	else:
		$Classes.OpenClasses()
		$LeftContainer.visible = false
		$GameButtons.visible = false
		$UtilityButtons.visible = false
		$ChatControl.visible = false
		is_classes_open = true
