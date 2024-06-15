extends Node

var items = {
	1 : {
		"name": "Short Sword",
		"description" : "A simple yet effective weapon.",
		"type" : "Sword",
		"slot" : 0,
		
		"damage" : [15,25],
		"rof" : 100,
		"stats" : {
					
		},
		"range" : 3,
		"tier" : 0,
		"projectile" : "Slash",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,2)],
		"colors" : {
			"bladeNew" : RgbToColor(175.0, 106.0, 107.0),
			"bladeHiltNew" : RgbToColor(175.0, 106.0, 107.0)
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
