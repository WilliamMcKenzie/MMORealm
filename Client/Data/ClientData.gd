extends Node

var enemies = {
	"snake" : {
		"health" : 40,
		"defense" : 1,
		"exp" : 20,
		"behavior" : "Wander"
	},
	"crab" : {
		"health" : 60,
		"defense" : 1,
		"exp" : 20,
		"behavior" : "Wander"
	},
	"tribesman" : {
		"health" : 100,
		"defense" : 1,
		"exp" : 20,
		"behavior" : "Wander"
	},
	"shaman" : {
		"health" : 200,
		"defense" : 1,
		"exp" : 20,
		"behavior" : "Wander"
	},
	"rock_golem" : {
		"health" : 200,
		"defense" : 1,
		"exp" : 20,
		"behavior" : "Wander"
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
		
		"stats" : {
					
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,5)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(0.0, 106.0, 138.0),
			"bodyLightNew" : RgbToColor(0.0, 125.0, 163.0),
			"bandNew" : RgbToColor(225.0, 179.0, 36.0),
			"buckleNew" : RgbToColor(234.0, 234.0, 78.0),
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
			"arrowLightNew" : RgbToColor(125.0, 30.0, 156.0),
			"arrowDarkNew" : RgbToColor(125.0, 30.0, 156.0),
			"bowNew" : RgbToColor(74.0, 33.0, 4.0),
		},
		"textures" : {
			
		}
	},
	4 : {
		"name": "Flamespitter",
		"description" : "The remnants of the great calamity bahamut.",
		"type" : "Staff",
		"slot" : "weapon",
		
		"damage" : [40,70],
		"rof" : 300,
		"stats" : {
					
		},
		"range" : 8,
		"tier" : "UT",
		"projectile" : "FlameBlast",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(6,1)],
		"colors" : {
			"staffGemNew" : RgbToColor(251.0, 255.0, 145.0)
		},
		"textures" : {
			"staffTexture" : "flame",
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
		"piercing" : true
	},
	"FlameBlast" : {
		"damage" : 50,
		"speed" : 150,
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
		
