extends Node2D

var object_id

func _ready():
	randomize()
	$Area2D.connect("area_entered", self, "OnPortal")
	$Area2D.connect("area_exited", self, "OffPortal")
	var scale_amt = round(rand_range(0.9, 1.2))
	if has_node("Control"):
		$Control.rect_scale = Vector2(scale_amt,scale_amt)
	
#Interface Section
func OnPortal(body):
	if body.get_parent().has_method("DefinePlayerState"):
		GameUI.get_node("EnterPortal").visible = true
		GameUI.get_node("EnterPortal").portal_id = object_id

func OffPortal(body):
	if body.get_parent().has_method("DefinePlayerState"):
		GameUI.get_node("EnterPortal").visible = false
		GameUI.get_node("EnterPortal").portal_id = "NULL"
