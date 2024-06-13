extends Node

var mapstart = preload("res://Scenes/MainScenes/Home/Home.tscn")

func _ready():
	var mapstart_instance = mapstart.instance()
	GameUI.visible = false
	add_child(mapstart_instance)
