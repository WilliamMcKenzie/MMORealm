extends Node

var email

var account_data = null
var character = null
var character_index = null
var is_dead = false

var health = 100
var gear = {}
var current_quest

#Ability Stuff
var stat_buffs = {
	"health" : {"add" : 0, "timer" : 0},
	"attack" : {"add" : 0, "timer" : 0},
	"defense" : {"add" : 0, "timer" : 0},
	"speed" : {"add" : 0, "timer" : 0},
	"dexterity" : {"add" : 0, "timer" : 0},
	"vitality" : {"add" : 0, "timer" : 0},
}
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

#Tutorial
var in_tutorial = false
var tutorial_step = 0
var tutorial_step_translation = ["Intro", "Controls", "Backpack", "Ability", "Quest", "Stats", "Ascend", "Final"]

var clock_sync_timer = 0
var clock_sync_timer_2 = 0
var last_position

#For fake player containers
var fake_sync_timer = 0
var fake = false
var enemy = null
var target = null
var loaded_chunks = {}
var player_state = {"T":OS.get_system_time_msecs(), "P":Vector2.ZERO, "A":{ "A" : "Idle", "C" : Vector2.ZERO }, "S":{ "R" : Rect2(Vector2(0,0), Vector2(80,40)), "C" : "Apprentice", "P" : {"ColorParams" : {}, "TextureParams":{}}}}

var last_shot_time = 0
var time_between_shots = INF

