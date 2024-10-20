extends Node2D

export var item_stand = false
var object_id
var loot

func _ready():
	$Area2D.connect("area_entered", self, "OnBag")
	$Area2D.connect("area_exited", self, "OffBag")
	UpdateLoot(loot)

func UpdateLoot(_loot):
	if (GameUI.get_node("Inventory").loot_container_id == object_id) and not UtilityFunctions.CompareArrays(loot, _loot):
		loot = _loot
		GameUI.get_node("UtilityButtons/LootButton").UpdateLoot(object_id, loot)
	elif item_stand and loot[0]:
		var item_coords = ClientData.GetItem(loot[0].item).path[3]
		$Item.frame_coords = item_coords
		$Item.visible = true
	elif item_stand:
		$Item.visible = false

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
			
			var item = ClientData.GetItem(raw_item.item)
			if int(item.tier) > highest_loot_tier:
				highest_loot_tier = int(item.tier)
			elif item.tier == "UT":
				highest_loot_tier = 6
		
		tier = loot_bag_tier_translation[highest_loot_tier]
		GameUI.get_node("UtilityButtons/LootButton").ActivateLootButton(object_id, loot, tier, position)
		if Settings.auto_open_chests:
			GameUI.Toggle("inventory")

func OffBag(body):
	if body.get_parent().has_method("DefinePlayerState"):
		GameUI.get_node("UtilityButtons/LootButton").DisableLootButton(object_id)
		if Settings.auto_open_chests and GameUI.get_node("Inventory").active:
			GameUI.Toggle("inventory")
