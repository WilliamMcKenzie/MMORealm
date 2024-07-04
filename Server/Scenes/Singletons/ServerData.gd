extends Node

var current_class = "Apprentice"

var basic_loot_pools = {
	"lowlands_1" : {
		"soulbound_loot" : [
			{
				"item" : 4,
				"chance" : 0.01,
				"threshold" : 0.15,
			},
			{
				"item" : 0,
				"chance" : 0.5,
				"threshold" : 0.15,
			}
		],
		"loot" : [
			{
				"item" : 1,
				"chance" : 0.25,
			}
		]
	},
	"lowlands_2" : {
		"soulbound_loot" : [
				{
				"item" : 4,
				"chance" : 0.2,
				"threshold" : 0.15,
				},
				{
					"item" : 2,
					"chance" : 0.5,
					"threshold" : 0.15,
				},
				{
					"item" : 3,
					"chance" : 0.5,
					"threshold" : 0.15,
				},
			{
				"item" : 0,
				"chance" : 0.5,
				"threshold" : 0.15,
			}
		],
		"loot" : [
			{
				"item" : 1,
				"chance" : 0.25,
			}
		]
	}
}

var enemies = {
	"crab" : {
		"health" : 60,
		"defense" : 1,
		"exp" : 20,
		"behavior" : 1,
		"loot_pool" :  basic_loot_pools["lowlands_1"],
		"attack_pattern" : [
			{
			"projectile" : "GreySlash",
			"formula" : "x",
			"damage" : 10,
			"wait" : 1,
			"speed" : 10,
			"lifespan": 1,
			"direction" : Vector2(0,1)
			}
		]
	},
	"goblin_warrior" : {
		"health" : 60,
		"defense" : 1,
		"exp" : 40,
		"behavior" : 1,
		"loot_pool" :  basic_loot_pools["lowlands_1"],
		"attack_pattern" : [
			{
			"projectile" : "GreySlash",
			"formula" : "x",
			"damage" : 10,
			"wait" : 1,
			"speed" : 10,
			"lifespan": 1,
			"direction" : Vector2(0,1)
			}
		]
	},
	"goblin_cannon" : {
		"health" : 600,
		"defense" : 1,
		"exp" : 250,
		"behavior" : 1,
		"loot_pool" :  basic_loot_pools["lowlands_1"],
		"attack_pattern" : [
			{
			"projectile" : "GreySlash",
			"formula" : "x",
			"damage" : 10,
			"wait" : 1,
			"speed" : 10,
			"lifespan": 1,
			"direction" : Vector2(0,1)
			}
		]
	},
	"troll_warrior" : {
		"health" : 200,
		"defense" : 1,
		"exp" : 200,
		"behavior" : 1,
		"loot_pool" :  basic_loot_pools["lowlands_1"],
		"attack_pattern" : [
			{
			"projectile" : "GreySlash",
			"formula" : "x",
			"damage" : 10,
			"wait" : 1,
			"speed" : 10,
			"lifespan": 1,
			"direction" : Vector2(0,1)
			}
		]
	},
	"troll_brute" : {
		"health" : 400,
		"defense" : 1,
		"exp" : 2000,
		"behavior" : 1,
		"loot_pool" :  basic_loot_pools["lowlands_1"],
		"attack_pattern" : [
			{
			"projectile" : "GreySlash",
			"formula" : "x",
			"damage" : 10,
			"wait" : 1,
			"speed" : 10,
			"lifespan": 1,
			"direction" : Vector2(0,1)
			}
		]
	},
	"rock_golem" : {
		"health" : 200,
		"defense" : 1,
		"exp" : 20000,
		"behavior" : 1,
		"loot_pool" :  basic_loot_pools["lowlands_2"],
		"attack_pattern" : [
			{
			"projectile" : "GreySlash",
			"formula" : "x",
			"damage" : 1,
			"wait" : 1,
			"speed" : 10,
			"lifespan": 1,
			"direction" : Vector2(0,1)
			}
		]
	}
}

