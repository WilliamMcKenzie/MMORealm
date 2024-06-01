extends Sprite

var colorParams = {
	"helmetDarkOrigin" : RgbToColor(201.0, 106.0, 0),
	"helmetDarkNew" : RgbToColor(94.0, 84.0, 84.0),
	
	"helmetLightOrigin" : RgbToColor(255.0, 134.0, 0),
	"helmetLightNew" : RgbToColor(135.0, 117.0, 117.0),
	
	"helmetMediumOrigin" : RgbToColor(228.0, 120.0, 0),
	"helmetMediumNew" : RgbToColor(108.0, 99.0, 99.0),
	
	"bodyLightOrigin" : RgbToColor(255.0, 0, 215.0),
	"bodyLightNew" : RgbToColor(216.0, 216.0, 216.0),
	
	"bodyMediumOrigin" : RgbToColor(228.0, 0, 192.0),
	"bodyMediumNew" : RgbToColor(190.0, 190.0, 190.0),
	
	"bandOrigin" : RgbToColor(255.0, 0, 107.0),
	"bandNew" : RgbToColor(144.0, 81.0, 38.0),
	
	"buckleOrigin" : RgbToColor(210.0, 0, 89.0),
	"buckleNew" : RgbToColor(130.0, 130.0, 130.0),
	
	"shouldersLightOrigin" : RgbToColor(0, 134.0, 255.0),
	"shouldersLightNew" : RgbaToColor(130.0, 130.0, 130.0, 0),
	
	"shouldersDarkOrigin" : RgbToColor(53.0, 0, 255.0),
	"shouldersDarkNew" : RgbaToColor(190.0, 190.0, 190.0, 0),
	
	"bladeOrigin" : RgbToColor(255.0, 0, 0),
	"bladeNew" : RgbToColor(132.0, 132.0, 132.0),
	
	"bladeHiltOrigin" : RgbToColor(0, 255.0, 107.0),
	"bladeHiltNew" : RgbToColor(144.0, 81.0, 38.0)
}

func _ready():
	ColorGear()

func RgbToColor(r, g, b):
	return Color(r/255, g/255, b/255)
func RgbaToColor(r, g, b, a):
	return Color(r/255, g/255, b/255, a)

func ColorGear():
	var shader_material = ShaderMaterial.new()
	shader_material.shader = load("res://Resources/ColorGear.gdshader")
	
	self.material = shader_material
	
	for color in colorParams.keys():
		shader_material.set_shader_param(color, colorParams[color])
