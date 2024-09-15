extends Node2D

var collision_layer = 1
var instance_tree = []

var player_list = {}
var enemy_list = {}
var object_list = {}
var projectile_list = {}

var projectile_id_counter = "0"

var tick_rate = 0.1
var running_time = 0
var last_tick = 0
var use_chunks = false
var player_projectiles = {
	"small" : preload("res://Scenes/SupportScenes/Projectiles/Players/Small.tscn")
}
var enemy_projectiles = {
	"small" : preload("res://Scenes/SupportScenes/Projectiles/Enemies/Small.tscn")
}
var enemy_8x8 = preload("res://Scenes/SupportScenes/Enemies/Enemy_8x8.tscn")

var expression = Expression.new()

func _ready():
	if name != "nexus":
		if get_parent().object_list.has(name):
			instance_tree = get_parent().object_list[name]["instance_tree"].duplicate(true)
			instance_tree.append(name)
	else:
		instance_tree = ["nexus"]

func _physics_process(delta):
	running_time += delta
	if not get_world_2d():
		return
	for projectile_id in projectile_list.keys():
		var projectile = projectile_list[projectile_id]
		var alive_time = OS.get_system_time_msecs()/1000-projectile["start_time"]
		expression.parse(projectile["formula"],["x"])
		
		var velocity = projectile.direction.normalized()*projectile.speed
		var vertical_move_vector = projectile["speed"] * projectile["direction"] * delta
		var perpendicular_vector = Vector2(-velocity.y, velocity.x)
		var horizontal_move_vector = perpendicular_vector * expression.execute([alive_time * 50]) * 0.05
		
		projectile_list[projectile_id]["path"] += vertical_move_vector
		projectile_list[projectile_id]["position"] = projectile_list[projectile_id]["path"] + horizontal_move_vector
		
		var space_state = get_world_2d().direct_space_state
		
		var collision = space_state.intersect_point(projectile_list[projectile_id]["position"]+self.global_position, 1, [], 1, true, true)
		var valid_collision = collision.size() > 0 and collision[0].collider.name != "PlayerHitbox"
		var max_range = projectile_list[projectile_id]["start_position"].distance_to(projectile_list[projectile_id]["path"]) >= projectile_list[projectile_id]["tile_range"]*8
		
		for player_id in player_list.keys():
			if not projectile_list[projectile_id]["hit_players"].has(player_id) and (player_list[player_id]["position"]+Vector2(0,-4)).distance_to(projectile_list[projectile_id]["position"]) <= projectile_list[projectile_id]["size"]:
				if has_node("YSort/Players/"+player_id):
					projectile_list[projectile_id]["hit_players"][player_id] = true
					get_node("YSort/Players/"+player_id).DealDamage(projectile_list[projectile_id]["damage"], projectile_list[projectile_id]["enemy_name"])
					if not projectile_list[projectile_id].piercing:
						valid_collision = true
		if valid_collision or max_range:
			get_node("/root/Server").RemoveEnemyProjectile(projectile_id, instance_tree)
			projectile_list.erase(projectile_id)
	
	for i in range(floor((running_time-last_tick)/tick_rate)):
		
		for enemy_id in enemy_list.keys():
			for _effect in enemy_list[enemy_id]["effects"].keys():
				enemy_list[enemy_id]["effects"][_effect] -= tick_rate
				if enemy_list[enemy_id]["effects"][_effect] <= 0:
					enemy_list[enemy_id]["effects"].erase(_effect)
			for _signal in enemy_list[enemy_id]["signals"].keys():
				enemy_list[enemy_id]["signals"][_signal] -= tick_rate
				if enemy_list[enemy_id]["signals"][_signal] <= 0:
					enemy_list[enemy_id]["signals"].erase(_signal)
			
			#Check if we need to switch phase
			var _phases = ServerData.GetEnemy(enemy_list[enemy_id]["name"]).phases
			if _phases.size() == 0:
				continue
			
			var __phase_index = enemy_list[enemy_id]["phase_index"]
			var _phase = _phases[__phase_index]
			
			var _health_ratio = (enemy_list[enemy_id].health/enemy_list[enemy_id].max_health)*100
			var _health = _health_ratio >= _phase.health[0] and _health_ratio <= _phase.health[1] 
			
			if not _health:
				enemy_list[enemy_id]["phase_timer"] = 0
				enemy_list[enemy_id]["pattern_timer"] = 0
			if _phase.has("behavior"):
				enemy_list[enemy_id]["behavior"] = _phase["behavior"]
			if _phase.has("speed"):
				enemy_list[enemy_id]["speed"] = _phase["speed"]
			
			enemy_list[enemy_id]["pattern_timer"] -= tick_rate
			enemy_list[enemy_id]["phase_timer"] -= tick_rate
			
			if enemy_list[enemy_id]["phase_timer"] <= 0:
				var enemy_data = ServerData.GetEnemy(enemy_list[enemy_id]["name"])
				var phases = enemy_data.phases
				var phase_index = enemy_list[enemy_id]["phase_index"]
				
				var possible_phases = []
				var _phase_index = -1
				for phase in phases:
					_phase_index += 1
					var health_ratio = (enemy_list[enemy_id].health/enemy_list[enemy_id].max_health)*100
					var health = health_ratio >= phase.health[0] and health_ratio <= phase.health[1] 
					
					var used_before = enemy_list[enemy_id]["used_phases"].has(_phase_index)
					var use_limit = phase.has("max_uses")
					var on_signal = phase.has("on_signal")
					var on_spawn = phase.has("on_spawn")
					var possible = not use_limit or not used_before or (used_before and phase.max_uses > enemy_list[enemy_id]["used_phases"][_phase_index])
					
					if on_signal and health and possible:
						var has_signals = true
						for _signal in phase["on_signal"]:
							if not enemy_list[enemy_id]["signals"].has(_signal):
								has_signals = false
								break
						if has_signals:
							possible_phases = [_phase_index]
							break;
						else:
							continue
					elif on_signal:
						continue
					
					if on_spawn and health and possible:
						possible_phases = [_phase_index]
						break;
					if health and possible:
						possible_phases.append(_phase_index)
				
				if len(possible_phases) > 0:
					var chosen_index = possible_phases[randi() % len(possible_phases)]
					
					#Check if used before
					var used_before = enemy_list[enemy_id]["used_phases"].has(chosen_index)
					if used_before:
						enemy_list[enemy_id]["used_phases"][chosen_index] += 1
					else:
						enemy_list[enemy_id]["used_phases"][chosen_index] = 1
					
					if enemy_list[enemy_id]["phase_index"] != chosen_index:
						enemy_list[enemy_id]["pattern_index"] = 0
					
					enemy_list[enemy_id]["phase_index"] = chosen_index
					enemy_list[enemy_id]["phase_timer"] = phases[chosen_index].duration
			
			while enemy_list[enemy_id]["pattern_timer"] <= 0:
				var enemy_data = ServerData.GetEnemy(enemy_list[enemy_id]["name"])
				var phase_index = enemy_list[enemy_id]["phase_index"]
				
				var attack_pattern = enemy_data["phases"][phase_index].attack_pattern
				var current_attack = attack_pattern[enemy_list[enemy_id]["pattern_index"]]
				
				var is_projectile = current_attack.has("projectile")
				var is_signal = current_attack.has("signal")
				var is_summon = current_attack.has("summon")
				var is_speech = current_attack.has("speech")
				var is_effect = current_attack.has("effect")
				var is_dead = current_attack.has("dead")
				
				if is_projectile and not (enemy_list[enemy_id].has("dead") and enemy_list[enemy_id]["dead"] == true):
					#if targeter is nearest, direction is added onto player position so you can for instance do shotguns 
					var direction = current_attack["direction"].normalized()
					var no_projectile = false
					if not current_attack.has("targeter"):
						pass
					elif current_attack["targeter"] == "nearest":
						var closest = 9999999
						for player_id in player_list.keys():
							var player_position = player_list[player_id]["position"]+Vector2(0,-4)
							if player_position.distance_to(enemy_list[enemy_id]["position"]) <= closest:
								closest = player_position.distance_to(enemy_list[enemy_id]["position"])
								direction = enemy_list[enemy_id]["position"].direction_to((player_position))
								direction = OffsetProjectileAngle(direction, current_attack["direction"])
						if closest == 9999999 or closest > 8*8:
							no_projectile = true
							enemy_list[enemy_id]["pattern_timer"] = current_attack["wait"]
					
					if not no_projectile:
						var projectile_data = {
							"id" : projectile_id_counter,
							"name" : current_attack["projectile"],
							"position" : enemy_list[enemy_id]["position"],
							"direction" : direction,
							"tile_range" : current_attack["tile_range"],
							"start_position" : enemy_list[enemy_id]["position"],
							"start_time" : OS.get_system_time_msecs()/1000,
							"damage" : current_attack["damage"],
							"piercing" : current_attack["piercing"],
							"speed" : current_attack["speed"],
							"formula" : current_attack["formula"],
							"path" : enemy_list[enemy_id]["position"],
							"hit_players" : {},
							"size" : current_attack["size"],
						}
						SpawnEnemyProjectile(projectile_data, instance_tree, enemy_id, enemy_list[enemy_id]["name"])
				
				elif is_signal:
					var signal_type = current_attack["signal"]
					var reciever = current_attack["reciever"]
					var duration = current_attack["duration"]
					var origin = enemy_list[enemy_id]["origin"]
					
					if reciever == "parent" and enemy_list.has(origin):
						enemy_list[origin]["signals"][signal_type] = duration
					else:
						for _enemy_id in enemy_list.keys():
							if enemy_list[_enemy_id].name == reciever:
								enemy_list[_enemy_id]["signals"][signal_type] = duration
				
				elif is_summon:
					var summon_position = current_attack["summon_position"] + enemy_list[enemy_id]["position"]
					get_node("/root/Server").SpawnNPC(current_attack["summon"], instance_tree, summon_position-position, enemy_id)
				
				elif is_speech:
					var message = current_attack["speech"]
					get_node("/root/Server").EnemySpeech(enemy_list[enemy_id]["name"], enemy_id, message)
				
				elif is_dead:
					var dead = current_attack["dead"]
					enemy_list[enemy_id]["dead"] = dead
				
				elif is_effect:
					var effect = current_attack["effect"]
					var duration = current_attack["duration"]
					enemy_list[enemy_id]["effects"][effect] = duration
				
				enemy_list[enemy_id]["pattern_timer"] = current_attack["wait"]
				if enemy_list[enemy_id]["pattern_index"] == len(attack_pattern)-1:
					enemy_list[enemy_id]["pattern_index"] = 0
				else:
					enemy_list[enemy_id]["pattern_index"] += 1
			
			#For dungeons and nexus
			if(enemy_list[enemy_id]["health"] < 1) and use_chunks == false:
				if not "arena" in name:
					CalculateLootPool(enemy_list[enemy_id], enemy_id)
				enemy_list.erase(enemy_id)
				continue
			
			if enemy_list[enemy_id].has("dead") and enemy_list[enemy_id]["dead"]:
				pass
			elif (enemy_list[enemy_id]["behavior"] == 0):
				enemy_list[enemy_id] = Behaviors.Stationary(enemy_list[enemy_id], tick_rate, self)
			elif (enemy_list[enemy_id]["behavior"] == 1):
				enemy_list[enemy_id] = Behaviors.Wander(enemy_list[enemy_id], tick_rate, self)
			elif (enemy_list[enemy_id]["behavior"] == 2):
				enemy_list[enemy_id] = Behaviors.Chase(enemy_list[enemy_id], tick_rate, self)
			
		if use_chunks == false:
			last_tick = running_time

