extends Node2D


func _ready():
	$Area2D.connect("area_entered", self, "OnBag")
	$Area2D.connect("area_exited", self, "OffBag")

#Interface Section
func OnBag(body):
	if body.get_parent().has_node("Camera2D"):
		GameUI.get_node("ShowBag").visible = true

func OffBag(body):
	if body.get_parent().has_node("Camera2D"):
		GameUI.get_node("ShowBag").visible = false
