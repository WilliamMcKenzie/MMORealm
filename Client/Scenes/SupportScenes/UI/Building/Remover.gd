extends TextureButton

var dragging = false
var modulation = Color(1,1,1)

var last_click = 10000
func _physics_process(delta):
	last_click += delta

func _ready():
	connect("pressed", self, "Select")

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
	modulate.a = 1

func get_drag_data(position):
	dragging = true
	
	var drag_texture = TextureRect.new()
	
	drag_texture.expand = true
	drag_texture.texture = AtlasTexture.new()
	drag_texture.texture.atlas = texture_normal.atlas.duplicate(true)
	drag_texture.texture.region = texture_normal.region
	drag_texture.material = material.duplicate()
	drag_texture.rect_size = Vector2(40,40)
	
	var preview = Control.new()
	preview.add_child(drag_texture)
	drag_texture.rect_position = -0.5 * drag_texture.rect_size	
	set_drag_preview(preview)
	
	modulate.a = 0
	return "remover"
	
func can_drop_data(position, data):
	return false
	
func Select():
	GameUI.get_node("Building").SelectBuilding("remover")
	
