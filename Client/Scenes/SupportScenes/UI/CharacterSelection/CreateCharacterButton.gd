extends Node2D

onready var containerButton = $Button
	
func _ready():
	containerButton.connect("pressed", self, "createCharacter")

func createCharacter():
	get_parent().characters.append({
		"stats" : {
			"health" : 100,
			"mana" : 100,
			"attack" : 40,
			"defense" : 40,
			"speed" : 100,
			"dexterity" : 70,
			"vitality" : 40,
			"wisdom" : 40
		},
		"level" : 1,
		"class" : "Piker",
		"gear" : {
			"weapon" : {
				"name": "Rusty Pike",
				"description" : "A grim reminder of the past.",
				"damage" : [15,25],
				"rof" : 100,
				"stats" : {
					
				},
				"range" : 4,
				"tier" : 0,
				"projectile" : "Arrow",
				"path" : ["items/items_8x8.png", 26, 26, 61]
			},
			"ability" : {
				"name": "Rusty Horn",
				"description" : "This thing emits a shrill sound.",
				"ability_specs" : {
					"berserk" : 5
				},
				"tier" : 0,
				"path" : ["items/items_8x8.png", 26, 26, 87]
			},
			"armor" : {
				"name" : "Rusted Plate",
				"description" : "It would hardly do any good on a battlefield.",
				"stats" : {
					"armor" : 5,
					"speed" : -5
				},
				"path" : ["items/items_8x8.png", 26, 26, 113]
			},
			"ring" : {
				"name" : "Rusted Health Ring",
				"description" : "A faint warmth emits from this ring.",
				"stats" : {
					"health" : 20
				},
				"path" : ["items/items_8x8.png", 26, 26, 0]
			}
		},
		"path" : ["characters/characters_8x8.png", 13, 26, 0]
	})
	get_parent().populateCharacters()
	
