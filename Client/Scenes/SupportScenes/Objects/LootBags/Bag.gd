extends Node2D

var object_id
var loot

func _ready():
	$Area2D.connect("area_entered", self, "OnBag")
	$Area2D.connect("area_exited", self, "OffBag")

func UpdateLoot(_loot):
	if (GameUI.get_node("Inventory").loot_container_id == object_id) and not UtilityFunctions.CompareArrays(loot, _loot):
		loot = _loot
		GameUI.get_node("Inventory").SetLoot(object_id, loot)

#Interface Section
func OnBag(body):
	if body.get_parent().has_method("DefinePlayerState"):
		GameUI.get_node("UtilityButtons/LootButton").ActivateLootButton(object_id, loot)

func OffBag(body):
	if body.get_parent().has_method("DefinePlayerState"):
		GameUI.get_node("UtilityButtons/LootButton").DisableLootButton()
