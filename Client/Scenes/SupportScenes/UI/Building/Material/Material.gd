extends HBoxContainer
var type

func SetMaterial(_type):
	type = _type
	SetSpriteData($PanelContainer/MarginContainer/TextureRect, ClientData.GetItem(type).path)

func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0])
	sprite.texture = AtlasTexture.new()
	
	sprite.texture.atlas = spriteTexture
	sprite.texture.region = Rect2(path[3]*10, Vector2(10,10))

func MissingMaterial():
	$PanelContainer/MarginContainer/TextureRect.modulate = Color(132.0/255, 132.0/255, 132.0/255)
func HasMaterial():
	$PanelContainer/MarginContainer/TextureRect.modulate = Color(1,1,1)
