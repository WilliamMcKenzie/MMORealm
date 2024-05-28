extends Node

var item_data

onready var test_data = {
	"characters" : [ {
		"stats" : {
			"health" : 100,
			"mana" : 100,
			"attack" : 40,
			"defense" : 40,
			"speed" : 100,
			"dexterity" : 40,
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
	},
	
	{
		"stats" : {
			"health" : 100,
			"mana" : 100,
			"attack" : 20,
			"defense" : 40,
			"speed" : 20,
			"dexterity" : 1,
			"vitality" : 11,
			"wisdom" : 1
		},
		"level" : 1,
		"class" : "Wizard",
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
	}]
}

func _ready():
	var item_data_file = File.new()
	item_data_file.open("res://Data/Items.json", File.READ)
	var item_data_json = JSON.parse(item_data_file.get_as_text())
	item_data_file.close()
	item_data = item_data_json.result
