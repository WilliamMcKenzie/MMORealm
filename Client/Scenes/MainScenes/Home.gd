extends Control

onready var playButton = $UI/PlayResizer/Play

var map = preload("res://Scenes/MainScenes/Map.tscn")

func _ready():
	playButton.connect("pressed", self, "play")

func play():
	Server.fetchPlayerData()
func selectionScreen(player):
	get_node("UI").visible = false
	var selectionScreenInstance = get_node("CharacterSelection")
	selectionScreenInstance.characters = player.characters
	selectionScreenInstance.populateCharacters()
	selectionScreenInstance.visible = true
	
func enterGame(character):
	var map_instance = map.instance()
	map_instance.get_node("YSort/player").stats = character.stats
	map_instance.get_node("YSort/player").gear = character.gear
	map_instance.get_node("YSort/player").level = character.level
	get_parent().add_child(map_instance)
	Server.fetchCharacterSpawnPosition()
	queue_free()
	