var items = {
	0 : {
		"name": "Ascension Stone",
		"description" : "A precious gemstone, what will it awaken in you?",
		"tier" : "4",
		"type" : "Consumable",
		"use" : "ascend",
		"slot" : "na",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,13)],
	},
	1 : {
		"name": "Short Sword",
		"description" : "A simple yet effective weapon.",
		"type" : "Sword",
		"slot" : "weapon",
		
		"damage" : [15,25],
		"rof" : 100,
		"stats" : {
			"vitality" : 12
		},
		"range" : 3,
		"tier" : "0",
		"projectile" : "GreySlash",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,0)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(105.0, 51.0, 10.0),
			"weaponNew" : RgbToColor(174.0, 172.0, 156.0)
		},
		"textures" : {}
	},
	2 : {
		"name": "Void Armor",
		"description" : "A soldiers first line of defense.",
		"type" : "Robe",
		"slot" : "armor",
		"tier" : "5",
		
		"stats" : {
			"speed" : 100
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,5)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(0.0, 106.0, 138.0),
			"bodyLightNew" : RgbToColor(0.0, 125.0, 163.0),
			"bandNew" : RgbToColor(225.0, 179.0, 36.0),
		},
		"textures" : {
			
		}
	},
	3 : {
		"name": "Shadowbringer Bow",
		"description" : "A ominous bow, forged from the very essence of darkness.",
		"type" : "Bow",
		"slot" : "weapon",
		
		"damage" : [15,25],
		"rof" : 100,
		"stats" : {
					
		},
		"range" : 6,
		"tier" : "5",
		"projectile" : "GoldenArrow",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,2)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(125.0, 30.0, 156.0),
			"weaponNew" : RgbToColor(74.0, 33.0, 4.0),
		},
		"textures" : {
			
		}
	},
	4 : {
		"name": "Flamespitter",
		"description" : "The remnants of the great calamity bahamut.",
		"type" : "Staff",
		"slot" : "weapon",
		
		"damage" : [200,300],
		"rof" : 500,
		"stats" : {
					
		},
		"range" : 8,
		"tier" : "UT",
		"projectile" : "FlameBlast",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(6,1)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(251.0, 255.0, 145.0)
		},
		"textures" : {
			"weaponTexture" : "flame",
		}
	},
}

var projectiles = {
	"GreySlash" : {
		"damage" : 10,
		"speed" : 50,
		"tile_range" : 8,
		"piercing" : false,
		"formula" : "0"
	},
	"GoldenArrow" : {
		"damage" : 50,
		"speed" : 100,
		"tile_range" : 8,
		"piercing" : true,
		"formula" : "0"
	},
	"FlameBlast" : {
		"damage" : 200,
		"speed" : 100,
		"tile_range" : 8,
		"piercing" : true,
		"formula" : "sin(x)"
	}
}

var achievements = {
	"Bow Projectiles I" : {
		"which" : "bow_projectiles",
		"amount" : 10
	},
	"Sword Projectiles I" : {
		"which" : "sword_projectiles",
		"amount" : 10
	},
	"Staff Projectiles I" : {
		"which" : "staff_projectiles",
		"amount" : 10
	},
	"Trial By Fire" : {
		"which" : "bow_projectiles",
		"amount" : 20
	}
}

