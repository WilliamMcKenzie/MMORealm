extends Node

var characters
var currentCharacterIndex

#We keep track of which "instance" the player is in. Examples include: dungeons, nexus, realm
var instance
#gold, quests and whatever else will all go here

func getPlayerData():
	return {
		"characters" : characters,
		"currentCharacterIndex" : currentCharacterIndex,
		"instance" : instance
	}
