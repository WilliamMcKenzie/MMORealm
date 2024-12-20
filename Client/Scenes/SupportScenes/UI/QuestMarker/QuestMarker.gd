extends Container

var current_quest = null
var direction = Vector2(4,0)

var current_texture = 1
var texture_8x8 = preload("res://Assets/npcs/enemies_8x8.png")
var texture_16x16 = preload("res://Assets/npcs/enemies_16x16.png")
var texture_32x32 = preload("res://Assets/npcs/enemies_32x32.png")

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
	var level = GameUI.last_character.level
	
	if Server.GetCurrentInstance() == "nexus" and level >= 16:
		quest = {}
		quest.position = Vector2(0,-25*8)
		if {"docks":true} != current_quest:
			get_node("MarginContainer/TextureRect").texture.atlas = load("res://Assets/objects/objects_16x16.png")
			get_node("MarginContainer/TextureRect").texture.region = Rect2(Vector2.ZERO, Vector2(18,18))
		current_quest = {"docks":true}
		if Server.IsWithinRange(Vector2(0,-25*8), 13):
			visible = false
	elif Server.GetCurrentInstance() == "nexus" and level < 16:
		quest = {}
		quest.position = Vector2(-19*8,-39*8)
		if {"docks":true} != current_quest:
			get_node("MarginContainer/TextureRect").texture.atlas = load("res://Assets/objects/objects_16x16.png")
			get_node("MarginContainer/TextureRect").texture.region = Rect2(Vector2.ZERO, Vector2(18,18))
		current_quest = {"docks":true}
		if Server.IsWithinRange(Vector2(-19*8,-39*8), 13):
			visible = false
	else:
		var enemies_container = Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()+"/YSort/Enemies")
		var camera = Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()+"/YSort/player/Camera2D")
		if enemies_container.has_node(quest.id) and VisibleByCamera(enemies_container.get_node(quest.id), camera):
			visible = false
		
		if quest != current_quest:
			current_quest = quest
			var quest_name = quest.name
			var quest_data = ClientData.GetEnemy(quest_name)
			var quest_region = quest_data.rect
			var quest_texture
			
			var res = quest_data.res
			if res == 10:
				quest_texture = texture_8x8
			if res == 18:
				quest_texture = texture_16x16
			if res == 38:
				quest_texture = texture_32x32
			
			get_node("MarginContainer/TextureRect").texture.atlas = quest_texture
			get_node("MarginContainer/TextureRect").texture.region = Rect2(quest_region.position, Vector2(quest_region.size.y, quest_region.size.y))
	
	if Server.has_node("../SceneHandler/"+Server.GetCurrentInstance()+"/YSort/player"):
		var player_position = Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()+"/YSort/player").global_position
		get_node("Node2D").global_position = player_position
		get_node("Node2D").look_at(quest.position)
		get_node("Node2D").position = Vector2(40, 40)
		
		var _direction = ((quest.position - player_position)/0.18).normalized()
		direction = _direction
	
func RemoveQuest():
	visible = false
	current_quest = null
