extends Control

onready var playButton = $UI/PlayResizer/Play
var map = preload("res://Scenes/MainScenes/Map.tscn")

func _ready():
	playButton.connect("pressed", self, "play")

func play():
	var map_instance = map.instance()
	get_parent().add_child(map_instance)
	queue_free()
	
