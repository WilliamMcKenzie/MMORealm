extends Node

var map = []

var player_list = {}
var enemy_list = {}
var object_list = {}

var player_projectiles = {
	"arrow" : preload("res://Scenes/Instances/Projectiles/Players/Arrow.tscn")	
}
var enemy_projectiles = {
	"arrow" : preload("res://Scenes/Instances/Projectiles/Enemies/Arrow.tscn")
}
var enemy_8x8 = preload("res://Scenes/Instances/Enemies/Enemy_8x8.tscn")

func _physics_process(delta):
	for enemy_id in enemy_list.keys():
		if(enemy_list[enemy_id]["Health"] < 1):
			enemy_list.erase(enemy_id)

func UpdatePlayer(player_id, player_state):
	if player_list.has(str(player_id)):
		player_list[str(player_id)]["Position"] = player_state["P"]
		player_list[str(player_id)]["Animation"] = player_state["A"]
		get_node("YSort/Players/"+str(player_id)).position = player_list[str(player_id)]["Position"]
func SpawnPlayer(player_container):
	player_list[player_container.name] = {
			"Name": player_container.name,
			"Position": player_container.position,
			"Animation": { "A" : "Idle", "C" : Vector2.ZERO }
		}
	get_node("YSort/Players").add_child(player_container)
func RemovePlayer(player_container):
	player_list.erase(player_container.name)
	var player_container_node = get_node("YSort/Players").remove_child(player_container)

func SpawnPlayerProjectile(projectile_data, player_id):
	var projectile_instance = player_projectiles["arrow"].instance()
	projectile_instance.player_id = player_id
	projectile_instance.projectile_name = projectile_data["Projectile"]
	projectile_instance.position = projectile_data["Position"] + position
	projectile_instance.tile_range = projectile_data["TileRange"]
	projectile_instance.SetDirection(projectile_data["Direction"])
	projectile_instance.look_at(projectile_data["MousePosition"])
	
	var data = ServerData.GetProjectileData(projectile_data["Projectile"])
	projectile_instance.SetData(data)
	
	add_child(projectile_instance)
func SpawnEnemyProjectile(projectile_data, enemy_id):
	var projectile_instance = enemy_projectiles["arrow"].instance()
	projectile_instance.enemy_id = enemy_id
	projectile_instance.projectile_name = projectile_data["Projectile"]
	projectile_instance.position = projectile_data["Position"]
	projectile_instance.tile_range = projectile_data["TileRange"]
	projectile_instance.SetDirection(projectile_data["Direction"])
	projectile_instance.look_at(projectile_data["TargetPosition"])
	
	var data = ServerData.GetProjectileData(projectile_data["Projectile"])
	projectile_instance.SetData(data)
	get_node("/root/Server").SendEnemyProjectile(projectile_data, ["nexus"], enemy_id, self.position)
	
	add_child(projectile_instance)

func SpawnEnemy(enemy, enemy_id):
	var new_enemy = enemy_8x8.instance()
	enemy_list[str(enemy_id)] = enemy
	new_enemy.position = enemy["Position"] + self.position
	new_enemy.name = enemy_id
	new_enemy.set_script(load("res://Scenes/Instances/Enemies/Behavior/"+enemy["Behavior"]+".gd"))
	get_node("YSort/Enemies/").add_child(new_enemy, true)
	
func OpenPortal(portal_name, instance_tree, position):
	var instance_id = get_node("/root/Server").generate_unique_id()
	if portal_name == "island":
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