func _physics_process(delta):
	if fake and not despawned:
		HandleFake()
		return
	
	clock_sync_timer += 1
	clock_sync_timer_2 += 1
	if not character:
		return
	
	if clock_sync_timer % 10 == 0:
		for slot in gear.keys():
			if gear[slot] != null:
				gear[slot] = ServerData.GetItem(character.gear[slot].item, true, character.class)
	
	if clock_sync_timer < 30:
		pass
	elif clock_sync_timer >= 30 and "island" in get_parent().get_parent().get_parent().name:
		clock_sync_timer = 0
		
		var server_node = get_node("/root/Server")
		var instance_tree = server_node.player_state_collection[int(name)]["I"]
		var instance_node = server_node.get_node("Instances/"+server_node.StringifyInstanceTree(instance_tree))
		var nearby_enemies = {}
		
		var quest_enemies = []
		var tile
		if character.level < 2:
			quest_enemies = instance_node.beach_enemies
			tile = 2
		elif character.level < 6:
			quest_enemies = instance_node.forest_enemies
			tile = 3
		elif character.level < 10:
			quest_enemies = instance_node.plains_enemies
			tile = 4
		elif character.level < 16:
			quest_enemies = instance_node.badlands_enemies
			tile = 5
		if instance_node.ruler == "tutorial_troll_king" and tutorial_step == 1:
			quest_enemies = ["tutorial_crab"]
			tile = 2
		
		var closest = OS.get_system_time_msecs()
		var current_quest_data = null
		
		for enemy_id in instance_node.enemy_list.keys():
			var enemy = instance_node.enemy_list[enemy_id]
			if quest_enemies.has(enemy.name) and enemy.position.distance_to(self.position) < closest:
				closest = enemy.position.distance_to(self.position)
				current_quest = enemy_id 
		
		if instance_node.ruler and character.level >= 16 and "ruler_id" in instance_node and instance_node.ruler_id and instance_node.enemy_list.has(instance_node.ruler_id):
			current_quest = instance_node.ruler_id
			current_quest_data = instance_node.enemy_list[current_quest].duplicate()
			current_quest_data.id = current_quest
		elif current_quest and instance_node.enemy_list.has(current_quest):
			current_quest_data = instance_node.enemy_list[current_quest].duplicate()
			current_quest_data.id = current_quest
		elif tile and quest_enemies.size() > 0 and instance_node.tile_points.has(tile):
			var tile_list = instance_node.tile_points[tile]
			current_quest_data = {
			"name":quest_enemies[0],
			"position":tile_list[0],
			"id" : "null"
		}
		
		#Tutorial
		if instance_node.ruler == "tutorial_troll_king" and tutorial_step == 4:
			current_quest = instance_node.ruler_id
			if instance_node.enemy_list.has(current_quest):
				current_quest_data = instance_node.enemy_list[current_quest].duplicate()
				current_quest_data.id = current_quest
		elif instance_node.ruler == "tutorial_troll_king" and tutorial_step != 1:
			current_quest_data = null
		
		server_node.SendQuestData(name, current_quest_data)
	elif clock_sync_timer >= 30 and "dungeon" in get_parent().get_parent().get_parent().name:
		clock_sync_timer = 0
		
		var server_node = get_node("/root/Server")
		var instance_tree = server_node.player_state_collection[int(name)]["I"]
		var instance_node = server_node.get_node("Instances/"+server_node.StringifyInstanceTree(instance_tree))
		
		var closest = OS.get_system_time_msecs()
		var current_quest_data = null
		
		for enemy_id in instance_node.enemy_list.keys():
			var enemy = instance_node.enemy_list[enemy_id]
			if enemy.name == instance_node.dungeon_boss and enemy.position.distance_to(self.position) < closest:
				closest = enemy.position.distance_to(self.position)
				current_quest = enemy_id 
		
		if current_quest and instance_node.enemy_list.has(current_quest):
			current_quest_data = instance_node.enemy_list[current_quest].duplicate()
			current_quest_data.id = current_quest
		
		server_node.SendQuestData(name, current_quest_data)
	elif clock_sync_timer >= 30:
		current_quest = null
		get_node("/root/Server").SendQuestData(name, null)
	
	character.ability_cooldown -= delta
	running_time += delta
	
	#heal_rate = heal_rate/character.stats.health*200.0
	
	if clock_sync_timer_2 >= 60:
		clock_sync_timer_2 = 0
		for effect in status_effects.keys():
			status_effects[effect] -= 1
			if status_effects[effect] <= 0:
				if character.status_effects.has(effect):
					character.status_effects.erase(effect)
					var server_node = get_node("/root/Server")
					var instance_tree = server_node.player_state_collection[int(name)]["I"]
					var instance_node = server_node.get_node("Instances/"+server_node.StringifyInstanceTree(instance_tree))
					instance_node.player_list[name].status_effects.erase(effect)
					get_node("/root/Server").SendCharacterData(name, character)
				status_effects.erase(effect)
		
		#Tiles covered
		if not account_data.statistics.has("tiles_covered"):
			account_data.statistics.tiles_covered = 0
		if last_position:
			account_data.statistics.tiles_covered += round(last_position.distance_to(self.position)/8.0)
		last_position = self.position
		
		#Class achievements
		for _achievement in account_data.achievements:
			if account_data.achievements[_achievement] == true or not ServerData.GetAchievement(_achievement):
				continue
			var achievement = ServerData.GetAchievement(_achievement)
			if achievement.which == "classes_unlocked":
				var unlocked = true
				for _class in achievement.classes:
					if not account_data.classes.has(_class) or not account_data.classes[_class]:
						unlocked = false
				
				if unlocked:
					GetAchievement(_achievement)
		
		get_node("/root/Server").SendAccountData(name, account_data)
	
	#Tick
	ManageHealing()
	for stat in stat_buffs.keys():
		stat_buffs[stat].timer -= delta
		if stat_buffs[stat].timer <= 0:
			if character.stat_buffs.has(stat):
				character.stat_buffs.erase(stat)
				character.stats[stat] -= stat_buffs[stat].add
				get_node("/root/Server").SendCharacterData(name, character)
			stat_buffs.erase(stat)

#Fake player containers
var despawned = false
func DecorateFake():
	player_state = Bots.DecorateFake(player_state, character, gear)
