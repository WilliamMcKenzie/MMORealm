extends CanvasLayer

var inspecting_item = null

var loot = null
var loot_container_id = null
var loot_containers = {}

func _ready():
	$InventoryBackground.connect("button_down", self, "ToggleInventory")

func InspectItem(_item):
	if inspecting_item == _item:
		DeInspectItem(_item)
		return
	
	var item = ClientData.GetItem(_item.item)
	
	var animator = $InventoryAnimations
	animator.play("InspectItem")
	inspecting_item = _item
	$InspectItem.visible = true
		
	$InspectItem/MarginContainer/VBoxContainer/ItemName.text = item.name
	$InspectItem/MarginContainer/VBoxContainer/ItemSpriteContainer/ItemSprite.texture.region = Rect2(item.path[3]*10, Vector2(10, 10))
	$InspectItem/MarginContainer/VBoxContainer/ItemDescription.text = item.description + "\n"

	$InspectItem/MarginContainer/VBoxContainer/ItemStats/Tier.text = "Tier: " + item.tier
	if item.has("damage"):
		$InspectItem/MarginContainer/VBoxContainer/ItemStats/Damage.text = "Damage: " + str(item.damage[0]) + "-" + str(item.damage[1])
		$InspectItem/MarginContainer/VBoxContainer/ItemStats/Damage.visible = true
	else:
		$InspectItem/MarginContainer/VBoxContainer/ItemStats/Damage.visible = false
	
	var stats_node = $InspectItem/MarginContainer/VBoxContainer/ItemStats
	var item_stats = item.stats
	
	var health_node = stats_node.get_node("HBoxContainer/Stats1/Health")
	var attack_node = stats_node.get_node("HBoxContainer/Stats2/Attack")
	var defense_node = stats_node.get_node("HBoxContainer/Stats1/Defense")
	var speed_node = stats_node.get_node("HBoxContainer/Stats2/Speed")
	var dexterity_node = stats_node.get_node("HBoxContainer/Stats1/Dexterity")
	var vitality_node = stats_node.get_node("HBoxContainer/Stats2/Vitality")
	
	var stats = {
		"health" : health_node,
		"attack" : attack_node,
		"defense" : defense_node,
		"speed" : speed_node,
		"dexterity" : dexterity_node,
		"vitality" : vitality_node
	}
	
	for stat in stats.keys():
		var node = stats[stat]
		var capitalized_stat = stat.substr(0, 1).to_upper() + stat.substr(1).to_lower()
		
		if item_stats.has(stat):
			if item_stats[stat] > 0:
				node.text = capitalized_stat + ": +" + str(item_stats[stat])
			else:
				node.text = capitalized_stat + ": " + str(item_stats[stat])
			node.visible = true
		else:
			node.visible = false
func DeInspectItem(item):
	if inspecting_item == item:
		var animator = $InventoryAnimations
		animator.play("DeInspectItem")
		inspecting_item = null
		
		var timer = Timer.new()
		timer.wait_time = 0.2
		timer.one_shot = true
		add_child(timer)
		timer.start()
		yield(timer, "timeout")
		
		$InspectItem.visible = false

func ToggleInventory():
	get_parent().ToggleInventory()

func OpenInventory():
	var gear_tween = $GearTween
	var backpack_tween = $BackpackTween
	var loot_tween = $LootTween
	
	var gear_element = $PanelContainer
	var backpack_element = $BackpackContainer
	var loot_element = $LootContainer
	
	gear_tween.interpolate_property(gear_element, "rect_position", gear_element.rect_position, Vector2(0, -110)+gear_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	gear_tween.start()
	backpack_tween.interpolate_property(backpack_element, "rect_position", backpack_element.rect_position, Vector2(-100, 0)+backpack_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	backpack_tween.start()
	loot_tween.interpolate_property(loot_element, "rect_position", loot_element.rect_position, Vector2(100, 0)+loot_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	loot_tween.start()
	$InventoryBackground.visible = true

func CloseInventory():
	var gear_tween = $GearTween
	var backpack_tween = $BackpackTween
	var loot_tween = $LootTween
	
	var gear_element = $PanelContainer
	var backpack_element = $BackpackContainer
	var loot_element = $LootContainer
	
	gear_tween.interpolate_property(gear_element, "rect_position", gear_element.rect_position, Vector2(0, 110)+gear_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	gear_tween.start()
	backpack_tween.interpolate_property(backpack_element, "rect_position", backpack_element.rect_position, Vector2(100, 0)+backpack_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	backpack_tween.start()
	loot_tween.interpolate_property(loot_element, "rect_position", loot_element.rect_position, Vector2(-100, 0)+loot_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	loot_tween.start()
	$InventoryBackground.visible = false

func SetInventory(inventory):
	var inventory_slots = $BackpackContainer/PanelContainer2/MarginContainer/ResizeContainer.get_children()
	var i = 0
	
	for slot in inventory_slots:
		slot.SetItem(inventory[i], 1)
		slot.index = i
		slot.parent = "inventory"
		#slot.connect("pressed", self, "EquipItem", [i])
		i += 1
func SetGear(gear):
	var gear_slots = $PanelContainer/MarginContainer/GearContainer.get_children()
	var gear_types = [
		"weapon",
		"helmet",
		"armor"
	]
	
	for slot_index in range(0, 3):
		var gear_type = gear_types[slot_index]
		
		gear_slots[slot_index].index = gear_type
		gear_slots[slot_index].parent = "gear"
		
		if gear.has(gear_type):
			gear_slots[slot_index].SetItem(gear[gear_type], 1)
		else:
			gear_slots[slot_index].SetItem(null, 1)
func SetLoot(_loot_container_id, _loot):
	loot = _loot
	loot_container_id = _loot_container_id
	
	if loot != null:
		$LootContainer.visible = true
	else:
		$LootContainer.visible = false
		return
	
	var loot_slots = $LootContainer/PanelContainer2/MarginContainer/ResizeContainer.get_children()
	var i = 0
	
	for slot in loot_slots:
		slot.SetItem(loot[i], 1)
		slot.index = i
		slot.parent = loot_container_id
		i += 1

func EquipItem(i):
	Server.EquipItem(i)
func ChangeItem(to_data, from_data):
	Server.ChangeItem(to_data, from_data)
func DropItem(data):
	Server.DropItem(data)
