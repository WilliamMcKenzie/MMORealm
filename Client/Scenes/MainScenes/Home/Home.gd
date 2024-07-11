extends Control

var nexus = preload("res://Scenes/MainScenes/Nexus/Nexus.tscn")

var email
var password
var gold

func _ready():
	$UI/Leaderboard.connect("button_down", self, "OpenLeaderboard")

func AuthenticatedUser():
	Gateway.ConnectToServer(email, password, 4)

func UpdateGold():
	var ui = get_node("UI")
	ui.get_node("Gold/Gold").text = str(gold)

func OpenLeaderboard():
	get_node("UI").visible = false
	get_node("CharacterSelection").visible = false
	get_node("Leaderboard").visible = true
func CloseLeaderboard():
	get_node("UI").visible = true
	get_node("CharacterSelection").visible = true
	get_node("Leaderboard").visible = false

func SelectionScreen(account_data):
	get_node("LoginPopup").visible = false
	get_node("UI").visible = true
	GameUI.SetAccountData(account_data)
	Gateway.ConnectToServer(email, password, 5)
	
	var selection_screen = get_node("CharacterSelection")
	selection_screen.characters = account_data.characters
	selection_screen.character_slots = account_data.character_slots
	selection_screen.Populate()
	selection_screen.visible = true
	
	gold = account_data.gold
	UpdateGold()
	
func EnterGame(character_index, character):
	Server.ConnectToServer()
	Server.SetCharacterIndex(character_index)
	
	var nexus_instance = nexus.instance()
	nexus_instance.get_node("YSort/player").SetCharacter(character)
	get_parent().add_child(nexus_instance)
	GameUI.visible = true
	GameUI.get_node("GameButtons").visible = true
	queue_free()
	
