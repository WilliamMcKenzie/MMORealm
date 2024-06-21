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

func _input(event):
	# Check if the event is a mouse button release
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed() == false:
		if dragging:
			StopDragging()
	
	if event is InputEventScreenTouch and not event.is_pressed():
		if dragging:
			StopDragging()

func StopDragging():
	dragging = false
	
	var timer = Timer.new()
	timer.wait_time = 0.1
	timer.one_shot = true
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	
	GameUI.SetCharacterData(GameUI.last_character)

func get_drag_data(position):
	if item == null:
		return
	dragging = true
	
	var data = {}
	data["parent"] = parent
	data["index"] = index
	
	var drag_texture = TextureRect.new()
	
	drag_texture.expand = true
	drag_texture.texture = AtlasTexture.new()
	drag_texture.texture.atlas = get_node("ItemIcon").texture
	drag_texture.texture.region = Rect2(get_node("ItemIcon").frame_coords*10, Vector2(10,10))
	drag_texture.material = ShaderMaterial.new()
	drag_texture.material.shader = load("res://Resources/ColorGear.gdshader")
	drag_texture.material.set_shader_param("line_thickness", 0.3)
	drag_texture.rect_size = Vector2(40,40)
	
	var preview = Control.new()
	preview.add_child(drag_texture)
	drag_texture.rect_position = -0.5 * drag_texture.rect_size	
	set_drag_preview(preview)
	
	get_node("ItemIcon").visible = false
	
	return data
	
func can_drop_data(position, data):
	return true
	
func drop_data(position, data):
	#If we drop an item in this slot
	var current_data = {
		"parent" : parent,
		"index" : index
	}
	GameUI.get_node("Inventory").ChangeItem(current_data, data)

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
	sprite.texture = spriteTexture
	sprite.hframes = path[1]
	sprite.vframes = path[2]
	sprite.frame_coords = path[3]
	