func UpdatePlayer(player_id, player_state):
	if player_list.has(str(player_id)):
		player_list[str(player_id)]["position"] = player_state["P"]
		player_list[str(player_id)]["animation"] = player_state["A"]
		player_list[str(player_id)]["sprite"] = player_state["S"]
		get_node("YSort/Players/"+str(player_id)).position = player_list[str(player_id)]["position"]
		
		var space_state = get_world_2d().direct_space_state
		var collision = space_state.intersect_point(player_list[str(player_id)]["position"]+position, 1, [], 1, true, true)
		var colliding = collision.size() > 0
		
		if colliding:
			for collision_data in collision:
				if collision_data.collider.name == "TileMap":
					get_node("/root/Server").network.disconnect_peer(player_id)
					break

func SpawnPlayer(player_container):
	if player_container:
		var username = "[unset]"
		if player_container.account_data:
			username = player_container.account_data.username
		player_list[player_container.name] = {
				"name": username,
				"status_effects" : [],
				"position": player_container.position,
				"animation": { "A" : "Idle", "C" : Vector2.ZERO },
				"sprite": { "R" : Rect2(Vector2(0,0), Vector2(80,40)), "C" : "Apprentice", "P" : {
					"ColorParams" : {},
					"TextureParams" : {
						"swordTexture" : "flame",
						"helmetTexture" : "flame",
						"bodyTexture" : "flame",
					}
				}}
			}
		get_node("YSort/Players").add_child(player_container)

