extends CanvasLayer

var accepted = false
var mode = "closed"
var inspecting_item = null

var other_player_inventory = []
var other_player_name = ""
var other_player_selection = [false,false,false,false,false,false,false,false]
var self_selection = [false,false,false,false,false,false,false,false]

func _ready():
	$GiveContainer/Options/Cancel/Button.connect("button_down", self, "CancelOffer")
	$GiveContainer/Options/Accept/Button.connect("button_down", self, "AcceptOffer")
	$GiveContainer/Options/Accept/Green.connect("button_down", self, "AcceptOffer")

func InspectItem(_item):
	if not _item:
		return
	if inspecting_item == _item:
		DeInspectItem(_item)
		return
	
	var bonus_color = ClientData.GetCharacter(ClientData.current_class).color
	var item = ClientData.GetItem(_item.item)
	var multipliers = ClientData.GetMultiplier(_item.item)
	
	var animator = $TradingAnimations
	animator.play("InspectItem")
	inspecting_item = _item
	$InspectItem.visible = true
	
	var item_name = $InspectItem/MarginContainer/VBoxContainer/ItemName
	var item_sprite = $InspectItem/MarginContainer/VBoxContainer/ItemSpriteContainer/ItemSprite
	var item_description = $InspectItem/MarginContainer/VBoxContainer/ItemDescription
	var item_tier = $InspectItem/MarginContainer/VBoxContainer/ItemStats/Tier
	var item_use = $InspectItem/MarginContainer/VBoxContainer/ItemStats/Use
	var item_on_use = $InspectItem/MarginContainer/VBoxContainer/ItemStats/OnUse
		
	item_name.text = item.name
	item_sprite.texture.region = Rect2(item.path[3]*10, Vector2(10, 10))
	item_description.text = item.description + "\n"
	item_tier.text = "Tier: " + item.tier
	
	if item.type == "Consumable":
		item_use.visible = true
		item_tier.visible = false
	else:
		item_use.visible = false
		item_tier.visible = true
	
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
		var animator = $TradingAnimations
		animator.play("DeInspectItem")
		inspecting_item = null
		
		var timer = Timer.new()
		timer.wait_time = 0.2
		timer.one_shot = true
		add_child(timer)
		timer.start()
		yield(timer, "timeout")
		
		$InspectItem.visible = false

func ToggleTradeMenu():
	get_parent().Toggle("trade")

func Open():
	visible = true
	if mode == "open":
		return
	ResetTrade()
	SetInventory(GameUI.last_character.inventory)
	$GetContainer/MarginContainer/OtherPlayerName.text = other_player_name
	$GiveContainer/Options.visible = true
	
	var give_tween = $GiveTween
	var get_tween = $GetTween

	var give_element = $GiveContainer
	var get_element = $GetContainer
	
	give_tween.interpolate_property(give_element, "rect_position", give_element.rect_position, Vector2(-200, 0)+give_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	give_tween.start()
	get_tween.interpolate_property(get_element, "rect_position", get_element.rect_position, Vector2(200, 0)+get_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_tween.start()
	mode = "open"

func Close():
	visible = false
	if mode == "closed":
		return
	$GiveContainer/Options.visible = false
	
	var give_tween = $GiveTween
	var get_tween = $GetTween

	var give_element = $GiveContainer
	var get_element = $GetContainer
	give_tween.interpolate_property(give_element, "rect_position", give_element.rect_position, Vector2(200, 0)+give_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	give_tween.start()
	get_tween.interpolate_property(get_element, "rect_position", get_element.rect_position, Vector2(-200, 0)+get_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_tween.start()
	mode = "closed"

func OfferAccepted():
	accepted = true
	$GiveContainer/Options/Accept/Button.visible = false
	$GiveContainer/Options/Accept/Green.visible = true
	$GiveContainer/Options/Accept/Red.visible = false
func OfferWithdrawn():
	accepted = false
	$GiveContainer/Options/Accept/Button.visible = true
	$GiveContainer/Options/Accept/Green.visible = false
	$GiveContainer/Options/Accept/Red.visible = false
func _physics_process(delta):
	if mode == "closed":
		return
	
	var character = GameUI.last_character
	var overflow = false
	
	var free_spaces = 0
	var selection_count = 0
	
	for i in range(character.inventory.size()):
		if self_selection[i]:
			free_spaces += 1
			selection_count += 1
		if not other_player_selection[i] and not character.inventory[i]:
			free_spaces += 1
	
	var other_free_spaces = 0
	var other_selection_count = 0
	
	for i in range(other_player_inventory.size()):
		if other_player_selection[i]:
			other_selection_count += 1
			other_free_spaces += 1
		if not self_selection[i] and not other_player_inventory[i]:
			other_free_spaces += 1
	
	if selection_count > other_free_spaces:
		overflow = true
	if other_selection_count > free_spaces:
		overflow = true
	
	if overflow:
		$GiveContainer/Options/Accept/Button.visible = false
		$GiveContainer/Options/Accept/Green.visible = false
		$GiveContainer/Options/Accept/Red.visible = true
	elif accepted:
		OfferAccepted()
	else:
		OfferWithdrawn()

func SetTradeData(_other_player_inventory, _other_player_selection):
	other_player_selection = _other_player_selection
	other_player_inventory = _other_player_inventory
	var inventory_slots = $GetContainer/PanelContainer2/MarginContainer/ResizeContainer.get_children()
	var i = 0
	
	for slot in inventory_slots:
		slot.SetItem(other_player_inventory[i], 1)
		slot.index = i
		slot.parent = "other_player_inventory"
		
		if other_player_selection[i] == true:
			slot.Activate()
		else:
			slot.DeActivate()
		
		i += 1

func SetInventory(inventory):
	var inventory_slots = $GiveContainer/PanelContainer2/MarginContainer/ResizeContainer.get_children()
	var i = 0
	
	for slot in inventory_slots:
		slot.SetItem(inventory[i], 1)
		slot.index = i
		slot.parent = "inventory"
		slot.DeActivate()
		slot.connect("pressed", self, "ToggleSelection", [i])
		i += 1

func ResetTrade():
	accepted = false
	other_player_name = ""
	other_player_selection = [false,false,false,false,false,false,false,false]
	self_selection = [false,false,false,false,false,false,false,false]
	
	

func ToggleSelection(i):
	if self_selection[i]:
		DeselectItem(i)
	else:
		SelectItem(i)
func SelectItem(i):
	self_selection[i] = true
	Server.SelectItem(i)
func DeselectItem(i):
	self_selection[i] = false
	Server.DeselectItem(i)
func AcceptOffer():
	Server.AcceptOffer()
func CancelOffer():
	Server.CancelOffer()
	GameUI.is_in_menu = true
	GameUI.Toggle("trade")
