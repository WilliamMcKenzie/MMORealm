extends Node

var basic_loot_pools = {
	"lowlands_1" : {
		"soulbound_loot" : [
			{
				"item" : 4,
				"chance" : 0.01,
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
	1 : {
		"name": "Short Sword",
		"description" : "A simple yet effective weapon.",
		"type" : "Sword",
		"slot" : "weapon",
		
		"damage" : [15,25],
		"rof" : 100,
		"stats" : {
			"vitality" : 1
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
		"type" : "Armor",
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
	"Trial By Fire" : {
		"which" : "bow_projectiles",
		"amount" : 100
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
		"rect" : Rect2(0,0,80,40)
	}
}

func RgbToColor(r, g, b):
	return Color(r/255, g/255, b/255)

func GetItem(item):
	if items.has(int(item)):
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
