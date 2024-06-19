extends ColorRect

var item = null
var quantity = 1

func SetItem(_item, _quantity):
	item = _item
	quantity = _quantity
	
	if item == null:
		$ItemIcon.visible = false
		$ItemBackground.visible = true
	else:
		$ItemIcon.visible = true
		$ItemBackground.visible = false
		SetSpriteData($ItemIcon, ItemData.GetItem(item.item).path)

func GetItem():
	return {
		"Item" : item,
		"Quantity" : quantity
	}

func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0]) 
	print(path[0])
	sprite.texture = spriteTexture
	sprite.hframes = path[1]
	sprite.vframes = path[2]
	sprite.frame_coords = path[3]
	
