extends Camera2D

onready var target = get_parent().get_node("HBoxContainer")

# Optional: export these properties for convenient editing.
var target_return_enabled = true
var target_return_rate = 0.002
var min_zoom = 0.1
var max_zoom = 20
var zoom_sensitivity = 4
var zoom_speed = 0.06

var event_indexs = []
var events = {}
var last_drag_distance = 0
var relative_index = 0
onready var tree_root = get_parent().get_node("TreeRoot")

func _ready():
	tree_root.rect_pivot_offset = tree_root.rect_size / 2

func _process(delta):
	if target and target_return_enabled and events.size() == 0:
		var viewport_size = get_viewport().get_visible_rect().size
		var center = Vector2(viewport_size.x / 2, viewport_size.y / 2)
		
		tree_root.rect_position = lerp(tree_root.rect_position, center, target_return_rate)

func _unhandled_input(event):
	
	if event is InputEventScreenTouch:
		if event.pressed:
			relative_index = event.index
			events[event.index-relative_index] = event
		else:
			events.erase(event.index-relative_index)

func _input(event):
		
	if event is InputEventScreenDrag:
		events[event.index-relative_index] = event
		if events.size() == 1:
			tree_root.rect_position += event.relative.rotated(rotation) * zoom.x
	
	elif events.size() == 2:
		var event1 = events[events.keys()[0]]
		var event2 = events[events.keys()[1]]
		
		var drag_distance = event1.position.distance_to(event2.position)
		if abs(drag_distance - last_drag_distance) > zoom_sensitivity:
			var new_zoom = (1 + zoom_speed) if drag_distance < last_drag_distance else (1 - zoom_speed)
			tree_root.rect_scale *= Vector2.ONE/(Vector2.ONE * new_zoom)
			last_drag_distance = drag_distance
