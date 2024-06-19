extends TextureButton

var portal_id

func _ready():
	connect("pressed", self, "EnterInstance")
func EnterInstance():
	Server.EnterInstance(portal_id)