func HandleFake():
	Bots.HandleChat(account_data.username, character.class, name)
	
	var server = get_node("/root/Server")
	var instance_node = get_parent().get_parent().get_parent()
	enemy.position = self.position
	enemy.anchor_position = self.position
	enemy = Behaviors.Bot(enemy, 0.1, instance_node)
	player_state["P"] = enemy.position
	player_state["T"] = OS.get_system_time_msecs()
	if target:
		player_state["A"] = { "A" : "Attack", "C" : self.position.direction_to(target) }
	elif self.position != enemy.position:
		player_state["A"] = { "A" : "Walk", "C" : self.position.direction_to(enemy.position) }
	else:
		player_state["A"]["A"] = "Idle"
	
	fake_sync_timer += 1
	var closest = OS.get_system_time_msecs()
	var closest_pos = null
	if target:
		var timing = (OS.get_ticks_msec() / 1000.0) - last_shot_time >= time_between_shots
		var weapon = gear.has("weapon")
		var distance = self.position.distance_to(target)
		var tile_range = gear.weapon.projectiles[0].tile_range*8
		
		if distance > tile_range or distance < tile_range-8:
			enemy.target = target + (self.position - target).normalized() * tile_range
		
		if timing and weapon:
			var i = -1
			for projectile_data in gear.weapon.projectiles:
				i += 1
				var _projectile_data = {
					"ProjectileIndex" : i,
					"Damage" : rand_range(10,20),
					"Position": self.position,
					"MousePosition": self.position+100*Bots.OffsetProjectileAngle(self.position.direction_to(target), projectile_data.offset),
					"Direction": self.position.direction_to(target),
				}
				server.SendFakePlayerProjectile(_projectile_data, int(name))
			last_shot_time = OS.get_ticks_msec() / 1000.0
	
	if fake_sync_timer >= 40:
		time_between_shots = (1 / (6.5 * (character.stats.dexterity + 17.3) / 75)) / (gear.weapon.rof/100.0)
		var closest_player = OS.get_system_time_msecs()
		for player_id in instance_node.player_list.keys():
			var player_data = instance_node.player_list[player_id]
			var distance =  player_data.position.distance_to(self.position)
			if distance < closest_player and not player_data.fake:
				closest_player = distance
		if closest_player > 48*8:
			despawned = true
			Bots.used_names.erase(account_data.username)
			server._Peer_Disconnected(int(name))
			return
		
		for enemy_id in instance_node.enemy_list.keys():
			var enemy_data = instance_node.enemy_list[enemy_id]
			var distance =  enemy_data.position.distance_to(self.position)
			if distance < closest:
				closest =  distance
				closest_pos = enemy_data.position
		
		if closest < 8:
			target = closest_pos - (self.position - closest_pos).normalized() * 16
		elif closest < 7*8:
			target = closest_pos
		else:
			target = null
	self.position = enemy.position
	get_node("/root/Server").RecieveFakePlayerState(int(name), player_state.duplicate(true))

#Regular player containers

func ManageHealing():
	heal_rate = 4.0/(character.stats.vitality*6*(character.stats.health/500.0))
	if status_effects.has("healing"):
		heal_rate = 4.0/(character.stats.vitality*18*(character.stats.health/500.0))
	for i in range(floor((running_time-last_tick)/heal_rate)):
		last_tick = running_time
		if health < character.stats.health:
			health += 1
			get_node("/root/Server").SetHealth(int(name), character.stats.health, health)
		if health > character.stats.health:
			health = character.stats.health

#TRADE
var accepted = false
var other_player_accepted = false

var other_player_container
var other_player_inventory = []
var other_player_selection = [false,false,false,false,false,false,false,false]
var selection = [false,false,false,false,false,false,false,false]

func StartTrade(other_player_name):
	ResetTrade()
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
	ResetTrade()
	if original:
		other_player_container.CancelOffer(false)
	else:
		get_node("/root/Server").ForceCancelTrade(name)

func FinishTrade():
	var other_player_new_items = []
	var our_new_items = []
	
	for i in range(character.inventory.size()):
		if selection[i] and not character.inventory[i]:
			return
		if other_player_selection[i] and not other_player_inventory[i]:
			return
		
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
	ResetTrade()

#ABILITY

