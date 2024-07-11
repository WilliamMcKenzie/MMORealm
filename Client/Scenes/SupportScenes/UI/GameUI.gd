extends CanvasLayer

var in_chat = false
var is_in_ui = false
var is_in_menu = false
var last_opened = 0
var last_menu = "inventory"

var last_character
var account_data

var animation_timer = 0
var animation_tracker = []

func _ready():
	$UtilityButtons/BackpackButton/MarginContainer/TextureButton.connect("pressed", self, "Toggle", ["inventory"])
	$UtilityButtons/AchievementsButton/MarginContainer/TextureButton.connect("pressed", self, "Toggle", ["achievements"])
	$Inventory/BackpackContainer/CloseButton.connect("pressed", self, "ToggleInventory")
	$Inventory/LootContainer/CloseButton.connect("pressed", self, "ToggleInventory")
	$GameButtons/HomeButton.connect("pressed", Server, "Nexus")
	
	$GameButtons/HelmetButton.connect("pressed", self, "InUI")
	$GameButtons/HomeButton.connect("pressed", self, "InUI")

func _physics_process(delta):
	animation_timer -= delta
	if animation_timer <= 0 and animation_tracker.size() > 0:
		var animation = animation_tracker[0]
		
		PlayAnimation(animation.name, animation.data)
			
		animation_tracker.pop_front()
		animation_timer = 3

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

#Animations
func PlayAnimation(animation_name, data):
	var animation_node = load("res://Scenes/SupportScenes/Animations/%s/%s.tscn" % [animation_name, animation_name]).instance()
	animation_node.SetData(data)
	add_child(animation_node)

func SetAccountData(_account_data):
	if account_data:
		for achievement in account_data.achievements.keys():
			if account_data.achievements[achievement] != _account_data.achievements[achievement]:
				animation_tracker.append({ "name" : "UnlockAchievement", "data" : achievement})
	
	account_data = _account_data
	$Stats.SetName(account_data.username)
	if is_in_menu and last_menu == "achievements":
		$Achievements.Open()

func SetCharacterData(character):
	
	#Classes
	if not last_character or last_character.class == character.class:
		pass
	else:
		ClientData.current_class = character.class
		animation_tracker.append({ "name" : "DiscoverClass", "data" : character.class})
	
	#Exp
	$LeftContainer/BarContainer/ExpContainer/ExpBar.ChangeExp(100*pow(1.1962,character.level), character.exp)
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
	
	if is_in_menu and last_menu == "stats":
		$Stats.SetStats(last_character)

func Toggle(which):
	last_menu = which
	var node_map = {
		"classes" : get_node("Classes"),
		"stats" : get_node("Stats"),
		"inventory" : get_node("Inventory"),
		"achievements" : get_node("Achievements"),
	}
	
	var node
	if which != "all":
		node = node_map[which]
	else:
		for key in node_map.keys():
			node = node_map[key]
			node.Close()
	
	if not last_character:
		ErrorPopup.OpenPopup("Server Disconnected")
		return
	if last_opened+100 > OS.get_system_time_msecs():
		return
	last_opened = OS.get_system_time_msecs()
	if is_in_menu:
		node.Close()
		$LeftContainer.visible = true
		$GameButtons.visible = true
		$UtilityButtons.visible = true
		$ChatControl.visible = true
		is_in_menu = false
	else:
		node.Open()
		$LeftContainer.visible = false
		$GameButtons.visible = false
		$UtilityButtons.visible = false
		$ChatControl.visible = false
		is_in_menu = true
