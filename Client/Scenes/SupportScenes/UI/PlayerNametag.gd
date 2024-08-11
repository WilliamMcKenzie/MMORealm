extends Node2D
var id
var classname

func _process(delta):
	return
	if id and Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()):
		var scene = Server.get_node("../SceneHandler/"+Server.GetCurrentInstance())
		var camera = scene.get_node("YSort/player/Camera2D")
		var root_pos = scene.get_node("YSort/player").global_position
		
		if scene.has_node("YSort/OtherPlayers/"+id):
			var node = scene.get_node("YSort/OtherPlayers/"+id)
			self.position = (node.global_position - root_pos)/0.18
			self.z_index = node.global_position.y
		else:
			queue_free()

func Update(_id, _classname, username):
	print(username)
	$PlayerName/Name.text = username
	if _classname != classname:
		classname = _classname
		var icon_coords = ClientData.GetCharacter(classname).icon
		$PlayerName/Icon.texture.region = Rect2(icon_coords, Vector2(10, 10))
	
	id = _id
