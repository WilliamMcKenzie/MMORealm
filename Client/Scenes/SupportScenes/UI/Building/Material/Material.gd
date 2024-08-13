extends HBoxContainer

func SetMaterial(material):
	SetSpriteData($PanelContainer/MarginContainer/TextureRect, ClientData.GetItem(material).path)

func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0])
	sprite.texture = AtlasTexture.new()
	
	sprite.texture.atlas = spriteTexture
	sprite.texture.region = Rect2(path[3]*10, Vector2(10,10))
