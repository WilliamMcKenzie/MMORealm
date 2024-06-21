extends Node

var collision_layer = 1
var instance_tree = []

var player_list = {}
var enemy_list = {}
var object_list = {}

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
	for enemy_id in enemy_list.keys():
		if(enemy_list[enemy_id]["Health"] < 1):
			enemy_list.erase(enemy_id)

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
	var new_enemy = enemy_8x8.instance()
	enemy_list[str(enemy_id)] = enemy
	new_enemy.position = enemy["Position"] + self.position
	new_enemy.name = enemy_id
	new_enemy.set_script(load("res://Scenes/Instances/Enemies/Behavior/"+enemy["Behavior"]+".gd"))
	get_node("YSort/Enemies/").add_child(new_enemy, true)

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
	
	
	var highest_loot_tier = 0
	var loot_bag_tier = 0
	var loot_bag_tier_translation = {
		0 : 0,
		1 : 0,
		2 : 1,
		3 : 1,
		4 : 2,
		5 : 2,
		6 : 3
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
			
	object_list[loot_id] = {
		"Name": "Bag"+str(loot_bag_tier),
		"Soulbound": soulbound,
		"Tier": loot_bag_tier,
		"Loot": loot,
		"PlayerId": player_id,
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
