extends CanvasLayer

var scrolling = false
var in_chat = false
var is_in_ui = false
var is_in_menu = false
var is_in_chat = false
var last_opened = 0
var last_menu = "NULL"

var is_dead = false
var last_character
var account_data

var animation_timer = 0
var animation_tracker = []

func Init():
	is_dead = false
	in_chat = false
	is_in_ui = false
	is_in_menu = false
	is_in_chat = false
	last_opened = 0
	last_menu = "inventory"
	last_character = null
	animation_tracker = []
	$LeftContainer/BarContainer/Health.ChangeHealth(100, 100)
	$LeftContainer/BarContainer/ExpContainer/ExpBar.ChangeExp(100, 0)
	$DeathScreen.reputation = 0
	Server.Init()

func _ready():
	$Inventory/BackpackContainer/CloseButton.connect("pressed", self, "Toggle", ["inventory"])
	$Inventory/LootContainer/CloseButton.connect("pressed", self, "Toggle", ["inventory"])
	$GameButtons/HomeButton.connect("pressed", Server, "Nexus")
	
	$GameButtons/HelmetButton.connect("pressed", self, "InUI")
	$GameButtons/HomeButton.connect("pressed", self, "InUI")
	#if str(OS.get_model_name()) == 'GenericDevice':
		#$GameButtons/HelmetButton.visible = false
		#$GameButtons/HomeButton.visible = false

func _physics_process(delta):
	animation_timer -= delta
	if animation_timer <= 0 and animation_tracker.size() > 0 and is_dead == false:
		var animation = animation_tracker[0]
		
		PlayAnimation(animation.name, animation.data)
			
		animation_tracker.pop_front()
		animation_timer = 3

func StartTutorial():
	$TutorialAnimations.play("Start")
	if account_data.username == "[unset]":
		$NpcDialogue.StartSubject("Intro")
	else:
		Server.ChooseUsername(account_data.username)

func SetQuest(current_quest_data):
	if current_quest_data or Server.GetCurrentInstance() == "nexus":
		get_node("QuestMarker").SetQuest(current_quest_data)
	else:
		get_node("QuestMarker").RemoveQuest()

func UpdateEnemyChatBubbles(id, text):
	if id and Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()):
		var scene = Server.get_node("../SceneHandler/"+Server.GetCurrentInstance())
		
		if scene.has_node("YSort/Enemies/"+id):
			var node = scene.get_node("YSort/Enemies/"+id+"/EnemyChatBubble")
			node.Update(id,text)

func UpdateChatBubbles(id, text):
	if id and Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()):
		var scene = Server.get_node("../SceneHandler/"+Server.GetCurrentInstance())
		
		if scene.has_node("YSort/OtherPlayers/"+id):
			var node = scene.get_node("YSort/OtherPlayers/"+id+"/ChatBubble")
			node.Update(id,text)
		elif id == str(get_tree().get_network_unique_id()):
			var node = scene.get_node("YSort/player/ChatBubble")
			node.Update(id,text)
	
func UpdateNametags(id, classname, username):
	var base_node = get_node("Nametags")
	if not base_node.has_node(id):
		var nametag_instance = load("res://Scenes/SupportScenes/UI/PlayerNametag.tscn").instance()
		nametag_instance.name = id
		base_node.add_child(nametag_instance)
	base_node.get_node(id).Update(id, classname, username)

func GoHome():
	LoadingScreen.Transition("")
	yield(get_tree().create_timer(0.3), "timeout")
	
	Server.first_fetch = true
	Server.html_network.disconnect_from_host()
	var scene_handler = get_node("/root/SceneHandler")
	var home_instance = load("res://Scenes/MainScenes/Home/Home.tscn").instance()
	
	for child in scene_handler.get_children():
		scene_handler.remove_child(child)
	scene_handler.add_child(home_instance)
	self.visible = false
	
	if is_in_menu:
		Toggle(last_menu)
	if is_in_chat:
		CloseChat()

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
		get_node("Building").SetHouseData(_account_data.home)
		for achievement in account_data.achievements.keys():
			if _account_data.achievements.has(achievement) and account_data.achievements[achievement] != _account_data.achievements[achievement]:
				animation_tracker.append({ "name" : "UnlockAchievement", "data" : achievement})
	
		account_data = _account_data
		$Stats.SetName(account_data.username)
		if is_in_menu and last_menu == "achievements":
			$Achievements.Open()
	else:
		account_data = _account_data

