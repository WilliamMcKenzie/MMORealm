extends Node

var enemies = {
	"snake" : {
		"Health" : 40,
		"Defense" : 1,
		"Exp" : 20,
		"Behavior" : "Wander"
	},
	"crab" : {
		"Health" : 60,
		"Defense" : 1,
		"Exp" : 20,
		"Behavior" : "Wander"
	},
	"tribesman" : {
		"Health" : 100,
		"Defense" : 1,
		"Exp" : 20,
		"Behavior" : "Wander"
	},
	"shaman" : {
		"Health" : 200,
		"Defense" : 1,
		"Exp" : 20,
		"Behavior" : "Wander"
	},
	"rock_golem" : {
		"Health" : 200,
		"Defense" : 1,
		"Exp" : 20,
		"Behavior" : "Wander"
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
		
		"Stats" : {
					
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,5)],
		"Colors" : {
			"bodyMediumNew" : RgbToColor(0.0, 106.0, 138.0),
			"bodyLightNew" : RgbToColor(0.0, 125.0, 163.0),
			"bandNew" : RgbToColor(225.0, 179.0, 36.0),
			"buckleNew" : RgbToColor(234.0, 234.0, 78.0),
		},
		"Textures" : {
			
		}
	},
	3 : {
		"Name": "Shadowbringer Bow",
		"Description" : "A ominous bow, forged from the very essence of darkness.",
		"Type" : "Bow",
		"Slot" : "weapon",
		
		"Damage" : [15,25],
		"Rof" : 100,
		"Stats" : {
					
		},
		"Range" : 6,
		"Tier" : "5",
		"Projectile" : "GoldenArrow",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,2)],
		"Colors" : {
			"arrowLightNew" : RgbToColor(125.0, 30.0, 156.0),
			"arrowDarkNew" : RgbToColor(125.0, 30.0, 156.0),
			"bowNew" : RgbToColor(74.0, 33.0, 4.0),
		},
		"Textures" : {
			
		}
	},
	4 : {
		"Name": "Flamespitter",
		"Description" : "The remnants of the great calamity bahamut.",
		"Type" : "Staff",
		"Slot" : "weapon",
		
		"Damage" : [40,70],
		"Rof" : 300,
		"Stats" : {
					
		},
		"Range" : 8,
		"Tier" : "UT",
		"Projectile" : "FlameBlast",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(6,1)],
		"Colors" : {
			"staffGemNew" : RgbToColor(251.0, 255.0, 145.0)
		},
		"Textures" : {
			"staffTexture" : "flame",
		}
	},
}

var projectiles = {
	"GreySlash" : {
		"Damage" : 10,
		"Speed" : 50,
		"Tile_range" : 8,
		"Piercing" : false
	},
	"GoldenArrow" : {
		"Damage" : 50,
		"Speed" : 100,
		"Tile_range" : 8,
		"Piercing" : true
	},
	"FlameBlast" : {
		"Damage" : 50,
		"Speed" : 150,
		"Tile_range" : 8,
		"Piercing" : false
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
		
