extends Node

var characters
var currentCharacterIndex
#gold, quests and whatever else will all go here

func getPlayerData():
	return {
		"characters" : characters,
		"curretnCharacterIndex" : currentCharacterIndex
	}
