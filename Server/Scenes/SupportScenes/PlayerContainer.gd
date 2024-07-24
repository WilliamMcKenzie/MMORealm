extends Node

var email

var account_data = null
var character = null
var character_index = null
var is_dead = false

var health = 100
var gear = {}

#Ability Stuff
var status_effects = {
	"damaging" : 0,
	"berserk" : 0,
	"armored" : 0,
	"healing" : 0,
	"invincible" : 0,
}
var last_teleported = 0

#Status Effects

var heal_rate = 1
var running_time = 0
var last_tick = 0

func _physics_process(delta):
	if not character:
		return
	
	character.ability_cooldown -= delta
	running_time += delta
	heal_rate = 10.0/character.stats.vitality
	
	if status_effects.has("healing"):
		heal_rate = 10.0/(character.stats.vitality + 100)
	
	#Tick
	for i in range(floor((running_time-last_tick)/heal_rate)):
		last_tick = running_time
		if health < character.stats.health:
			health += 1
			get_node("/root/Server").SetHealth(int(name), character.stats.health, health)
		
	for effect in status_effects.keys():
		status_effects[effect] -= delta
		if status_effects[effect] <= 0:
			if character.status_effects.has(effect):
				character.status_effects.erase(effect)
				var server_node = get_node("/root/Server")
				var instance_tree = server_node.player_state_collection[int(name)]["I"]
				var instance_node = server_node.get_node("Instances/"+server_node.StringifyInstanceTree(instance_tree))
				instance_node.player_list[name].status_effects.erase(effect)
				get_node("/root/Server").SendCharacterData(name, character)
			status_effects.erase(effect)


#TRADE

var accepted = false
var other_player_accepted = false

var other_player_container
var other_player_inventory = []
var other_player_selection = [false,false,false,false,false,false,false,false]
var selection = [false,false,false,false,false,false,false,false]

func StartTrade(other_player_name):
	var other_player_id = get_node("/root/Server").player_id_by_name[other_player_name]
	var instance_tree = get_node("/root/Server").player_state_collection[int(other_player_id)]["I"]
	
	other_player_container = get_node("/root/Server/Instances/"+ get_node("/root/Server").StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(other_player_id))
	other_player_inventory = other_player_container.character.inventory.duplicate()
	
	get_node("/root/Server").SendTradeData(name, other_player_inventory, other_player_selection)

func ResetTrade():
	accepted = false
	other_player_accepted = false
	other_player_inventory = []
	other_player_selection = [false,false,false,false,false,false,false,false]
	selection = [false,false,false,false,false,false,false,false]

func AcceptOffer():
	if other_player_inventory.hash() != other_player_container.character.inventory.hash():
		get_node("/root/Server").ForceCancelTrade(other_player_container.name)
	
	#If someone else already accepted no need to check
	#We can go straight to moving the items
	if other_player_accepted:
		FinishTrade()
		return
	
	#Check if inventory will overflow
	var free_spaces = 0
	var selection_count = 0
	
	for i in range(character.inventory.size()):
		if selection[i]:
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
		if not selection[i] and not other_player_inventory[i]:
			other_free_spaces += 1
	
	var other_overflow = selection_count > other_free_spaces
	var self_overflow = other_selection_count > free_spaces
	
	if other_overflow or self_overflow:
		return
	
	other_player_container.OtherPlayerAccepts()
	accepted = true

func OtherPlayerAccepts():
	other_player_accepted = true
	get_node("/root/Server").OfferAccepted(name)
	get_node("/root/Server").OfferAccepted(other_player_container.name)

func SelectItem(i):
	if not character.inventory[i]:
		return
	
	accepted = false
	other_player_accepted = false
	other_player_container.accepted = false
	other_player_container.other_player_accepted = false
	
	selection[i] = true
	other_player_container.other_player_selection = selection
	get_node("/root/Server").OfferWithdrawn(other_player_container.name, name)
	get_node("/root/Server").SendTradeData(other_player_container.name, character.inventory, selection)
	
func DeselectItem(i):
	if not character.inventory[i]:
		return
	
	accepted = false
	other_player_accepted = false
	other_player_container.accepted = false
	other_player_container.other_player_accepted = false
	
	selection[i] = false
	other_player_container.other_player_selection = selection
	get_node("/root/Server").OfferWithdrawn(other_player_container.name, name)
	get_node("/root/Server").SendTradeData(other_player_container.name, character.inventory, selection)

func CancelOffer(original):
	if original:
		other_player_container.CancelOffer(false)
	else:
		get_node("/root/Server").ForceCancelTrade(name)

