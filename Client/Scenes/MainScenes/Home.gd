extends Control

onready var playButton = $UI/PlayResizer/Play

var map = preload("res://Scenes/MainScenes/Map.tscn")

func _ready():
	playButton.connect("pressed", self, "play")

func play():
	Server.fetchPlayerData()
func selectionScreen():
	get_node("UI").visible = false
	get_node("LoginPopup").visible = false
	var selectionScreenInstance = get_node("CharacterSelection")
	# We will implement actually showing created characters once we have them on the auth server
	# selectionScreenInstance.characters = player.characters
	selectionScreenInstance.populateCharacters()
	selectionScreenInstance.visible = true
	
func enterGame(character):
	Server.ConnectToServer()
	var map_instance = map.instance()
	map_instance.get_node("YSort/player").stats = character.stats
	map_instance.get_node("YSort/player").gear = character.gear
	map_instance.get_node("YSort/player").level = character.level
	get_parent().add_child(map_instance)
	queue_free()
	
