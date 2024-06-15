extends Node

var characters = {
	"Apprentice" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"rect" : Rect2(0,0,80,40)
	},
	"Bulwark" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"rect" : Rect2(0,40,80,40)
	},
}

func GetCharacter(character):
	if characters.has(character):
		return characters[character]
	else:
		return null
