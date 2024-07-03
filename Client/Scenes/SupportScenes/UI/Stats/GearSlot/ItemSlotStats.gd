extends TextureButton

var parent
var index

var dragging = false
var item = null
var quantity = 1

func _ready():
	connect("pressed", self, "InspectItem")
	connect("mouse_exited", self, "DeInspectItem")
	connect("focus_exited", self, "DeInspectItem")

func can_drop_data(position, data):
	return false

func InspectItem():
	GameUI.get_node("Inventory").InspectItem(item)
func DeInspectItem():
	GameUI.get_node("Inventory").DeInspectItem(item)

func SetItem(_item, _quantity):
	item = _item
	quantity = _quantity
	
	if item == null:
		$ItemIcon.visible = false
		$ItemBackground.visible = true
	else:
		$ItemIcon.visible = true
		$ItemBackground.visible = false
		SetSpriteData($ItemIcon, ClientData.GetItem(item.item).path)

func GetItem():
	return {
		"Item" : item,
		"Quantity" : quantity
	}

func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0])
	sprite.texture = AtlasTexture.new()
	
	sprite.texture.atlas = spriteTexture
	sprite.texture.region = Rect2(path[3]*10, Vector2(10,10))
	