func RemovePlayer(player_container):
	if player_container:
		player_list.erase(player_container.name)
		get_node("YSort/Players").remove_child(player_container)

func SpawnEnemy(enemy, enemy_id):
	enemy_list[str(enemy_id)] = enemy

func SpawnPlayerProjectile(projectile_data, player_id):
	if not get_node("YSort/Players/"+str(player_id)).gear.has("weapon"):
		return
	var player_weapon = get_node("YSort/Players/"+str(player_id)).gear.weapon
	var projectile_instance = player_projectiles["small"].instance()
	
	projectile_instance.character = get_node("YSort/Players/"+str(player_id)).character
	projectile_instance.player_id = player_id
	projectile_instance.position = get_node("YSort/Players/"+str(player_id)).position
	projectile_instance.initial_position = get_node("YSort/Players/"+str(player_id)).position
	projectile_instance.SetDirection(projectile_data["Direction"])
	projectile_instance.look_at(projectile_data["MousePosition"])
	
	var data = ServerData.GetProjectile(player_weapon.projectile)
	projectile_instance.SetData(data)
	
	add_child(projectile_instance)

func SpawnEnemyProjectile(projectile_data, instance, enemy_id, enemy_name):
	projectile_data["enemy_id"] = enemy_id
	projectile_data["enemy_name"] = enemy_name
	projectile_list[projectile_id_counter] = projectile_data
	if int(projectile_id_counter) <= 2174000:
		projectile_id_counter = str(int(projectile_id_counter)+1)
	else:
		projectile_id_counter = "0"
		
	get_node("/root/Server").SendEnemyProjectile(projectile_data, instance_tree, enemy_id)

