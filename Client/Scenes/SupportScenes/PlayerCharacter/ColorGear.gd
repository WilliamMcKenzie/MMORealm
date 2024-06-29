extends Sprite

var texture_params = {
	
}

var unique_texture_params = {
	
}

var default_texture_params = {
	
}

var color_params = {
	
}

var unique_color_params = {
	
}

var default_color_params = {
	
	"helmetDarkOrigin" : RgbaToColor(255.0, 255.0, 0, 200),
	"helmetDarkNew" : RgbToColor(94.0, 84.0, 84.0),
	
	"helmetLightOrigin" : RgbToColor(255.0, 100.0, 0),
	"helmetLightNew" : RgbToColor(135.0, 117.0, 117.0),
	
	"helmetMediumOrigin" : RgbToColor(255.0, 204.0, 225),
	"helmetMediumNew" : RgbToColor(108.0, 99.0, 99.0),
	
	"bodyLightOrigin" : RgbToColor(255.0, 255.0, 255.0),
	"bodyLightNew" : RgbToColor(216.0, 216.0, 216.0),
	
	"bodyMediumOrigin" : RgbToColor(255.0, 51.0, 255.0),
	"bodyMediumNew" : RgbToColor(190.0, 190.0, 190.0),
	
	"bodyDarkOrigin" : RgbToColor(255.0, 100.0, 255.0),
	"bodyDarkNew" : RgbToColor(124.0, 124.0, 124.0),
	
	"bandOrigin" : RgbToColor(255.0, 0, 100.0),
	"bandNew" : RgbToColor(144.0, 81.0, 38.0),
	
	"buckleOrigin" : RgbToColor(150.0, 0, 100.0),
	"buckleNew" : RgbToColor(130.0, 130.0, 130.0),
	
	"bladeOrigin" : RgbToColor(255.0, 0, 0),
	"bladeNew" : RgbToColor(132.0, 132.0, 132.0),
	
	"bladeHiltOrigin" : RgbToColor(0.0, 255.0, 255.0),
	"bladeHiltNew" : RgbToColor(144.0, 81.0, 38.0),
	
	"bowOrigin" : RgbToColor(255.0, 255.0, 0.0),
	"bowNew" : RgbToColor(144.0, 81.0, 38.0),
	
	"arrowLightOrigin" : RgbToColor(0, 0, 255.0),
	"arrowLightNew" : RgbToColor(216.0, 216.0, 216.0),
	
	"arrowDarkOrigin" : RgbToColor(0, 0, 255.0),
	"arrowDarkNew" : RgbToColor(190.0, 190.0, 190.0),
	
	"staffOrigin" : RgbToColor(255.0, 0.0, 255.0),
	"staffNew" : RgbToColor(144.0, 81.0, 38.0),
	
	"staffGemOrigin" : RgbToColor(0.0, 255.0, 0.0),
	"staffGemNew" : RgbToColor(255.0, 255.0, 255.0),
}

func GetParams():
	return {
		"TextureParams" : unique_texture_params,
		"ColorParams" : unique_color_params,
	}
func SetParams(params):
	texture_params = params["TextureParams"]
	color_params = params["ColorParams"]
	
	var mock_gear = {
		"params" : {
			"colors" : color_params,
			"textures" : texture_params,
		}
	}
	
	ColorGear(mock_gear)

func _ready():
	ColorGear({})

func RgbToColor(r, g, b):
	return Color(r/255, g/255, b/255)
func RgbaToColor(r, g, b, a):
	return Color(r/255, g/255, b/255, a)

func SetCharacterClass(character_class):
	var character = ClientData.GetCharacter(character_class)
	var rect = character.rect
	self.set_region_rect(rect)
func SetCharacterWeapon(weapon_type):
	var rect = self.region_rect
	if weapon_type == "Sword":
		rect.position.x = 0.0
	if weapon_type == "Bow":
		rect.position.x = 80.0
	if weapon_type == "Staff":
		rect.position.x = 160.0
	self.region_rect = rect

func ColorGear(gear):
	var shader_material = ShaderMaterial.new()
	shader_material.shader = load("res://Resources/ColorGear.gdshader")
	
	self.material = shader_material
	
	#Get color params
	color_params = default_color_params.duplicate(true)
	texture_params = default_texture_params.duplicate(true)
	unique_color_params = {}
	unique_texture_params = {}
	
	for slot in gear.keys():
		var item = gear[slot]
		var item_colors = item.colors
		var item_textures = item.textures
		
		for key in item_colors.keys():
			color_params[key] = item_colors[key]
			unique_color_params[key] = item_colors[key]
		for key in item_textures.keys():
			texture_params[key] = item_textures[key]
			unique_texture_params[key] = item_textures[key]
	
	for _color in color_params.keys():
		shader_material.set_shader_param(_color, color_params[_color])
	for _texture in texture_params.keys():
		shader_material.set_shader_param(_texture, load("res://Assets/items/textures/" + texture_params[_texture] + ".png"))
		shader_material.set_shader_param(_texture + "Active", true)
