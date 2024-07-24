extends Control

var nexus = preload("res://Scenes/MainScenes/Nexus/Nexus.tscn")

var email
var password
var gold

func _ready():
	$UI/Leaderboard.connect("button_down", self, "OpenLeaderboard")
	$UI/Graveyard.connect("button_down", self, "OpenGraveyard")
	
	if ClientAuth.cached_email and ClientAuth.cached_password:
		email = ClientAuth.cached_email
		password = ClientAuth.cached_password
		get_node("LoginPopup").email = email
		get_node("LoginPopup").password = password
		get_node("LoginPopup/VBoxContainer/EmailContainer/Email/MarginContainer/Email").text = email
		get_node("LoginPopup/VBoxContainer/PasswordContainer/Password/MarginContainer/Password").text = password
		get_node("LoginPopup").LoginAttempt()

func AuthenticatedUser():
	Gateway.ConnectToServer(email, password, 4)

func UpdateGold():
	var ui = get_node("UI")
	var graveyard = get_node("Graveyard")
	ui.get_node("Gold/Gold").text = str(gold)
	graveyard.get_node("Gold/Gold").text = str(gold)

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

func SelectionScreen(account_data):
	GameUI.SetAccountData(account_data)
	Gateway.ConnectToServer(email, password, 5)
	ClientAuth.cached_email = email
	ClientAuth.cached_password = password
	ClientAuth.SaveUser(email, password)
	
	var selection_screen = get_node("CharacterSelection")
	selection_screen.characters = account_data.characters
	selection_screen.character_slots = account_data.character_slots
	selection_screen.Populate()
	
	var graveyard = get_node("Graveyard")
	graveyard.graveyard = account_data.graveyard
	graveyard.can_revive = account_data.character_slots > account_data.characters.size()
	graveyard.SwitchGraveyard(graveyard.current)
	
	if not get_node("Graveyard").visible:
		selection_screen.visible = true
		get_node("LoginPopup").visible = false
		get_node("UI").visible = true
	
	gold = account_data.gold
	UpdateGold()
	
func EnterGame(character_index, character):
	Server.token = null
	Gateway.ConnectToServer(email, password, 6)
	Server.ConnectToServerHTML()
	Server.SetCharacterIndex(character_index)
	
	var nexus_instance = nexus.instance()
	nexus_instance.get_node("YSort/player").SetCharacter(character)
	get_parent().add_child(nexus_instance)
	GameUI.visible = true
	GameUI.Init()
	GameUI.get_node("GameButtons").visible = true
	queue_free()
	
