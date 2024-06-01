extends Node2D

var object_id

func _ready():
	$Area2D.connect("area_entered", self, "OnPortal")
	$Area2D.connect("area_exited", self, "OffPortal")

#Interface Section
func OnPortal(body):
	if body.get_parent().has_method("DefinePlayerState"):
		GameUI.get_node("EnterPortal").visible = true
		GameUI.get_node("EnterPortal").portal_id = object_id
func OffPortal(body):
	if body.get_parent().has_method("DefinePlayerState"):
		GameUI.get_node("EnterPortal").visible = false
		GameUI.get_node("EnterPortal").portal_id = null
