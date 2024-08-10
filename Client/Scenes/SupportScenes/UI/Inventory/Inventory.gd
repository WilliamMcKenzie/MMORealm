extends CanvasLayer

var active = false
var inspecting_item = null

var loot = null
var loot_container_id = null
var loot_containers = {}

func _ready():
	$InventoryBackground.connect("button_down", self, "ToggleInventory")
	$BackpackContainer/CloseButton.connect("pressed", self, "ToggleInventory")
	$BackpackContainer/CloseButton2.connect("pressed", self, "ToggleInventory")
	$LootContainer/CloseButton.connect("pressed", self, "ToggleInventory")
	$LootContainer/CloseButton2.connect("pressed", self, "ToggleInventory")

func InspectItem(_item):
	if not _item:
		return
	
	var bonus_color = ClientData.GetCharacter(ClientData.current_class).color
	var item = ClientData.GetItem(_item.item)
	var multipliers = ClientData.GetMultiplier(_item.item)
	
	var animator = $InventoryAnimations
	animator.play("InspectItem")
	inspecting_item = _item
	$InspectItem.visible = true
	
	var item_name = $InspectItem/MarginContainer/VBoxContainer/ItemName
	var item_sprite = $InspectItem/MarginContainer/VBoxContainer/ItemSpriteContainer/ItemSprite
	var item_description = $InspectItem/MarginContainer/VBoxContainer/ItemDescription
	var item_use = $InspectItem/MarginContainer/VBoxContainer/ItemStats/Use
	var item_on_use = $InspectItem/MarginContainer/VBoxContainer/ItemStats/OnUse
		
	item_name.text = item.name
	item_sprite.texture.region = Rect2(item.path[3]*10, Vector2(10, 10))
	item_description.text = item.description + "\n"
	
	#Outline
	var starting_colour = Color(0,0,0)
	var ending_colour = Color(0,0,0)
	starting_colour.a = 2.0
	ending_colour.a = 0.0
	
	if item.has("outline"):
		ending_colour = item.outline
		starting_colour.a = 3.0
		ending_colour.a = 0.0
	
	item_sprite.material = item_sprite.material.duplicate()
	item_sprite.material.set_shader_param("starting_colour", starting_colour)
	item_sprite.material.set_shader_param("ending_colour", ending_colour)
	
	if item.type == "Consumable":
		item_use.visible = true
	else:
		item_use.visible = false
	
	for buff in item_on_use.get_children():
		buff.visible = false
	if item.type == "Helmet":
		item_on_use.visible = true
		item_on_use.get_node("Label").visible = true
		for buff in item.buffs.keys():
			item_on_use.get_node(buff).visible = true
			item_on_use.get_node(buff+"/Duration").text = "for "+str(item.buffs[buff].duration)+"s within "+str(item.buffs[buff].range)+" tiles"
	else:
		item_on_use.visible = false
	
	if item.has("damage"):
		var item_damage = $InspectItem/MarginContainer/VBoxContainer/ItemStats/Damage
		var item_rof = $InspectItem/MarginContainer/VBoxContainer/ItemStats/Rof
		
		item_damage.get_node("Amount").text = "Damage: " + str(item.damage[0]) + "-" + str(item.damage[1])
		item_damage.visible = true
		
		if multipliers.has("damage"):
			var item_bonus = item_damage.get_node("Bonus")
			item_bonus.text = "(+"+str((multipliers.damage-1)*100)+"%)"
			item_bonus.add_color_override("font_color", bonus_color)
			item_damage.get_node("Bonus").visible = true
		else:
			item_damage.get_node("Bonus").visible = false
			
		item_rof.get_node("Amount").text = "Rate of Fire: " + str(item.rof) + "%"
		item_rof.visible = true
		
		if multipliers.has("rof"):
			var item_bonus = item_rof.get_node("Bonus")
			item_bonus.text = "(+"+str((multipliers.rof-1)*100)+"%)"
			item_bonus.add_color_override("font_color", bonus_color)
		else:
			item_rof.get_node("Bonus").visible = false
	else:
		$InspectItem/MarginContainer/VBoxContainer/ItemStats/Damage.visible = false
		$InspectItem/MarginContainer/VBoxContainer/ItemStats/Rof.visible = false
	
	var stats_node = $InspectItem/MarginContainer/VBoxContainer/ItemStats/StatsContainer
	if item.has("stats"):
		var item_stats = item.stats
		
		var health_node = stats_node.get_node("Stats1/Health")
		var attack_node = stats_node.get_node("Stats2/Attack")
		var defense_node = stats_node.get_node("Stats1/Defense")
		var speed_node = stats_node.get_node("Stats2/Speed")
		var dexterity_node = stats_node.get_node("Stats1/Dexterity")
		var vitality_node = stats_node.get_node("Stats2/Vitality")
		
		var stats = {
			"health" : health_node,
			"attack" : attack_node,
			"defense" : defense_node,
			"speed" : speed_node,
			"dexterity" : dexterity_node,
			"vitality" : vitality_node
		}
		
		stats_node.visible = true
		for stat in stats.keys():
			var node = stats[stat]
			var amount = node.get_node("Amount")
			var bonus = node.get_node("Bonus")
			
			if item_stats.has(stat):
				node.visible = true
				if not multipliers.has("stats"):
					bonus.visible = false
				else:
					bonus.visible = true
					
				if item_stats[stat] > 0:
					amount.text = "+" + str(item_stats[stat])
					if multipliers.has("stats") and floor(item_stats[stat]*multipliers.stats)-item_stats[stat] != 0:
						bonus.text = "(+" + str(floor(item_stats[stat]*multipliers.stats)-item_stats[stat])+")"
						bonus.add_color_override("font_color", bonus_color)
					elif multipliers.has("stats"):
						node.visible = false
				else:
					amount.text = str(item_stats[stat])
					if multipliers.has("stats") and floor(item_stats[stat]*multipliers.stats)-item_stats[stat] != 0:
						bonus.text = "(" + str(floor(item_stats[stat]*multipliers.stats)-item_stats[stat])+")"
						bonus.add_color_override("font_color", bonus_color)
					elif multipliers.has("stats"):
						node.visible = false
			else:
				node.visible = false
	else:
		stats_node.visible = false
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
	get_parent().Toggle("inventory")

func Open():
	if active:
		return
	
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
	
	var timer = Timer.new()
	timer.wait_time = 0.4
	timer.one_shot = true
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	
	$InventoryBackground.visible = true
	active = true

func Close():
	if not active:
		return
	
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
	active = false

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
	if self.visible == true:
		GameUI.InventoryToggleLogic()
	
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

func UseItem(i):
	Server.UseItem(i)
func EquipItem(i):
	Server.EquipItem(i)
func ChangeItem(to_data, from_data):
	Server.ChangeItem(to_data, from_data)
func DropItem(data):
	Server.DropItem(data)
