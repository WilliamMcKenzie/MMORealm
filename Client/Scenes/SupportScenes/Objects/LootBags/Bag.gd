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
		var highest_loot_tier = 0
		var tier = 0
		var loot_bag_tier_translation = {
			0 : 0,
			1 : 0,
			2 : 1,
			3 : 1,
			4 : 2,
			5 : 2,
			6 : 3,
		}
		
		var i = 0
		for raw_item in loot:
			if raw_item == null:
				continue
			
			loot[i] = raw_item
			i += 1
			var item = ClientData.GetItem(raw_item.item)
			if int(item.tier) > highest_loot_tier:
				highest_loot_tier = int(item.tier)
			elif item.tier == "UT":
				highest_loot_tier = 6

		tier = loot_bag_tier_translation[highest_loot_tier]
		GameUI.get_node("UtilityButtons/LootButton").ActivateLootButton(object_id, loot, tier, position)

func OffBag(body):
	if body.get_parent().has_method("DefinePlayerState"):
		GameUI.get_node("UtilityButtons/LootButton").DisableLootButton(object_id)
