extends Node2D
var id
var timer = 0

func _physics_process(delta):
	timer += delta
	if timer > 10:
		queue_free()
	
	if id:
		var scene = Server.get_node("../SceneHandler/"+Server.GetCurrentInstance())
		var camera = scene.get_node("YSort/player/Camera2D")
		var root_pos = scene.get_node("YSort/player").global_position
		
		if scene.has_node("YSort/OtherPlayers/"+id):
			var node = scene.get_node("YSort/OtherPlayers/"+id)
			self.position = (node.global_position - root_pos)/0.18
			self.z_index = node.global_position.y
		elif id == str(get_tree().get_network_unique_id()):
			self.position = Vector2.ZERO
			self.z_index = root_pos.y
		else:
			queue_free()

func Update(_id, text):
	$PanelContainer/MarginContainer/Label.text = text
	id = _id
	timer = 0
