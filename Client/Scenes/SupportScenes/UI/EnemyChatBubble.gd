extends Node2D
var id
var timer = 0

func _physics_process(delta):
	timer += delta
	if timer > 4:
		queue_free()
	
	if id and Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()):
		var scene = Server.get_node("../SceneHandler/"+Server.GetCurrentInstance())
		var camera = scene.get_node("YSort/player/Camera2D")
		var root_pos = scene.get_node("YSort/player").global_position
		
		if scene.has_node("YSort/Enemies/"+id):
			var node = scene.get_node("YSort/Enemies/"+id)
			self.position = (node.get_node("IndicatorPlaceholder").global_position - root_pos)/0.2
			self.z_index = node.global_position.y
			self.visible = true
		else:
			self.visible = false

func Update(_id, text):
	$PanelContainer/MarginContainer/Label.text = text
	id = _id
	timer = 0
