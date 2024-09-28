extends Node2D
var id
var classname

func Update(_id, _classname, username):
	$PlayerName/Name.text = username
	if _classname != classname:
		classname = _classname
		var icon_coords = ClientData.GetCharacter(classname).icon
		$PlayerName/Icon.texture = $PlayerName/Icon.texture.duplicate()
		$PlayerName/Icon.texture.region = Rect2(icon_coords, Vector2(10, 10))
	
	id = _id
