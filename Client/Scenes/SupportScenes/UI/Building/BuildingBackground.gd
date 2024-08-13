extends TextureButton

func can_drop_data(position, data):
	return true
	
func drop_data(position, type):
	last_placement = OS.get_system_time_msecs()
	position = CalculateGamePosition(position, type)
	GameUI.get_node("Building").PlaceBuilding(position, type)

func CalculateGamePosition(mouse_position, type):
	var is_tile = ClientData.GetBuilding(type).has("tile")
	
	var scene = Server.get_node("../SceneHandler/"+Server.GetCurrentInstance())
	var camera = scene.get_node("YSort/player/Camera2D")
	var root_pos = scene.get_node("YSort/player").global_position
	
	var screen_size = OS.window_size
	var base_screen_size = Vector2(800,360)
	
	var screen_ratio = screen_size.x/screen_size.y
	var base_screen_ratio = base_screen_size.x/base_screen_size.y
	
	if screen_ratio > base_screen_ratio:
		screen_size.x = (screen_size.x/screen_size.y)*base_screen_size.y
		screen_size.y = base_screen_size.y
	else:
		screen_size.y = (screen_size.y/screen_size.x)*base_screen_size.x
		screen_size.x = base_screen_size.x
	
	var offset_position = mouse_position - screen_size/2
	var result = offset_position*0.18 + root_pos
	if is_tile:
		var tile_coord = result/8
		return Vector2(floor(tile_coord.x), floor(tile_coord.y-0.5))
	return result

var last_placement = 0
var dragging = false
func _physics_process(delta):
	if not visible:
		dragging = false
	var brush = GameUI.get_node("Building").brush
	if dragging and OS.get_system_time_msecs() - last_placement > 100 and brush:
		last_placement = OS.get_system_time_msecs()
		GameUI.get_node("Building").PlaceBuilding(CalculateGamePosition(get_global_mouse_position(), brush))

func _unhandled_input(event):
	if not visible:
		return
	var brush = GameUI.get_node("Building").brush
	if event is InputEventMouseButton:
		if dragging:
			dragging = false
		else:
			dragging = true
	if event is InputEventMouseButton and OS.get_system_time_msecs() - last_placement > 200 and brush:
		last_placement = OS.get_system_time_msecs()
		GameUI.get_node("Building").PlaceBuilding(CalculateGamePosition(event.position, brush))
