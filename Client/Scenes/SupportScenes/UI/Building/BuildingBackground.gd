extends TextureButton

func can_drop_data(position, data):
	return true
	
func drop_data(position, type):
	last_placement = OS.get_system_time_msecs()
	position = CalculateGamePosition(position, type)
	GameUI.get_node("Building").PlaceBuilding(position, type)

func CalculateGamePosition(mouse_position, type):
	if not ClientData.GetBuilding(type):
		type = "storage"
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
	var result = offset_position*0.2/Settings.zoom + root_pos
	var tile_coord = result/8
	var tile_result = Vector2(round(tile_coord.x-0.5), round(tile_coord.y-1))
	var building_result = (Vector2(round(tile_coord.x-0.5), round(tile_coord.y-1))*8) + Vector2(4, 4)
	return tile_result if is_tile else building_result

var last_placement = 0
var dragging = false
var last_tile = Vector2.ZERO
func _physics_process(delta):
	if not visible:
		dragging = false
		return
	
	var brush = GameUI.get_node("Building").brush
	if dragging and OS.get_system_time_msecs() - last_placement > 100 and brush:
		last_placement = OS.get_system_time_msecs()
		GameUI.get_node("Building").PlaceBuilding(CalculateGamePosition(get_global_mouse_position(), brush))
	
	var preview_node = Server.GetCurrentInstanceNode().get_node("PlacementPreview")
	var tile_pos = CalculateGamePosition(get_global_mouse_position(), "grass")
	var tile = ClientData.GetBuilding(brush).tile if brush and ClientData.GetBuilding(brush) and ClientData.GetBuilding(brush).has("tile") else 0
	if tile_pos != last_tile and brush:
		preview_node.set_cell(tile_pos.x, tile_pos.y, tile)
		preview_node.set_cell(last_tile.x, last_tile.y, -1)
		last_tile = tile_pos

func _ready():
	connect("button_down", self, "Event")
	connect("button_up", self, "StopDrag")

func StopDrag():
	dragging = false
func Event():
	var position = get_global_mouse_position()
	var brush = GameUI.get_node("Building").brush
	if not visible:
		return
	
	dragging = true
	if OS.get_system_time_msecs() - last_placement > 200 and brush:
		last_placement = OS.get_system_time_msecs()
		GameUI.get_node("Building").PlaceBuilding(CalculateGamePosition(position, brush))
