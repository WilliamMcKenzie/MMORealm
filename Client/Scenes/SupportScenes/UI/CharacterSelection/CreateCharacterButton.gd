extends Node2D

onready var containerButton = $Button
	
func _ready():
	containerButton.connect("pressed", self, "CreateCharacter")

func CreateCharacter():
	var home_node = get_parent().get_parent()
	var email = home_node.email
	var password = home_node.password
	
	Gateway.ConnectToServer(email, password, 2)
	queue_free()
	