func UseAbility():
	if character.ability_cooldown > 0 or not gear.has("helmet"):
		return
		
	if in_tutorial and tutorial_step == 3:
		tutorial_step += 1
		get_node("/root/Server").Dialogue(tutorial_step_translation[tutorial_step], name)
	
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

func GiveBuff(amount, stat, duration):
	if stat_buffs.has(stat):
		character.stats[stat] -= stat_buffs[stat].add
	
	stat_buffs[stat] = {"add" : amount, "timer" : duration}
	character.stat_buffs[stat] = amount
	character.stats[stat] += stat_buffs[stat].add
	get_node("/root/Server").SendCharacterData(name, character)

#Items

func IncreaseStat(stat):
	if in_tutorial and tutorial_step == 6:
		tutorial_step += 1
		in_tutorial = false
		account_data.finished_tutorial = true
		get_node("/root/Server").Dialogue(tutorial_step_translation[tutorial_step], name)
	
	if character.ascension_stones > character.used_ascension_stones:
		character.used_ascension_stones += 1
		if stat == "health":
			character.stats[stat] += 5
		else:
			character.stats[stat] += 1
		get_node("/root/Server").SendCharacterData(name, character)
	
func Max(limitless = false):
	character.ascension_stones += ServerData.GetCharacter(character.class).ascension_stones - character.ascension_stones
	if limitless:
		character.ascension_stones += 999
	
	get_node("/root/Server").SendCharacterData(name, character)
	get_node("/root/Server").SendMessage(int(name), "success", "You feel your strength grow...")

func UseItem(index):
	var selected_item_raw = character.inventory[index]
	if selected_item_raw == null:
		return
	
	var selected_item = ServerData.GetItem(selected_item_raw.item)
	if selected_item.type != "Consumable":
		return
	
	if "ascend" in selected_item.use and character.ascension_stones < ServerData.GetCharacter(character.class).ascension_stones:
		if in_tutorial and tutorial_step == 5:
			tutorial_step += 1
			get_node("/root/Server").Dialogue(tutorial_step_translation[tutorial_step], name)
		character.ascension_stones += int(selected_item.use.split(" ")[1])
		character.inventory[index] = null
		get_node("/root/Server").SendMessage(int(name), "success", "You feel your strength grow...")
	elif "ascend" in selected_item.use:
		if in_tutorial and tutorial_step == 5:
			tutorial_step += 1
			tutorial_step += 1
			in_tutorial = false
			account_data.finished_tutorial = true
			get_node("/root/Server").Dialogue(tutorial_step_translation[tutorial_step], name)
		get_node("/root/Server").SendMessage(int(name), "warning", "Class is fully ascended, evolve to ascend further")
	
	get_node("/root/Server").SendCharacterData(name, character)

func EquipItem(index):
	var selected_item_raw = character.inventory[index]
	if selected_item_raw == null:
		return
	
	var selected_item = ServerData.GetItem(selected_item_raw.item)
	if not selected_item.has("slot") or selected_item.slot == "na":
		return
	var replaced_item = character.gear[selected_item.slot]
	
	character.inventory[index] = replaced_item
	character.gear[selected_item.slot] = selected_item_raw
	gear[selected_item.slot] = selected_item
	
	get_node("/root/Server").SendCharacterData(name, character)
	if in_tutorial and tutorial_step == 2 and selected_item.slot == "helmet":
		tutorial_step += 1
		get_node("/root/Server").Dialogue(tutorial_step_translation[tutorial_step], name)

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
			
			if in_tutorial and tutorial_step == 2 and selected_item.slot == "helmet":
				tutorial_step += 1
				get_node("/root/Server").Dialogue(tutorial_step_translation[tutorial_step], name)
			
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
	if get_parent().get_parent().get_parent().object_list[loot_id].soulbound == true and str(get_parent().get_parent().get_parent().object_list[loot_id].player_id) != name:
		return
	
	var object_reference = get_parent().get_parent().get_parent().object_list[loot_id]
	var loot = object_reference.loot
	if not object_reference.has("permanent"):
		object_reference.end_time = OS.get_system_time_msecs()+40000
	
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
	if not selected_item_raw:
		return
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
			
			if in_tutorial and tutorial_step == 2 and selected_item.slot == "helmet":
				tutorial_step += 1
				get_node("/root/Server").Dialogue(tutorial_step_translation[tutorial_step], name)
		
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
		
	if loot == [null,null,null,null,null,null,null,null] and not object_reference.has("permanent"):
		get_parent().get_parent().get_parent().object_list.erase(loot_id)

	get_node("/root/Server").SendCharacterData(name, character)

