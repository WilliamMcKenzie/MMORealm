extends Node2D

var object_id
export var npc_name = "tutorial_master"
export var dialogue_trigger = "Tutorial"

func _ready():
	$Area2D.connect("area_entered", self, "onNpc")
	$Area2D.connect("area_exited", self, "OffNpc")

#Interface Section
func onNpc(body):
	if body.get_parent().has_method("DefinePlayerState"):
		GameUI.get_node("TalkNpc").visible = true
		GameUI.get_node("TalkNpc").npc_name = npc_name
		GameUI.get_node("TalkNpc").dialogue_trigger = dialogue_trigger

func OffNpc(body):
	if body.get_parent().has_method("DefinePlayerState"):
		GameUI.get_node("TalkNpc").visible = false
		GameUI.get_node("TalkNpc").dialogue_trigger = "NULL"