func SetCharacterData(character):
	
	#Classes
	if not last_character or last_character.class == character.class:
		pass
	else:
		animation_tracker.append({ "name" : "DiscoverClass", "data" : character.class})
	ClientData.current_class = character.class
	
	#Exp
	$LeftContainer/BarContainer/ExpContainer/ExpBar.ChangeExp(100*pow(1.1962,character.level), character.exp)
	if last_character and character.exp != last_character.exp:
		var difference = (character.exp - last_character.exp) if(character.exp > last_character.exp) else character.exp
		Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()+"/YSort/player").ShowIndicator("exp", difference)
	if last_character and character.level > last_character.level:
		var difference = character.level - last_character.level
		Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()+"/YSort/player").ShowIndicator("level", difference)
	if last_character and character.ascension_stones > last_character.ascension_stones:
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

func SetNearbyCharacters(characters_data):
	var node = get_node("Nearby")
	node.SetCharacters(characters_data)

func OpenChat():
	get_node("ChatControl").Open()

func CloseChat():
	get_node("ChatControl").Close()

#TRADE

func TradeRequest(player_name):
	var node = get_node("TradeRequest")
	node.Open(player_name)

#INVENTORY

func InventoryToggleLogic():
	if is_in_menu == false or last_menu != "inventory":
		return
	if get_node("Inventory").loot == null and $LeftContainer.visible == false:
		$LeftContainer.visible = true
	elif get_node("Inventory").loot != null and $LeftContainer.visible == true:
		$LeftContainer.visible = false
func NearbyToggleLogic():
	if is_in_menu == false or last_menu != "nearby":
		return
	if not get_node("Nearby").viewing_player:
		$LeftContainer.visible = true
	else:
		$LeftContainer.visible = false
func Toggle(which):
	var node_map = {
		"classes" : get_node("Classes"),
		"stats" : get_node("Stats"),
		"inventory" : get_node("Inventory"),
		"achievements" : get_node("Achievements"),
		"death" : get_node("DeathScreen"),
		"nearby" : get_node("Nearby"),
		"trade" : get_node("TradingMenu"),
		"building" : get_node("Building"),
		"settings" : get_node("Settings")
	}
	
	var node
	if which != "all":
		last_menu = which
		node = node_map[which]
	elif last_menu != "NULL" and is_in_menu:
		is_in_menu = false
		node = node_map[last_menu]
		node.Close()
		return
	else:
		return
	
	if not last_character:
		ErrorPopup.OpenPopup("Server Disconnected")
		return
	if last_opened+100 > OS.get_system_time_msecs():
		return
	last_opened = OS.get_system_time_msecs()
	if is_in_menu:
		node.Close()
		
		if which == "inventory" or which == "stats" or which == "nearby":
			yield(get_tree().create_timer(0.1), "timeout")
		
		$LeftContainer.visible = true
		$GameButtons.visible = true
		$UtilityButtons.visible = true
		$ChatControl.visible = true
		is_in_menu = false
		
		if which == "trade":
			get_node("TradeRequest").current_requester = null
	else:
		node.Open()
		$LeftContainer.visible = false
		if which == "stats" or (which == "inventory" and node.loot == null):
			$LeftContainer.visible = true
			
		$GameButtons.visible = false
		$UtilityButtons.visible = false
		$ChatControl.visible = false
		is_in_menu = true

var leaderboards = {
	"weekly" : [],
	"monthly" : [],
	"all_time" : [],
}

func SetLeaderboard(_weekly, _monthly, _all_time):
	leaderboards["weekly"] = _weekly
	leaderboards["monthly"] = _monthly
	leaderboards["all_time"] = _all_time

func GetLeaderboard():
	return leaderboards
