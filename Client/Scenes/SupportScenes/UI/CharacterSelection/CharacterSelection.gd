extends Node2D

var CharacterButton = preload("res://Scenes/SupportScenes/UI/CharacterSelection/CharacterButton.tscn")
var CreateCharacterButton = preload("res://Scenes/SupportScenes/UI/CharacterSelection/CreateCharacterButton.tscn")
var characters = []

onready var placeholders = [$Placeholder1,$Placeholder2,$Placeholder3,$Placeholder4]


func populateCharacters():
	var i = 0
	for character in characters:
		var buttonInstance = CharacterButton.instance()
		buttonInstance.AssignParameters(character)
		buttonInstance.position = placeholders[i].position
		add_child(buttonInstance)
		i += 1
	var buttonInstance = CreateCharacterButton.instance()
	buttonInstance.position = placeholders[i].position
	add_child(buttonInstance)