func OffsetProjectileAngle(base_direction, offset_vector):
	var base_angle = base_direction.angle()
	var offset_angle = offset_vector.angle()
	var new_angle = base_angle + offset_angle
	var new_direction = Vector2(cos(new_angle), sin(new_angle))
	
	return new_direction

func SpawnLootBag(_loot, player_id, instance_tree, position):
	var loot_id = "loot "+get_node("/root/Server").generate_unique_id()
	var soulbound = false
	var loot_bag_tier = 0
	var loot = [
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
	]
	
	if player_id != null:
		var highest_loot_tier = 0
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
		for raw_item in _loot:
			loot[i] = raw_item
			i += 1
			var item = ServerData.GetItem(raw_item.item)
			if int(item.tier) > highest_loot_tier:
				highest_loot_tier = int(item.tier)
			elif item.tier == "UT":
				highest_loot_tier = 6
		loot_bag_tier = loot_bag_tier_translation[highest_loot_tier]
		
		if loot_bag_tier > 1:
			soulbound = true
	else:
		var i = 0
		for raw_item in _loot:
			loot[i] = raw_item
			i += 1
	
	object_list[loot_id] = {
		"name": "Bag"+str(loot_bag_tier),
		"soulbound": soulbound,
		"tier": loot_bag_tier,
		"loot": loot,
		"player_id": str(player_id),
		"type": "LootBags",
		"end_time": OS.get_system_time_msecs()+40000,
		"position": position,
		"instance_tree": instance_tree
	}