#Set Data

func SetCharacter(characters):
	character = characters[character_index]
	health = character.stats.health
	
	for slot in character.gear.keys():
		if character.gear[slot] != null:
			gear[slot] = ServerData.GetItem(character.gear[slot].item, true, character.class)
	
	get_node("/root/Server").SendCharacterData(name, character)

func AddExp(exp_amount, enemy_name, enemy_id):
	if ServerData.enemies_tracked.has(enemy_name):
		UpdateStatistics(enemy_name, 1)
	UpdateStatistics("enemies_killed", 1)
	
	if in_tutorial and tutorial_step == 4 and enemy_name == "tutorial_troll_king":
		tutorial_step += 1
		get_node("/root/Server").Dialogue(tutorial_step_translation[tutorial_step], name)
	if in_tutorial and tutorial_step == 1 and enemy_name == "tutorial_crab":
		tutorial_step += 1
		get_node("/root/Server").Dialogue(tutorial_step_translation[tutorial_step], name)
	
	var exp_pool = exp_amount
	if enemy_id == current_quest:
		exp_pool = exp_amount*3
	
	while exp_pool > 0:
		var level_exp = 100*pow(1.1962,character.level) if (character.level < 20) else 100*pow(1.1962,20)
		var exp_to_level = level_exp - character.exp
		
		if exp_pool < exp_to_level:
			character.exp += floor(exp_pool)
			exp_pool = 0
		else:
			exp_pool -= exp_to_level
			character.exp = 0
			character.level += 1
			if character.level < 20:
				health = character.stats.health
				var stat_rolls = {
					"health" : 20,
					"attack" : 1,
					"defense" : 0,
					"speed" : 0.5,
					"dexterity" : 1,
					"vitality" : 1,
				}
				for stat in character.stats:
					character.stats[stat] += stat_rolls[stat]
	
	get_node("/root/Server").SetHealth(int(name), character.stats.health, health)
	get_node("/root/Server").SendCharacterData(name, character)

func DealDamage(damage, enemy_name):
	if not character:
		return
	
	var practical_defense = character.stats.duplicate().defense
	for slot in gear.keys():
		var item = gear[slot]
		if item.stats.has("defense"):
			practical_defense += item.stats.defense
	
	var total_damage = floor(damage - practical_defense)
	if status_effects.has("armored"):
		total_damage = floor(damage - (practical_defense*2))
	
	if total_damage < damage - damage*0.9:
		total_damage = ceil(damage - damage*0.9)
	
	if status_effects.has("invincible"):
		total_damage = 0
	
	health -= total_damage
	
	UpdateStatistics("damage_taken", total_damage)
	get_node("/root/Server").SetHealth(int(name), character.stats.health, health)
	if health < 1 and not is_dead:
		var server_node = get_node("/root/Server")
		var instance_tree = server_node.player_state_collection[int(name)]["I"]
		var instance_node = server_node.get_node("Instances/"+server_node.StringifyInstanceTree(instance_tree))
		if "arena" in instance_node.name:
			health = character.stats.health
			account_data.gold += instance_node.gold
			account_data.time_tracker[instance_node.arena_type] = OS.get_datetime()
			server_node.SetHealth(int(name), character.stats.health, health)
			server_node.SendAccountData(name, account_data)
			server_node.SendCharacterData(name, character)
			server_node.ForcedNexus(int(name),  server_node.get_node("Instances/nexus").object_list["arena_master"].position - Vector2(24,0))
			yield(get_tree().create_timer(1), "timeout")
			server_node.rpc_id(int(name), "Wave", -1, 0)
			server_node.Dialogue("FinishedArena", name)
		else:
			Death(enemy_name)

