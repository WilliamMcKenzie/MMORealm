extends Node

var collision_layer = 1
var instance_tree = []

var player_list = {}
var enemy_list = {}
var object_list = {}
var projectile_list = {}

var proj_id_ticker = 0

var tick_rate = 0.25
var running_time = 0
var last_tick = 0
var player_projectiles = {	
	"small" : preload("res://Scenes/Instances/Projectiles/Players/Small.tscn")
}
var enemy_projectiles = {
	"small" : preload("res://Scenes/Instances/Projectiles/Enemies/Small.tscn")
}
var enemy_8x8 = preload("res://Scenes/Instances/Enemies/Enemy_8x8.tscn")

func _ready():
	if name != "nexus":
		instance_tree = get_parent().object_list[name]["InstanceTree"].duplicate(true)
		instance_tree.append(name)
	else:
		instance_tree = ["nexus"]

func _physics_process(delta):
	for projectile_id in projectile_list.keys():
		pass
func _process(delta):	
	running_time += delta
	for i in range(floor((running_time-last_tick)/tick_rate)):
		for enemy_id in enemy_list.keys():
			if(enemy_list[enemy_id]["Health"] < 1):
				enemy_list.erase(enemy_id)
				continue
			if (enemy_list[enemy_id]["Behavior"] == 1):
				var target = enemy_list[enemy_id]["Target"]
				var position = enemy_list[enemy_id]["Position"]
				
				var x_move = -cos(position.angle_to_point(target))* 4 * delta
				var y_move = -sin(position.angle_to_point(target))* 4 * delta
				
				enemy_list[enemy_id]["Position"] += Vector2(x_move,y_move)
				
				if (target - position).length() <= 4:
					if (enemy_list[enemy_id]["AnchorPosition"]-position).length() >= 20:
						enemy_list[enemy_id]["Target"] = enemy_list[enemy_id]["AnchorPosition"]
					else:
						enemy_list[enemy_id]["Target"] = position + Vector2(rand_range(-100 * delta,100 * delta),rand_range(-100 * delta,100 * delta))
				
				if (enemy_list[enemy_id]["Cooldown"] <= 0):
					SpawnEnemyProjectile(enemy_list[enemy_id]["Projectile"],enemy_id,Vector2(0,0))
					pass	
				enemy_list[enemy_id]["Cooldown"] -= delta
				
		last_tick = running_time
func UpdatePlayer(player_id, player_state):
	if player_list.has(str(player_id)):
		player_list[str(player_id)]["Position"] = player_state["P"]
		player_list[str(player_id)]["Animation"] = player_state["A"]
		player_list[str(player_id)]["Sprite"] = player_state["S"]
		get_node("YSort/Players/"+str(player_id)).position = player_list[str(player_id)]["Position"]

func SpawnPlayer(player_container):
	if player_container:
		player_list[player_container.name] = {
				"Name": player_container.name,
				"Position": player_container.position,
				"Animation": { "A" : "Idle", "C" : Vector2.ZERO }
			}
		get_node("YSort/Players").add_child(player_container)

func RemovePlayer(player_container):
	if player_container:
		player_list.erase(player_container.name)
		get_node("YSort/Players").remove_child(player_container)

func SpawnEnemy(enemy, enemy_id):
	enemy_list[str(enemy_id)] = enemy

func SpawnPlayerProjectile(projectile_data, player_id):
	
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

func SpawnEnemyProjectile(projectile, enemy_id, direction):
	var projectile_data = ServerData.GetProjectile(projectile)
	
	if proj_id_ticker <= 2174000:
		proj_id_ticker += 1
	else:
		proj_id_ticker = 0
	projectile_list[proj_id_ticker] = projectile_data
	projectile_list[proj_id_ticker]["Position"] = get_node("YSort/Enemies").get_node(enemy_id).position
	projectile_list[proj_id_ticker]["EnemyId"] = enemy_id

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
		"Name": "Bag"+str(loot_bag_tier),
		"Soulbound": soulbound,
		"Tier": loot_bag_tier,
		"Loot": loot,
		"PlayerId": str(player_id),
		"Type": "LootBags",
		"EndTime": OS.get_system_time_msecs()+9999999999,
		"Position": position,
		"InstanceTree": instance_tree
	}
	

func OpenPortal(portal_name, instance_tree, position):
	var instance_id = get_node("/root/Server").generate_unique_id()
	if portal_name == "island":
		instance_id = "island " + instance_id
		var island_instance = load("res://Scenes/Instances/Island/Island.tscn").instance()
		island_instance.name = instance_id
		
		object_list[instance_id] = {
			"Name":"island",
			"Type":"DungeonPortals",
			"EndTime": OS.get_system_time_msecs()+99999999999999,
			"Position": position,
			"InstanceTree": instance_tree
		}
		
		island_instance.GenerateIslandMap()
		island_instance.position = Instances.GetFreeInstancePosition()
		add_child(island_instance)
		Instances.AddInstanceToTracker(instance_tree, instance_id)
	else:
		var instance_map = Dungeons.GenerateDungeon(portal_name)
		var dungeon_instance = load("res://Scenes/Instances/Dungeons/Dungeon.tscn").instance()
		dungeon_instance.name = instance_id
		dungeon_instance.map = instance_map
		dungeon_instance.position = Instances.GetFreeInstancePosition()
		
		object_list[instance_id] = {
			"Name":portal_name,
			"Type":"DungeonPortals",
			"EndTime": OS.get_system_time_msecs()+10000,
			"Position": position,
			"InstanceTree": instance_tree
		}
		
		add_child(dungeon_instance)
		Instances.AddInstanceToTracker(instance_tree, instance_id)
