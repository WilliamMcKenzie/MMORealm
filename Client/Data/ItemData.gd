extends Node

var items = {
	1 : {
		"name": "Short Sword",
		"description" : "A simple yet effective weapon.",
		"type" : "Staff",
		"slot" : 0,
		
		"damage" : [15,25],
		"rof" : 100,
		"stats" : {
					
		},
		"range" : 3,
		"tier" : 0,
		"projectile" : "Small",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,2)],
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
		"slot" : 0,
		
		"damage" : [15,25],
		"rof" : 100,
		"stats" : {
					
		},
		"range" : 3,
		"tier" : 0,
		"projectile" : "Small",
		
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
		"name": "Void Blade",
		"description" : "A simple yet effective weapon.",
		"type" : "Sword",
		"slot" : 0,
		
		"damage" : [15,25],
		"rof" : 100,
		"stats" : {
					
		},
		"range" : 3,
		"tier" : 0,
		"projectile" : "Small",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,2)],
		"colors" : {
			"bladeHiltNew" : RgbToColor(175.0, 106.0, 107.0)
		},
		"textures" : {
			"swordTexture" : "tile",
		}
	},
}

func RgbToColor(r, g, b):
	return Color(r/255, g/255, b/255)

func GetItem(item):
	if items.has(item):
		return items[item]
	else:
		return null
