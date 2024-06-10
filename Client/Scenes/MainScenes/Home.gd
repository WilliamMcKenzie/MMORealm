extends Control

onready var playButton = $UI/PlayResizer/Play

var nexus = preload("res://Scenes/MainScenes/nexus.tscn")

func _ready():
	playButton.connect("pressed", self, "play")

func play():
	Server.FetchPlayerData()
func selectionScreen():
	get_node("UI").visible = false
	get_node("LoginPopup").visible = false
	var selectionScreenInstance = get_node("CharacterSelection")
	# We will implement actually showing created characters once we have them on the auth server
	# selectionScreenInstance.characters = player.characters
	selectionScreenInstance.PopulateCharacters()
	selectionScreenInstance.visible = true
	
func enterGame(character):
	Server.ConnectToServer()
	var nexus_instance = nexus.instance()
	nexus_instance.get_node("YSort/player").stats = character.stats
	nexus_instance.get_node("YSort/player").gear = character.gear
	nexus_instance.get_node("YSort/player").level = character.level
	get_parent().add_child(nexus_instance)
	GameUI.visible = true
	queue_free()
	