var characters = {
	"Apprentice" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
			"Bow Projectiles I" :  "Nomad",
			"Sword Projectiles I" : "Noble",
			"Staff Projectiles I" : "Scholar",
		},
		"rect" : Rect2(0,0,80,40),
		"icon" : Vector2(0,210),
		"color" : Color(196.0/255, 184.0/255, 146.0/255),
		"bonus_stats" : {
			"health" : 0,
			"attack" : 0,
			"defense" : 0,
			"speed" : 0,
			"dexterity" : 0,
			"vitality" : 0
		},
		"multipliers" : {
		},
		"description" : "The ultimate jack of all trades, the apprentice is a quick learner who can wield any weapon.",
		"ascension_stones" : 5,
	},
	"Noble" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,40,80,40),
		"icon" : Vector2(20,210),
		"color" : Color(252.0/255, 139.0/255, 14.0/255),
		"bonus_stats" : {
			"health" : 200,
			"attack" : 10,
			"defense" : 20,
			"speed" : 10,
			"dexterity" : 10,
			"vitality" : 20
		},
		"multipliers" : {
			"Sword" : {"damage" : 1.2, "stats" : 1.2},
			"Armor" : {"stats" : 1.2},
			"Helmet" : {"stats" : 1.2},
		},
		"description" : "The Noble's strength and bravery dominate the battlefield.",
		"teaser" : "Discover by becoming one with the blade.",
		"ascension_stones" : 50,
	},
	"Nomad" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(80,80,80,40),
		"icon" : Vector2(10,210),
		"color" : Color(78.0/255, 166.0/255, 63.0/255),
		"bonus_stats" : {
			"health" : 100,
			"attack" : 20,
			"defense" : 10,
			"speed" : 20,
			"dexterity" : 20,
			"vitality" : 10
		},
		"multipliers" : {
			"Bow" : {"rof" : 3, "stats" : 1.2},
			"Leather" : {"stats" : 1.2},
			"Cap" : {"stats" : 1.2},
		},
		"description" : "Swift and precise, the Nomad's arrows strike fear into distant foes.",
		"teaser" : "Discover by becoming one with the arrow.",
		"ascension_stones" : 50,
	},
	"Scholar" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(160,120,80,40),
		"icon" : Vector2(30,210),
		"color" : Color(62.0/255, 118.0/255, 255.0/255),
		"bonus_stats" : {
			"health" : 100,
			"attack" : 30,
			"defense" :0,
			"speed" : 10,
			"dexterity" : 30,
			"vitality" : 10
		},
		"multipliers" : {
			"Staff" : {"damage" : 1.2, "stats" : 1.2},
			"Robe" : {"stats" : 1.2},
			"Hat" : {"stats" : 1.2},
		},
		"description" : "With powerful spells and vast intellect, the Scholar excels at long range.",
		"teaser" : "Discover by becoming one with magic.",
		"ascension_stones" : 50,
	},
}

func RgbToColor(r, g, b):
	return Color(r/255, g/255, b/255)

func GetMultiplier(item):
	var _item = items[int(item)].duplicate(true)
	var result = {}
	
	for type in characters[current_class].multipliers.keys():
		var multipliers = characters[current_class].multipliers[type]
		if _item.type == type:
			for subject in multipliers.keys():
				result[subject] = multipliers[subject]
		
	return result

func GetItem(item, include_class_boost = false):
	if items.has(int(item)) and include_class_boost:
		var _item = items[int(item)].duplicate(true)
		for type in characters[current_class].multipliers.keys():
			var multipliers = characters[current_class].multipliers[type]
			if _item.type == type:
				for subject in multipliers.keys():
					if subject == "damage":
						_item[subject][0] = floor(_item[subject][0]*multipliers[subject])
						_item[subject][1] = floor(_item[subject][1]*multipliers[subject])
					elif subject == "stats":
						print(_item[subject])
						for stat in _item[subject]:
							_item[subject][stat] = floor(_item[subject][stat]*multipliers[subject])
						print(_item[subject])
					else:
						_item[subject] = floor(_item[subject]*multipliers[subject])
		
		return _item
	elif items.has(int(item)):
		return items[int(item)]
	else:
		return null

func GetProjectile(projectile):
	if projectiles.has(projectile):
		return projectiles[projectile]
	else:
		return null

func GetCharacter(character):
	if characters.has(character):
		return characters[character]
	else:
		return null

func GetEnemy(enemy):
	if enemies.has(enemy):
		return enemies[enemy]
	else:
		return null
		
func GetAchievement(achievement):
	if achievements.has(achievement):
		return achievements[achievement]
	else:
		return null
