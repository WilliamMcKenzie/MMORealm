extends Control

var nexus = preload("res://Scenes/MainScenes/Nexus/Nexus.tscn")

var email
var password
var gold

func HideEverything(except):
	get_node("CharacterSelection").visible = false
	get_node("LoginPopup").visible = false
	get_node("Graveyard").visible = false
	get_node("Shop").visible = false
	get_node("UI").visible = false
	
	get_node(except).visible = true

func _ready():
	$UI/Leaderboard.connect("button_down", self, "OpenLeaderboard")
	$UI/Graveyard.connect("button_down", self, "OpenGraveyard")
	$UI/Gold.connect("button_down", self, "OpenShop")
	$UI/Logout.connect("button_down", self, "OpenLogout")
	
	if ClientAuth.cached_email and ClientAuth.cached_password:
		email = ClientAuth.cached_email
		password = ClientAuth.cached_password
		get_node("LoginPopup").email = email
		get_node("LoginPopup").password = password
		get_node("LoginPopup/VBoxContainer/EmailContainer/Email/MarginContainer/Email").text = email
		get_node("LoginPopup/VBoxContainer/PasswordContainer/Password/MarginContainer/Password").text = password
		get_node("LoginPopup").LoginAttempt()

func AuthenticatedUser():
	Gateway.GatewayRequest(email, password, 4)

func UpdateGold():
	var ui = get_node("UI")
	var graveyard = get_node("Graveyard")
	var shop = get_node("Shop")
	ui.get_node("Gold/Gold").text = str(gold)
	graveyard.get_node("Gold/Gold").text = str(gold)
	shop.get_node("Gold/Gold").text = str(gold)

func OpenLogout():
	get_node("Logout").visible = true
func CloseLogout():
	get_node("Logout").visible = false
func Logout():
	get_node("Logout").visible = false
	LoadingScreen.Transition("")
	yield(get_tree().create_timer(0.3), "timeout")
	email = null
	password = null
	GameUI.account_data = null
	ClientAuth.cached_email = null
	ClientAuth.cached_password = null
	ClientAuth.DeleteUser()
	
	var selection_screen = get_node("CharacterSelection")
	selection_screen.characters = []
	selection_screen.character_slots = 0
	selection_screen.remove_child(selection_screen.get_child(0))
	
	var graveyard = get_node("Graveyard")
	graveyard.graveyard = []
	graveyard.can_revive = false
	graveyard.SwitchGraveyard(graveyard.current)
	gold = 0
	Server.token = null
	UpdateGold()
	
	HideEverything("LoginPopup")
	get_node("LoginPopup").email = ""
	get_node("LoginPopup").password = ""
	get_node("LoginPopup/VBoxContainer/EmailContainer/Email/MarginContainer/Email").text = ""
	get_node("LoginPopup/VBoxContainer/PasswordContainer/Password/MarginContainer/Password").text = ""

func OpenLeaderboard():
	get_node("UI").visible = false
	get_node("CharacterSelection").visible = false
	get_node("Leaderboard").visible = true
func CloseLeaderboard():
	get_node("UI").visible = true
	get_node("CharacterSelection").visible = true
	get_node("Leaderboard").visible = false

func CloseGraveyard():
	get_node("UI").visible = true
	get_node("CharacterSelection").visible = true
	get_node("Graveyard").visible = false
func OpenGraveyard():
	get_node("UI").visible = false
	get_node("CharacterSelection").visible = false
	get_node("Graveyard").visible = true

func CloseShop():
	get_node("UI").visible = true
	get_node("CharacterSelection").visible = true
	get_node("Shop").visible = false
func OpenShop():
	get_node("UI").visible = false
	get_node("CharacterSelection").visible = false
	get_node("Shop").visible = true

func SelectionScreen(account_data):
	if not account_data:
		return
	
	GameUI.SetAccountData(account_data)
	Gateway.GatewayRequest(email, password, 5)
	ClientAuth.cached_email = email
	ClientAuth.cached_password = password
	ClientAuth.SaveUser(email, password)
	
	var selection_screen = get_node("CharacterSelection")
	selection_screen.characters = account_data.characters
	selection_screen.character_slots = account_data.character_slots
	if selection_screen.get_child_count() > 1:
		selection_screen.remove_child(selection_screen.get_child(0))
	selection_screen.Populate()
	
	var graveyard = get_node("Graveyard")
	graveyard.graveyard = account_data.graveyard
	graveyard.can_revive = account_data.character_slots > account_data.characters.size()
	graveyard.SwitchGraveyard(graveyard.current)
	
	if not get_node("Graveyard").visible and not get_node("Shop").visible:
		selection_screen.visible = true
		get_node("LoginPopup").visible = false
		get_node("UI").visible = true
	
	gold = account_data.gold
	UpdateGold()
	
func EnterGame(character_index, character):
	Server.token = null
	Gateway.GatewayRequest(email, password, 6)
	Server.ConnectToServerHTML()
	Server.SetCharacterIndex(character_index)
	
	LoadingScreen.Transition("Nexus")
	yield(get_tree().create_timer(0.3), "timeout")
	
	var nexus_instance = nexus.instance()
	nexus_instance.add_child(load("res://Scenes/SupportScenes/Misc/YSort.tscn").instance())
	nexus_instance.get_node("YSort/player").SetCharacter(character)
	get_parent().add_child(nexus_instance)
	GameUI.visible = true
	GameUI.Init()
	GameUI.get_node("GameButtons").visible = true
	queue_free()
	
