extends Control

onready var playButton = $UI/PlayResizer/Play

var nexus = preload("res://Scenes/MainScenes/Nexus/nexus.tscn")

var email
var password

func _ready():
	playButton.connect("pressed", self, "play")

func AuthenticatedUser(email):
	#Server.FetchPlayerData(email)
	SelectionScreen({ "characters" : [] })
	pass

func SelectionScreen(player_data):
	get_node("UI").visible = false
	get_node("LoginPopup").visible = false
	var selectionScreenInstance = get_node("CharacterSelection")
	# We will implement actually showing created characters once we have them on the auth server
	selectionScreenInstance.characters = player_data.characters
	selectionScreenInstance.PopulateCharacters()
	selectionScreenInstance.visible = true
	
func EnterGame(character_index, character):
	Server.ConnectToServer()
	Server.SetCharacterIndex(character_index)
	
	var nexus_instance = nexus.instance()
	nexus_instance.get_node("YSort/player").stats = character.stats
	nexus_instance.get_node("YSort/player").gear = character.gear
	nexus_instance.get_node("YSort/player").level = character.level
	get_parent().add_child(nexus_instance)
	GameUI.visible = true
	queue_free()
	