func Death(enemy_name):
	UpdateStatistics("deaths",1)
	var username = get_node("/root/Server").player_name_by_id[int(name)]
	
	account_data.characters.remove(character_index)
	if not character.has("revive_cost"):
		character.revive_cost = DetermineReviveCost(character.level)
		account_data.graveyard.append(character)
	else:
		character.revive_cost = 9999999
		character.permadead = true
		account_data.graveyard.append(character)
	if account_data.graveyard.size() > 10:
		account_data.graveyard.pop_front()
	
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

var updated_achievements = false
func UpdateStatistics(which, amount_increase):
	if not updated_achievements:
		for category in ServerData.achievement_catagories:
			for achievement in ServerData.achievement_catagories[category].achievements:
				if not account_data.achievements.has(achievement):
					account_data.achievements[achievement] = false
	
	#Handle character statistics
	if not character.statistics.has(which):
			character.statistics[which] = 0
	character.statistics[which] += amount_increase
	
	#Handle global statistics
	if not account_data.statistics.has(which):
		account_data.statistics[which] = 0
	account_data.statistics[which] += amount_increase
	
	#Class quests
	for _achievement in ServerData.GetCharacter(character.class).quests:
		var achievement = ServerData.GetAchievement(_achievement)
		
		#In case account is outdated
		if not character.statistics.has(which):
			character.statistics[which] = 0
		
		#If standard achievement, simply check the amount
		if achievement.which == which and character.statistics[which] >= achievement.amount and not achievement.has("enemies"):
			GetAchievement(_achievement)
		#In case of enemies killed, check the enemies in statistics
		elif achievement.which == "enemies_killed" and achievement.has("enemies") and achievement.enemies.has(which):
			var total = 0
			for enemy in achievement.enemies:
				if character.statistics.has(enemy):
					total += character.statistics[enemy]
			if total >= achievement.amount:
				GetAchievement(_achievement)
	
	#Regular achievements
	for _achievement in account_data.achievements:
		if account_data.achievements[_achievement] == true or not ServerData.GetAchievement(_achievement):
			continue
		var achievement = ServerData.GetAchievement(_achievement)
		
		#In case account is outdated
		if not account_data.statistics.has(which):
			account_data.statistics[which] = 0
		
		#If standard achievement, simply check the amount
		if achievement.which == which and account_data.statistics[which] >= achievement.amount and not achievement.has("enemies"):
			account_data.achievements[_achievement] = true
			GetAchievement(_achievement)
		
		#In case of enemies killed, check the enemies in statistics
		elif achievement.which == "enemies_killed" and achievement.has("enemies") and achievement.enemies.has(which):
			var total = 0
			for enemy in achievement.enemies:
				if account_data.statistics.has(enemy):
					total += account_data.statistics[enemy]
			if total >= achievement.amount:
				GetAchievement(_achievement)

func GetAchievement(achievement_name):
	var character_data = ServerData.GetCharacter(character.class)
	var achievement_data = ServerData.GetAchievement(achievement_name)
	
	account_data.gold += achievement_data.gold
	account_data.achievements[achievement_name] = true
	if achievement_data.gold > 0:
		get_node("/root/Server").SendMessage(int(name), "success", "You recieved " + str(achievement_data.gold) + " gold!")
	
	#Check if unlocked new furntiure
	for building_id in ServerData.buildings.keys():
		var building = ServerData.GetBuilding(building_id)
		if building.has("achievement") and building.achievement == achievement_name:
			account_data.home.inventory[building.type+"s"][building_id] += 1
	
	#Check if unlocked new char
	if character_data.quests.has(achievement_name):
		character.class = character_data.quests[achievement_name]
		account_data.classes[character_data.quests[achievement_name]] = true
		
		var class_bonus_stats = character_data.bonus_stats
		for stat in character.stats.keys():
			character.stats[stat] += class_bonus_stats[stat]
	
	get_node("/root/Server").SendAccountData(name, account_data)
	get_node("/root/Server").SendCharacterData(name, character)
