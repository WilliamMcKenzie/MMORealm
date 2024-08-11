extends Container

var current_quest = null
var direction = Vector2(4,0)

func _process(delta):
	
	rect_position = Vector2(400,180)
	while(not OutsideScreen(self)):
		rect_position += direction

func VisibleByCamera(node, camera):
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
	
	var screen_rect = Rect2(Vector2(-400, -200), screen_size)
	var scene = Server.get_node("../SceneHandler/"+Server.GetCurrentInstance())
	
	var root_pos = scene.get_node("YSort/player").global_position
	var node_pos = (node.global_position - root_pos)/0.18
	var node_size = node.get_node("Control").rect_size
	var node_rect = Rect2(node_pos, node_size)
	
	if screen_rect.encloses(node_rect):
		return true
	return false

func OutsideScreen(ui_node):
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
		
	var screen_rect = Rect2(Vector2(0, 0), screen_size)
	var node_pos = ui_node.rect_global_position
	var node_size = ui_node.rect_size
	var node_rect = Rect2(node_pos, node_size)
	
	if screen_rect.encloses(node_rect):
		return false
	if screen_rect.intersects(node_rect):
		return true
	return false

func SetQuest(quest):
	visible = true
	
	var enemies_container = Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()+"/YSort/Enemies")
	var camera = Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()+"/YSort/player/Camera2D")
	if enemies_container.has_node(quest.id) and VisibleByCamera(enemies_container.get_node(quest.id), camera):
		visible = false
	
	if quest != current_quest:
		current_quest = quest
		var quest_name = quest.name
		var quest_node = load("res://Scenes/SupportScenes/Npcs/" + quest_name + ".tscn")
		if not quest_node:
			for enemy in ClientData.enemies.keys():
				var enemy_data = ClientData.enemies[enemy]
				if enemy_data.has("variations") and enemy_data.variations.has(quest.name):
					quest_node = load("res://Scenes/SupportScenes/Npcs/" + enemy + ".tscn")
		quest_node = quest_node.instance()
		var quest_sprite = quest_node.get_node("Control/Sprite")
		var quest_texture = quest_sprite.texture
		var quest_region = quest_sprite.region_rect
		
		get_node("MarginContainer/TextureRect").texture.atlas = quest_texture
		get_node("MarginContainer/TextureRect").texture.region = Rect2(quest_region.position, Vector2(quest_region.size.y, quest_region.size.y))
	
	var player_position = Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()+"/YSort/player").global_position
	get_node("Node2D").global_position = player_position
	get_node("Node2D").look_at(quest.position)
	get_node("Node2D").position = Vector2(40, 40)
	
	var _direction = ((quest.position - player_position)/0.18).normalized()
	direction = _direction
	
func RemoveQuest():
	visible = false
	current_quest = null