class SortByValue:
	static func sort_ascending(a, b):
		if a[1] < b[1]:
			return true
		return false
func CalculateLootPool(enemy, enemy_id):
	randomize()
	if ServerData.GetEnemy(enemy.name).has("dungeon") and randf() < ServerData.GetEnemy(enemy.name).dungeon.rate:
		OpenPortal(ServerData.GetEnemy(enemy.name).dungeon.name, instance_tree, enemy.position)
	
	var player_pool = enemy["damage_tracker"]
	var loot_pool = ServerData.GetEnemy(enemy["name"]).loot_pool
	
	#Handle EXP
	var exp_amount = ServerData.GetEnemy(enemy["name"]).exp
	for player_id in player_pool.keys():
		var player_container = get_node("YSort/Players/"+str(player_id))
		if not player_container:
			player_pool.erase(player_id)
		else:
			player_container.AddExp(exp_amount, enemy["name"], enemy_id)
	
	#Handle loot drops
	var ordered_pairs = []
	for player_id in player_pool.keys():
		ordered_pairs.append([player_id, player_pool[player_id]])
	
	ordered_pairs.sort_custom(SortByValue, "sort_ascending")
	
	var loot_bags = []
	var i = 0
	
	#Soulbound loot
	for pair in ordered_pairs:
		var player_id = pair[0]
		var damage_percent = pair[1]/enemy["max_health"]
		var loot_bag = {
			"player_id" : player_id,
			"loot" : []
		}
		
		for item in loot_pool.soulbound_loot:
			if randf() < item.chance and damage_percent > item.threshold:
				loot_bag.loot.append({
					"item" : item.item,
					"id" : get_node("/root/Server").generate_unique_id()
				})
		if loot_bag.loot != []:
			loot_bags.append(loot_bag)
	
	#Non soulbound loot
	var loot_bag = {
		"player_id" : null,
		"loot" : []
	}
	for item in loot_pool.loot:
		if randf() < item.chance:
			loot_bag.loot.append({
				"item" : item.item,
				"id" : get_node("/root/Server").generate_unique_id()
			})
	if loot_bag.loot != []:
			loot_bags.append(loot_bag)
		
	for _loot_bag in loot_bags:
		get_node("/root/Server").get_node("Instances/"+get_node("/root/Server").StringifyInstanceTree(instance_tree)).SpawnLootBag(_loot_bag.loot, _loot_bag.player_id, instance_tree, enemy.position+Vector2(rand_range(-3,3), rand_range(-3,3)))

func _compare_values(a, b):
	return a[1] - b[1]

var taken_points = []
func GetBoatSpawnpoints():
	var room_size = 50
	var res = []
	
	for x in range(-room_size, room_size*2):
		for y in range(-room_size, room_size*2):
			var current_tile = $TileMap.get_cell(x,y)
			var current_position = Vector2(x*8, y*8) - position + Vector2(4,4)
			
			if current_tile == 12:
				res.append(current_position)
				
	var index = round(rand_range(0, res.size()-1))
	while(taken_points.has(index)):
		index = round(rand_range(0, res.size()-1))
	taken_points.append(index)
	return res[index]
	
