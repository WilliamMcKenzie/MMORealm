extends Node

var email

var account_data = null
var character = null
var character_index = null

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
				get_node("/root/Server").SendCharacterData(name, character)
			status_effects.erase(effect)

func UseAbility():
	if character.ability_cooldown > 0 or not gear.has("helmet"):
		return
	
	character.ability_cooldown = gear.helmet.cooldown
	var buffs = gear.helmet.buffs
	for buff in buffs.keys():
		GiveEffect(buff, buffs[buff].duration)
	
	get_node("/root/Server").SendCharacterData(name, character)
		
func GiveEffect(effect, duration):
	if status_effects.has(effect) and status_effects[effect] > duration:
		return
	
	status_effects[effect] = duration
	print("nada")
	if not character.status_effects.has(effect):
		print("effect given")
		character.status_effects.append(effect)

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
	#health = character.stats.health
	health = 1
	
	for slot in character.gear.keys():
		if character.gear[slot] != null:
			gear[slot] = ServerData.GetItem(character.gear[slot].item)
			
	get_node("/root/Server").SendCharacterData(name, character)

func AddExp(exp_amount):
	character.exp += exp_amount
	var exp_to_level = 100*pow(1.1962,character.level)
	
	if character.level >= 20 and character.exp >= 3600:
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
		
	get_node("/root/Server").SendCharacterData(name, character)

func DealDamage(damage, enemy_id):
	var total_damage = floor(damage - character.stats.defense)
	if status_effects.has("armored"):
		total_damage = floor(damage - (character.stats.defense*2))
	
	if total_damage < damage - damage*0.9:
		total_damage = floor(damage - damage*0.9)
	
	if status_effects.has("invincible"):
		total_damage = 0
	
	health -= total_damage
	
	get_node("/root/Server").SetHealth(int(name), character.stats.health, health)
	if health < 1:
		health = 0
		pass
		#print("dead")
		#Death(enemy_id)

func Death(enemy_id):
	get_parent().get_parent().get_parent().player_list.erase(name)
	get_node("/root/Server").NotifyDeath(int(name), enemy_id)
	queue_free()

func UpdateStatistics(which, amount_increase):
	if character.ascension_stones >= ServerData.GetCharacter(character.class).ascension_stones:
		character.statistics[which] += amount_increase
	
	for _achievement in ServerData.GetCharacter(character.class).quests:
			
		var achievement = ServerData.GetAchievement(_achievement)
		if (achievement.which == which and character.statistics[which] >= achievement.amount):
			GetAchievement(_achievement)
	
	for _achievement in account_data.achievements:
		if account_data.achievements[_achievement] == true:
			return
			
		var achievement = ServerData.GetAchievement(_achievement)
		if (achievement.which == which and account_data.statistics[which] >= achievement.amount):
			account_data.achievements[_achievement] = true
			GetAchievement(_achievement)

func GetAchievement(achievement_name):
	var character_data = ServerData.GetCharacter(character.class)
	
	if character_data.quests.has(achievement_name):
		character.class = character_data.quests[achievement_name]
		account_data.classes[character_data.quests[achievement_name]] = true
		
		var class_bonus_stats = ServerData.GetCharacter(character.class).bonus_stats
		for stat in character.stats.keys():
			character.stats[stat] += class_bonus_stats[stat]
	
	get_node("/root/Server").SendCharacterData(name, character)

func _on_PlayerHitbox_area_entered(area):
	if "enemy_id" in area.get_parent():
		DealDamage(area.get_parent().damage, area.get_parent().enemy_id)
