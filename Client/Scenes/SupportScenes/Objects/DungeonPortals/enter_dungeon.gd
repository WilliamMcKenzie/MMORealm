extends Node2D

var object_id
var portal_name
var ruler
var island_translation = {
	"oranix" : Vector2(0,18),
	"vajira" : Vector2(0,36),
	"raa'sloth" : Vector2(0,54),
	"salazar" : Vector2(0,72),
}

func _ready():
	randomize()
	$Area2D.connect("area_entered", self, "OnPortal")
	$Area2D.connect("area_exited", self, "OffPortal")
	var scale_amt = round(rand_range(0.9, 1.2))
	if has_node("Control"):
		$Control.rect_scale = Vector2(scale_amt,scale_amt)
	if ruler and island_translation.has(ruler):
		$Control/Sprite.region_rect.position = island_translation[ruler]

#Interface Section
func OnPortal(body):
	if body.get_parent().has_method("DefinePlayerState"):
		GameUI.get_node("EnterPortal").visible = true
		GameUI.get_node("EnterPortal").portal_id = object_id
		GameUI.get_node("EnterPortal").portal_name = portal_name

func OffPortal(body):
	if body.get_parent().has_method("DefinePlayerState"):
		GameUI.get_node("EnterPortal").visible = false
		GameUI.get_node("EnterPortal").portal_id = "NULL"
		GameUI.get_node("EnterPortal").portal_name = "NULL"