func OpenPortal(portal_name, instance_tree, position, map_size = Vector2(750,750), ruler = "salazar_the_red"):
	var instance_id = get_node("/root/Server").generate_unique_id()
	if "island" in portal_name:
		instance_id = portal_name + " " + instance_id
		var island_instance
		
		if GameplayLoop.island_preloads.has(map_size):
			var islands = GameplayLoop.island_preloads[map_size]
			var boilerplate_island_instance = islands[randi() % len(islands)]
			island_instance = boilerplate_island_instance.duplicate()
			island_instance.server_ref = boilerplate_island_instance.server_ref
			island_instance.map_size = boilerplate_island_instance.map_size
			island_instance.spawn_points = boilerplate_island_instance.spawn_points
			island_instance.tile_points = boilerplate_island_instance.tile_points
			island_instance.map_as_array = boilerplate_island_instance.map_as_array.duplicate(true)
			island_instance.map_objects = boilerplate_island_instance.map_objects
			island_instance.enemy_spawn_points = boilerplate_island_instance.enemy_spawn_points
			var tilemap = island_instance.get_node("TileMap") 
			tilemap = island_instance.get_node("TileMap").duplicate()
		else:
			island_instance = load("res://Scenes/SupportScenes/Island/Island.tscn").instance()
			if portal_name == "tutorial_island":
				island_instance = load("res://Scenes/SupportScenes/Island/TutorialIsland.tscn").instance()
		
			island_instance.server_ref = get_node("/root/Server")
			island_instance.map_size = map_size
			island_instance.GenerateIslandMap()
			GameplayLoop.island_preloads[map_size] = [island_instance.duplicate()]
		
		island_instance.ruler = ruler
		island_instance.name = instance_id
		object_list[instance_id] = {
			"name": portal_name,
			"ruler": ruler,
			"type":"DungeonPortals",
			"end_time": OS.get_system_time_msecs()+OS.get_system_time_msecs(),
			"position": position,
			"instance_tree": instance_tree
		}
		
		island_instance.position = Instances.GetFreeInstancePosition()
		add_child(island_instance)
		Instances.AddInstanceToTracker(instance_tree, instance_id)
		return instance_id
	elif "house" in portal_name:
		object_list[instance_id] = {
			"name":"house",
			"type":"DungeonPortals",
			"end_time": OS.get_system_time_msecs()+OS.get_system_time_msecs(),
			"position": position,
			"instance_tree": instance_tree
		}
	else:
		instance_id =  "dungeon " + instance_id
		var instance_map = Dungeons.GenerateDungeon(portal_name)
		var tile_translation = ServerData.dungeons[portal_name].tile_translation
		var dungeon_instance = load("res://Scenes/SupportScenes/Dungeons/Dungeon.tscn").instance()
		dungeon_instance.name = instance_id
		dungeon_instance.map = instance_map
		dungeon_instance.dungeon_name = portal_name
		dungeon_instance.dungeon_boss = ServerData.dungeons[portal_name].dungeon_boss
		dungeon_instance.room_size = ServerData.dungeons[portal_name].room_size
		dungeon_instance.tile_translation = tile_translation
		dungeon_instance.position = Instances.GetFreeInstancePosition()
		
		object_list[instance_id] = {
			"name":portal_name,
			"type":"DungeonPortals",
			"end_time": OS.get_system_time_msecs()+30000,
			"position": position,
			"instance_tree": instance_tree
		}
		
		add_child(dungeon_instance)
		Instances.AddInstanceToTracker(instance_tree, instance_id)
		return instance_id

func SpawnNPC(npc_name, instance_tree, position):
	object_list[npc_name] = {
		"name": npc_name,
		"type":"Npcs",
		"end_time": OS.get_system_time_msecs()+OS.get_system_time_msecs(),
		"position": position,
		"instance_tree": instance_tree
	}