func FinishTrade():
	var other_player_new_items = []
	var our_new_items = []
	
	for i in range(character.inventory.size()):
		if selection[i]:
			other_player_new_items.append(character.inventory[i].duplicate())
			character.inventory[i] = null
		if other_player_selection[i]:
			our_new_items.append(other_player_inventory[i].duplicate())
			other_player_inventory[i] = null
	
	for i in range(character.inventory.size()):
		if character.inventory[i] == null and our_new_items.size() > 0:
			character.inventory[i] = our_new_items[0].duplicate()
			our_new_items.pop_front()
		if other_player_inventory[i] == null and other_player_new_items.size() > 0:
			other_player_inventory[i] = other_player_new_items[0].duplicate()
			other_player_new_items.pop_front()
			
	other_player_container.character.inventory = other_player_inventory
	get_node("/root/Server").SendCharacterData(name, character)
	get_node("/root/Server").SendCharacterData(other_player_container.name, other_player_container.character)
	get_node("/root/Server").FinalizeTrade(other_player_container.name, name)
	
#ABILITY

func UseAbility():
	if character.ability_cooldown > 0 or not gear.has("helmet"):
		return
	
	character.ability_cooldown = gear.helmet.cooldown
	
	var server_node = get_node("/root/Server")
	var instance_tree = server_node.player_state_collection[int(name)]["I"]
	var instance_node = server_node.get_node("Instances/"+server_node.StringifyInstanceTree(instance_tree))
	var player_list = instance_node.player_list
	
	var player_position = self.position
	
	var buffs = gear.helmet.buffs
	for buff in buffs.keys():
		var buff_range = buffs[buff].range
		
		if buff_range == 0:
			GiveEffect(buff, buffs[buff].duration)
			continue
		
		for player_id in player_list.keys():
			if player_list[player_id].position.distance_to(player_position) <= buff_range*5:
				var player_container = instance_node.get_node("YSort/Players/"+str(player_id))
				player_container.GiveEffect(buff, buffs[buff].duration)
		
func GiveEffect(effect, duration):
	var server_node = get_node("/root/Server")
	var instance_tree = server_node.player_state_collection[int(name)]["I"]
	var instance_node = server_node.get_node("Instances/"+server_node.StringifyInstanceTree(instance_tree))
	if status_effects.has(effect) and status_effects[effect] > duration:
		return
	
	status_effects[effect] = duration
	if not character.status_effects.has(effect):
		character.status_effects.append(effect)
	if not instance_node.player_list[name].has(effect):
		instance_node.player_list[name].status_effects.append(effect)
	
	get_node("/root/Server").SendCharacterData(name, character)

#Items

func IncreaseStat(stat):
	if character.ascension_stones > character.used_ascension_stones:
		character.used_ascension_stones += 1
		if stat == "health":
			character.stats[stat] += 5
		else:
			character.stats[stat] += 1
		get_node("/root/Server").SendCharacterData(name, character)
	
func Max():
	character.ascension_stones += ServerData.GetCharacter(character.class).ascension_stones - character.ascension_stones
	
	get_node("/root/Server").SendCharacterData(name, character)
	get_node("/root/Server").SendMessage(int(name), "success", "You feel your strength grow...")

func UseItem(index):
	var selected_item_raw = character.inventory[index]
	if selected_item_raw == null:
		return
	
	var selected_item = ServerData.GetItem(selected_item_raw.item)
	if selected_item.type != "Consumable":
		return
	
	if selected_item.use == "ascend" and character.ascension_stones < ServerData.GetCharacter(character.class).ascension_stones:
		character.ascension_stones += 1
		character.inventory[index] = null
		get_node("/root/Server").SendMessage(int(name), "success", "You feel your strength grow...")
	elif selected_item.use == "ascend":
		get_node("/root/Server").SendMessage(int(name), "warning", "Class is fully ascended, evolve to ascend further")
	
	get_node("/root/Server").SendCharacterData(name, character)

func EquipItem(index):
	var selected_item_raw = character.inventory[index]
	if selected_item_raw == null:
		return
	
	var selected_item = ServerData.GetItem(selected_item_raw.item)
	var replaced_item = character.gear[selected_item.slot]
	
	character.inventory[index] = replaced_item
	character.gear[selected_item.slot] = selected_item_raw
	gear[selected_item.slot] = selected_item
	
	get_node("/root/Server").SendCharacterData(name, character)
	
