extends Node2D

var map = []
var enemy_list = {}

var arrow_projectile = preload("res://Scenes/Instances/Projectiles/ServerArrow.tscn")
var enemy_8x8 = preload("res://Scenes/Instances/Enemies/Enemy_8x8.tscn")

func SpawnProjectile(projectile_data, player_id):
	var projectile_instance = arrow_projectile.instance()
	projectile_instance.player_id = player_id
	projectile_instance.projectile_name = projectile_data["Projectile"]
	projectile_instance.position = projectile_data["Position"]
	projectile_instance.tile_range = projectile_data["TileRange"]
	projectile_instance.SetDirection(projectile_data["Direction"])
	projectile_instance.look_at(projectile_data["MousePosition"])
	
	var data = ServerData.GetProjectileData(projectile_data["Projectile"])
	projectile_instance.SetData(data)
	
	add_child(projectile_instance)
	print("Shot")

func SpawnEnemy(enemy_id, position, hitbox_type):
	var new_enemy = enemy_8x8.instance()
	new_enemy.position = position
	new_enemy.name = enemy_id
	get_node("YSort/Enemies/").add_child(new_enemy, true)

func _physics_process(delta):
	for enemy_id in enemy_list.keys():
		if(enemy_list[enemy_id]["Health"] < 1):
			enemy_list.erase(enemy_id)
			get_node("/root/Server").enemies_state_collection.erase(enemy_id)
