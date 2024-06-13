extends Node2D

var CharacterButton = preload("res://Scenes/SupportScenes/UI/CharacterSelection/CharacterButton.tscn")
var CreateCharacterButton = preload("res://Scenes/SupportScenes/UI/CharacterSelection/CreateCharacterButton.tscn")
var characters = []

onready var placeholders = [$Placeholder1,$Placeholder2,$Placeholder3,$Placeholder4]
var taken_places = [false, false, false, false]


func PopulateCharacters():
	var i = 0
	for character in characters:
		if taken_places[i] == false:
			var buttonInstance = CharacterButton.instance()
			buttonInstance.AssignParameters(character)
			buttonInstance.position = placeholders[i].position
			taken_places[i] = true
			add_child(buttonInstance)
		i += 1
	var buttonInstance = CreateCharacterButton.instance()
	buttonInstance.position = placeholders[i].position
	add_child(buttonInstance)