func ChangeItem(to_data, from_data):
	var remove_gear = false
	
	var selected_item_raw = character[from_data.parent][from_data.index]
	var replaced_item_raw = character[to_data.parent][to_data.index]
	
	#Item you are dragging
	var selected_item = ServerData.GetItem(selected_item_raw.item)
	
	if selected_item_raw == null and replaced_item_raw == null:
		return
		
	#When you are trying to place a item in the wrong gear slot
	if to_data.parent == "gear":
		if to_data.index != selected_item.slot:
			return
		else:
			gear[to_data.index] = selected_item
			
	#Vice versa, trying to place gear slot into inventory
	if from_data.parent == "gear":
		if replaced_item_raw != null:
			var replaced_item = ServerData.GetItem(replaced_item_raw.item)
			
			if replaced_item.slot != from_data.index:
				return
			gear[from_data.index] = replaced_item
		else:
			gear.erase(from_data.index)
	
	character[from_data.parent][from_data.index] = replaced_item_raw
	character[to_data.parent][to_data.index] = selected_item_raw
	get_node("/root/Server").SendCharacterData(name, character)

func DropItem(data):
	if "loot" in data.parent:
		return
	var selected_item_raw = character[data.parent][data.index]
	var Server = get_node("/root/Server")
	var instance_tree = Server.player_state_collection[int(name)]["I"]
	
	Server.get_node("Instances/"+Server.StringifyInstanceTree(instance_tree)).SpawnLootBag([selected_item_raw], null, instance_tree, Server.player_state_collection[int(name)]["P"])
	
	if data.parent == "gear":
		gear.erase(data.index)
	character[data.parent][data.index] = null
	
	get_node("/root/Server").SendCharacterData(name, character)

func LootItem(to_data, from_data):
	
	#Getting loot bag contents
	var loot_id
	if to_data.parent.split(" ")[0] == "loot":
		loot_id = to_data.parent
	else:
		loot_id = from_data.parent
	
	#Check if it is soulbound, if so make sure the right player is requesting
	if not get_parent().get_parent().get_parent().object_list.has(loot_id):
		return
	if get_parent().get_parent().get_parent().object_list[loot_id].soulbound == true and get_parent().get_parent().get_parent().object_list[loot_id].player_id != name:
		return
	var loot = get_parent().get_parent().get_parent().object_list[loot_id].loot
	get_parent().get_parent().get_parent().object_list[loot_id].end_time = OS.get_system_time_msecs()+40000
	
	#Identifying items
	var selected_item_raw
	var replaced_item_raw
	
	#Set dragging item
	if from_data.parent.split(" ")[0] == "loot":
		selected_item_raw = loot[from_data.index]
	else:
		selected_item_raw = character[from_data.parent][from_data.index]
	#Set item to replace
	if to_data.parent.split(" ")[0] == "loot":
		replaced_item_raw = loot[to_data.index]
	else:
		replaced_item_raw = character[to_data.parent][to_data.index]
	
	#Item you are dragging
	var selected_item = ServerData.GetItem(selected_item_raw.item)
	
	#Different Scenarios
	
	#Taking loot into inventory
	if to_data.parent == "inventory":
		loot[from_data.index] = replaced_item_raw
		character[to_data.parent][to_data.index] = selected_item_raw
	
	#From gear to loot
	if from_data.parent == "gear":
		if replaced_item_raw != null:
			var replaced_item = ServerData.GetItem(replaced_item_raw.item)
			
			if replaced_item.slot != selected_item.slot:
				return
			gear[from_data.index] = replaced_item
		else:
			gear.erase(from_data.index)
		
		loot[to_data.index] = selected_item_raw
		character[from_data.parent][from_data.index] = replaced_item_raw
	
	#From loot to gear
	if to_data.parent == "gear":
		if to_data.index != selected_item.slot:
			return
		else:
			gear[to_data.index] = selected_item
		
		loot[from_data.index] = replaced_item_raw
		character[to_data.parent][to_data.index] = selected_item_raw
	
	#Putting inventory item into loot bag
	if from_data.parent == "inventory":
		loot[to_data.index] = selected_item_raw
		character[from_data.parent][from_data.index] = replaced_item_raw

	#Moving around items inside loot bag
	if to_data.parent.split(" ")[0] == "loot" and from_data.parent.split(" ")[0] == "loot":
		loot[to_data.index] = selected_item_raw
		loot[from_data.index] = replaced_item_raw
		
	if loot == [null,null,null,null,null,null,null,null]:
		get_parent().get_parent().get_parent().object_list.erase(loot_id)

	get_node("/root/Server").SendCharacterData(name, character)

#Set Data

