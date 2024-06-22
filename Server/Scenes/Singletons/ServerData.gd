extends Node

var enemies = {
	"snake" : {
		"health" : 40,
		"defense" : 1,
		"exp" : 20,
		"behavior" : 1
	},
	"crab" : {
		"health" : 60,
		"defense" : 1,
		"exp" : 20,
		"behavior" : 1
	},
	"tribesman" : {
		"health" : 100,
		"defense" : 1,
		"exp" : 20,
		"behavior" : 1
	},
	"shaman" : {
		"health" : 200,
		"defense" : 1,
		"exp" : 20,
		"behavior" : 1
	},
	"rock_golem" : {
		"health" : 200,
		"defense" : 1,
		"exp" : 20,
		"behavior" : 1
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
			"bladeHiltNew" : RgbToColor(105.0, 51.0, 10.0),
			"bladeNew" : RgbToColor(174.0, 172.0, 156.0)
		},
		"textures" : {}
	},
	2 : {
		"name": "Void Armor",
		"description" : "A soldiers first line of defense.",
		"type" : "Armor",
		"slot" : "armor",
		"tier" : "5",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,5)],
		"colors" : {
			"helmetDarkNew" : RgbToColor(46.0, 57.0, 84.0),
			"helmetLightNew" : RgbToColor(80.0, 89.0, 111.0),
			"helmetMediumNew" : RgbToColor(64.0, 73.0, 97.0),
		},
		"textures" : {
			"bodyTexture" : "tile",
		}
	},
	3 : {
		"name": "Greenie Bow",
		"description" : "Tester bow for testers.",
		"type" : "Bow",
		"slot" : "weapon",
		
		"damage" : [15,25],
		"rof" : 200,
		"stats" : {
					
		},
		"range" : 6,
		"tier" : "5",
		"projectile" : "GoldenArrow",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,2)],
		"colors" : {
			"arrowNew" : RgbToColor(175.0, 106.0, 107.0)
		},
		"textures" : {
			"bowTexture" : "tile",
		}
	},
	4 : {
		"name": "Flamespitter",
		"description" : "The remnants of the great calamity bahamut.",
		"type" : "Staff",
		"slot" : "weapon",
		
		"damage" : [40,70],
		"rof" : 120,
		"stats" : {
					
		},
		"range" : 8,
		"tier" : "UT",
		"projectile" : "GoldenArrow",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(6,1)],
		"colors" : {
			"arrowNew" : RgbToColor(175.0, 106.0, 107.0)
		},
		"textures" : {
			"bowTexture" : "tile",
		}
	},
}

var projectiles = {
	"GreySlash" : {
		"damage" : 10,
		"speed" : 50,
		"tile_range" : 8,
		"piercing" : false
	},
	"GoldenArrow" : {
		"damage" : 50,
		"speed" : 100,
		"tile_range" : 8,
		"piercing" : false
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
		
