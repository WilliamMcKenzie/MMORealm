extends MarginContainer

func _ready():
	$Guest/Remove.connect("pressed", self, "RemoveGuest")

func RemoveGuest():
	Server.RemoveGuest(name)
