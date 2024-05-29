extends Node

var characters
var currentCharacterIndex
var position
var moveVector
#gold, quests and whatever else will all go here

func getPlayerData():
	return {
		"characters" : characters,
		"currentCharacterIndex" : currentCharacterIndex,
		
		"position" : position,
		"moveVector" : moveVector
	}
