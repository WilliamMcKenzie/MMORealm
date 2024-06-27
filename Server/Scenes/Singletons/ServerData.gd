extends Node

var enemies = {
		"Snake" : {
		"Health" : 40,
		"Defense" : 1,
		"Exp" : 20,
		"Behavior" : 1,
		
		attack_pattern = {
			atk1 = {

			"Projectile" : "GreySlash",

			"Formula" : "x",

			"Lifespan" : 5,

			"Wait" : 1,

			}
			}
	},

	"crab" : {
		"Health" : 60,
		"Defense" : 1,
		"Exp" : 20,
		"Behavior" : 1,
		"Projectile" : "GreySlash",
		"Cooldown" : 1
	},
	"tribesman" : {
		"Health" : 100,
		"Defense" : 1,
		"Exp" : 20,
		"Behavior" : 1,
		"Projectile" : "GreySlash",
		"Cooldown" : 1
	},
	"shaman" : {
		"Health" : 200,
		"Defense" : 1,
		"Exp" : 20,
		"Behavior" : 1,
		"Projectile" : "GreySlash",
		"Cooldown" : 1
	},
	"rock_golem" : {
		"health" : 200,
		"defense" : 1,
		"exp" : 20,
		"behavior" : 1,
		"projectile" : "GreySlash",
		"cooldown" : 1
	}
}

var items = {
	1 : {
		"Name": "Short Sword",
		"Description" : "A simple yet effective weapon.",
		"Type" : "Sword",
		"Slot" : "weapon",
		
		"Damage" : [15,25],
		"Rof" : 100,
		"Stats" : {
			"Vitality" : 1
		},
		"Range" : 3,
		"Tier" : "0",
		"Projectile" : "GreySlash",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,0)],
		"Colors" : {
			"bladeHiltNew" : RgbToColor(105.0, 51.0, 10.0),
			"bladeNew" : RgbToColor(174.0, 172.0, 156.0)
		},
		"Textures" : {}
	},
	2 : {
		"Name": "Void Armor",
		"Description" : "A soldiers first line of defense.",
		"Type" : "Armor",
		"Slot" : "armor",
		"Tier" : "5",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,5)],
		"Colors" : {
			"helmetDarkNew" : RgbToColor(46.0, 57.0, 84.0),
			"helmetLightNew" : RgbToColor(80.0, 89.0, 111.0),
			"helmetMediumNew" : RgbToColor(64.0, 73.0, 97.0),
		},
		"Textures" : {
			"bodyTexture" : "tile",
		}
	},
	3 : {
		"Name": "Greenie Bow",
		"Description" : "Tester bow for testers.",
		"Type" : "Bow",
		"Slot" : "weapon",
		
		"Damage" : [15,25],
		"Rof" : 200,
		"Stats" : {
					
		},
		"Range" : 6,
		"Tier" : "5",
		"Projectile" : "GoldenArrow",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,2)],
		"Colors" : {
			"arrowNew" : RgbToColor(175.0, 106.0, 107.0)
		},
		"Textures" : {
			"bowTexture" : "tile",
		}
	},
	4 : {
		"Name": "Flamespitter",
		"Description" : "The remnants of the great calamity bahamut.",
		"Type" : "Staff",
		"Slot" : "weapon",
		
		"Damage" : [40,70],
		"Rof" : 120,
		"Stats" : {
					
		},
		"Range" : 8,
		"Tier" : "UT",
		"Projectile" : "GoldenArrow",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(6,1)],
		"Colors" : {
			"arrowNew" : RgbToColor(175.0, 106.0, 107.0)
		},
		"Textures" : {
			"bowTexture" : "tile",
		}
	},
}

var projectiles = {
	"GreySlash" : {
		"Damage" : 10,
		"Speed" : 50,
		"Tile_range" : 8,
		"Piercing" : false,
		"Size" : Vector2(10,10)
	},
	"GoldenArrow" : {
		"Damage" : 50,
		"Speed" : 100,
		"Tile_range" : 8,
		"Piercing" : false,
		"Size" : Vector2(10,10)
	}
}

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

func RgbToColor(r, g, b):
	return Color(r/255, g/255, b/255)

func GetItem(item):
	if items.has(item):
		return items[item]
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
		
