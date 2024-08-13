extends TextureButton

var dragging = false
var type = null
var quantity = 0

func _ready():
	$TouchScreenButton.connect("pressed", self, "InspectBuilding")
	connect("pressed", self, "InspectBuilding")
	connect("mouse_exited", self, "DeInspectBuilding")
	connect("focus_exited", self, "DeInspectBuilding")

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
	get_node("BuildingIcon").visible = true

func get_drag_data(position):
	if type == null:
		return
	dragging = true
	
	var drag_texture = TextureRect.new()
	
	drag_texture.expand = true
	drag_texture.texture = AtlasTexture.new()
	drag_texture.texture.atlas = get_node("BuildingIcon").texture.atlas.duplicate(true)
	drag_texture.texture.region = get_node("BuildingIcon").texture.region
	if get_node("BuildingIcon").material:
		drag_texture.material = get_node("BuildingIcon").material.duplicate()
	drag_texture.rect_size = Vector2(40,40)
	
	var preview = Control.new()
	preview.add_child(drag_texture)
	drag_texture.rect_position = -0.5 * drag_texture.rect_size	
	set_drag_preview(preview)
	
	get_node("BuildingIcon").visible = false
	
	return type
	
func can_drop_data(position, data):
	return false
	
func InspectBuilding():
	GameUI.get_node("Building").SelectBuilding(type)
	GameUI.get_node("Building").InspectBuilding(type)
func DeInspectBuilding():
	GameUI.get_node("Building").DeInspectBuilding(type)

func SetBuilding(_type, _quantity):
	type = _type
	quantity = _quantity
	
	$ResizeContainer/BuildingQuantity.text = "x" + str(quantity)
	$BuildingIcon.texture = $BuildingIcon.texture.duplicate()
	SetSpriteData($BuildingIcon, ClientData.GetBuilding(type).path)

func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0])
	sprite.texture = AtlasTexture.new()
	
	sprite.texture.atlas = spriteTexture
	sprite.texture.region = Rect2(path[3], Vector2(10,10))
	
	if "tileset" in path[0]:
		sprite.material = null
	