func SetCharacter(characters):
	character = characters[character_index]
	health = character.stats.health
	
	for slot in character.gear.keys():
		if character.gear[slot] != null:
			gear[slot] = ServerData.GetItem(character.gear[slot].item)
			
	get_node("/root/Server").SendCharacterData(name, character)

func AddExp(exp_amount):
	character.exp += exp_amount
	var exp_to_level = 100*pow(1.1962,character.level)
	
	if character.level >= 20 and character.exp >= 3600:
		health = character.stats.health
		character.level += 1
		character.exp = 0
	elif character.level < 20 and character.exp >= exp_to_level:
		character.level += 1
		character.exp = 0
		
		var stat_rolls = {
			"health" : 20,
			"attack" : 1,
			"defense" : 1,
			"speed" : 1,
			"dexterity" : 1,
			"vitality" : 1,
		}
		
		for stat in character.stats:
			character.stats[stat] += stat_rolls[stat]
		health = character.stats.health
	
	get_node("/root/Server").SetHealth(int(name), character.stats.health, health)
	get_node("/root/Server").SendCharacterData(name, character)

func DealDamage(damage, enemy_name):
	if not character:
		return
	
	var total_damage = floor(damage - character.stats.defense)
	if status_effects.has("armored"):
		total_damage = floor(damage - (character.stats.defense*2))
	
	if total_damage < damage - damage*0.9:
		total_damage = floor(damage - damage*0.9)
	
	if status_effects.has("invincible"):
		total_damage = 0
	
	health -= total_damage
	
	UpdateStatistics("damage_taken", total_damage)
	get_node("/root/Server").SetHealth(int(name), character.stats.health, health)
	if health < 1 and not is_dead:
		Death(enemy_name)

func Death(enemy_name):
	var username = get_node("/root/Server").player_name_by_id[int(name)]
	
	account_data.characters.remove(character_index)
	if not character.has("revive_cost"):
		character.revive_cost = DetermineReviveCost(character.level)
		account_data.graveyard.append(character)
	else:
		character.revive_cost = 9999999
		character.permadead = true
		account_data.graveyard.append(character)
	HubConnection.UpdateLeaderboard(username, character)
	get_node("/root/Server").NotifyDeath(int(name), enemy_name)
	is_dead = true
func DetermineReviveCost(reputation):
	var cost = reputation * 10
	if reputation > 20000:
		cost = 5000
	elif reputation > 10000:
		cost = 4000
	elif reputation > 5000:
		cost = 3000
	elif reputation > 1000:
		cost = 2000
	elif reputation > 500:
		cost = 1000
	elif reputation > 100:
		cost = 500
	elif reputation > 20:
		cost = 200
	return cost

func UpdateStatistics(which, amount_increase):
	if character.statistics.has(which) and character.ascension_stones >= ServerData.GetCharacter(character.class).ascension_stones:
		character.statistics[which] += amount_increase
	account_data.statistics[which] += amount_increase
	
	for _achievement in ServerData.GetCharacter(character.class).quests:
		var achievement = ServerData.GetAchievement(_achievement)
		if (achievement.which == which and character.statistics[which] >= achievement.amount):
			GetAchievement(_achievement)
	
	for _achievement in account_data.achievements:
		if account_data.achievements[_achievement] == true:
			continue
			
		var achievement = ServerData.GetAchievement(_achievement)
		if (achievement.which == which and account_data.statistics[which] >= achievement.amount):
			account_data.achievements[_achievement] = true
			GetAchievement(_achievement)
	
	get_node("/root/Server").SendAccountData(name, account_data)

func GetAchievement(achievement_name):
	var character_data = ServerData.GetCharacter(character.class)
	var achievement_data = ServerData.GetAchievement(achievement_name)
	
	account_data.gold += achievement_data.gold
	account_data.achievements[achievement_name] = true
	get_node("/root/Server").SendMessage(int(name), "success", "You recieved " + str(achievement_data.gold) + " gold!")
	
	if character_data.quests.has(achievement_name):
		character.class = character_data.quests[achievement_name]
		account_data.classes[character_data.quests[achievement_name]] = true
		
		var class_bonus_stats = character_data.bonus_stats
		for stat in character.stats.keys():
			character.stats[stat] += class_bonus_stats[stat]
	
	get_node("/root/Server").SendAccountData(name, account_data)
	get_node("/root/Server").SendCharacterData(name, character)

func _on_PlayerHitbox_area_entered(area):
	if "enemy_id" in area.get_parent():
		DealDamage(area.get_parent().damage, area.get_parent().enemy_id)
