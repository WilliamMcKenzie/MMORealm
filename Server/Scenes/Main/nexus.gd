extends Node

var collision_layer = 1
var instance_tree = []

var player_list = {}
var enemy_list = {}
var object_list = {}

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

func _ready():
	if name != "nexus":
		instance_tree = get_parent().object_list[name]["instance_tree"].duplicate(true)
		instance_tree.append(name)
	else:
		instance_tree = ["nexus"]

func _physics_process(delta):
	running_time += delta
	for i in range(floor((running_time-last_tick)/tick_rate)):
		for enemy_id in enemy_list.keys():
			
			#For everything including island
			if(enemy_list[enemy_id]["health"] < 1):
				CalculateLootPool(enemy_list[enemy_id])
			
			#For dungeons and nexus
			if(enemy_list[enemy_id]["health"] < 1) and use_chunks == false:
				enemy_list.erase(enemy_id)
				continue
				
			if (enemy_list[enemy_id]["behavior"] == 1):
				
				var target = enemy_list[enemy_id]["target"]
				var position = enemy_list[enemy_id]["position"]
				
				var x_move = -cos(position.angle_to_point(target))*(0.1/tick_rate)
				var y_move = -sin(position.angle_to_point(target))*(0.1/tick_rate)
				
				enemy_list[enemy_id]["position"] += Vector2(x_move,y_move)
				
				if (target - position).length() <= 4:
					if (enemy_list[enemy_id]["anchor_position"]-position).length() >= 20:
						enemy_list[enemy_id]["target"] = enemy_list[enemy_id]["anchor_position"]
					else:
						enemy_list[enemy_id]["target"] = position + Vector2(rand_range(-7,7),rand_range(-7,7))
		if use_chunks == false:
			last_tick = running_time

func UpdatePlayer(player_id, player_state):
	if player_list.has(str(player_id)):
		player_list[str(player_id)]["position"] = player_state["P"]
		player_list[str(player_id)]["animation"] = player_state["A"]
		player_list[str(player_id)]["sprite"] = player_state["S"]
		get_node("YSort/Players/"+str(player_id)).position = player_list[str(player_id)]["position"]

func SpawnPlayer(player_container):
	if player_container:
		player_list[player_container.name] = {
				"name": player_container.name,
				"position": player_container.position,
				"animation": { "A" : "Idle", "C" : Vector2.ZERO }
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

func SpawnEnemyProjectile(projectile_data, enemy_id):
	var projectile_instance = enemy_projectiles["small"].instance()
	projectile_instance.enemy_id = enemy_id
	projectile_instance.projectile_name = projectile_data["Projectile"]
	projectile_instance.position = projectile_data["Position"]
	projectile_instance.initial_position = projectile_data["Position"]
	projectile_instance.tile_range = projectile_data["TileRange"]
	projectile_instance.SetDirection(projectile_data["Direction"])
	projectile_instance.look_at(projectile_data["TargetPosition"])
	
	var data = ServerData.GetProjectile(projectile_data["Projectile"])
	projectile_instance.SetData(data)
	
	get_node("/root/Server").SendEnemyProjectile(projectile_data, instance_tree, enemy_id)
	add_child(projectile_instance)

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
func CalculateLootPool(enemy):
	randomize()
	var player_pool = enemy["damage_tracker"]
	var loot_pool = ServerData.GetEnemy(enemy["name"]).loot_pool
	
	var ordered_pairs = []
	for player in player_pool.keys():
		ordered_pairs.append([player, player_pool[player]])
	
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
		
func OpenPortal(portal_name, instance_tree, position):
	var instance_id = get_node("/root/Server").generate_unique_id()
	if portal_name == "island":
		instance_id = "island " + instance_id
		var island_instance = load("res://Scenes/SupportScenes/Island/Island.tscn").instance()
		island_instance.name = instance_id
		
		object_list[instance_id] = {
			"name":"island",
			"type":"DungeonPortals",
			"end_time": OS.get_system_time_msecs()+99999999999999,
			"position": position,
			"instance_tree": instance_tree
		}
		
		island_instance.GenerateIslandMap()
		island_instance.position = Instances.GetFreeInstancePosition()
		add_child(island_instance)
		Instances.AddInstanceToTracker(instance_tree, instance_id)
	else:
		var instance_map = Dungeons.GenerateDungeon(portal_name)
		var dungeon_instance = load("res://Scenes/SupportScenes/Dungeons/Dungeon.tscn").instance()
		dungeon_instance.name = instance_id
		dungeon_instance.map = instance_map
		dungeon_instance.position = Instances.GetFreeInstancePosition()
		
		object_list[instance_id] = {
			"name":portal_name,
			"type":"DungeonPortals",
			"end_time": OS.get_system_time_msecs()+10000,
			"position": position,
			"instance_tree": instance_tree
		}
		
		add_child(dungeon_instance)
		Instances.AddInstanceToTracker(instance_tree, instance_id)
