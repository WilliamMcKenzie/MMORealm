extends Node2D

var player_spawn = preload("res://Scenes/SupportScenes/PlayerCharacter/PlayerTemplate.tscn")
var last_world_state = 0

var world_state_buffer = []
const interpolation_offset = 100

var active_projectiles = []

var expression = Expression.new()

var clock_sync_timer_2 = 0
func _physics_process(delta):
	clock_sync_timer_2 += 1
	if GameUI.is_dead:
		return
	
	var render_time = Server.client_clock - interpolation_offset
	if world_state_buffer.size() > 1:
		#Remove excess worldstates, leaving only usable ones
		while(world_state_buffer.size() > 2 and render_time > world_state_buffer[2].T):
			world_state_buffer.remove(0)
		
		#Loop through and update specific world elements
		if world_state_buffer.size() > 2:
			var interpolation_factor = float(render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[1]["T"])
			var lost = 0
			
			#Update players
			for player in world_state_buffer[2]["P"].keys():
				var players1 = world_state_buffer[1]["P"]
				var players2 = world_state_buffer[2]["P"]
				
				var current_player = player == str(get_tree().get_network_unique_id())
				var lost_player = not players1.has(player)
				
				if current_player or lost_player:
					continue;
				elif get_node("YSort/OtherPlayers").has_node(str(player)):
					var new_position = lerp(players1[player]["position"], players2[player]["position"], interpolation_factor)
					get_node("YSort/OtherPlayers/" + str(player)).MovePlayer(new_position, players2[player]["animation"], players2[player]["sprite"])
					get_node("YSort/OtherPlayers/" + str(player)).UpdateStatusEffects(players2[player]["status_effects"])
				else:
					SpawnNewPlayer(player, players2[player]["position"], players2[player]["sprite"]["C"], players2[player]["name"])
			RefreshPlayers(world_state_buffer[2]["P"])
			
			#Update enemies
			for enemy in world_state_buffer[2]["E"].keys():
				var enemies1 = world_state_buffer[1]["E"]
				var enemies2 = world_state_buffer[2]["E"]
				
				var lost_enemy1 = not enemies2.has(enemy)
				var lost_enemy2 = not enemies1.has(enemy)
				
				if lost_enemy1 or lost_enemy2:
					pass
				elif get_node("YSort/Enemies").has_node(str(enemy)):
					var new_position = lerp(enemies1[enemy]["position"], enemies2[enemy]["position"], interpolation_factor)
					get_node("YSort/Enemies/"+str(enemy)).MoveEnemy(new_position)
					get_node("YSort/Enemies/"+str(enemy)).effects = enemies2[enemy]["effects"]
					if enemies2[enemy].has("dead"):
						get_node("YSort/Enemies/"+str(enemy)).death_stance = enemies2[enemy]["dead"]
				else:
					SpawnNewEnemy(enemy, enemies2[enemy]["position"], enemies2[enemy]["name"])
			RefreshEnemies(world_state_buffer[2]["E"])
			
			#Update objects
			RefreshObjects(world_state_buffer[2]["O"])

		elif render_time > world_state_buffer[1]["T"]:
			var extrapolation_factor = float(render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.00
			
			#Update players
			for player in world_state_buffer[1]["P"].keys():
				var players0 = world_state_buffer[0]["P"]
				var players1 = world_state_buffer[1]["P"]
				
				var current_player = player == str(get_tree().get_network_unique_id())
				var lost_player = not players1.has(player) or not players0.has(player)
				
				if current_player or lost_player:
					continue;
				elif get_node("YSort/OtherPlayers").has_node(str(player)):
					var position_delta = (players1[player]["position"] - players0[player]["position"])
					var new_position = players1[player]["position"] + (position_delta * extrapolation_factor)
					get_node("YSort/OtherPlayers/" + str(player)).MovePlayer(new_position, players1[player]["animation"], players1[player]["sprite"])
					get_node("YSort/OtherPlayers/" + str(player)).UpdateStatusEffects(players1[player]["status_effects"])
				else:
					SpawnNewPlayer(player, players1[player]["position"], players1[player]["sprite"]["C"], players1[player]["name"])
			
			#Update enemies
			for enemy in world_state_buffer[1]["E"].keys():
				var enemies0 = world_state_buffer[0]["E"]
				var enemies1 = world_state_buffer[1]["E"]
				
				var lost_enemy0 = not enemies0.has(enemy)
				var lost_enemy1 = not enemies1.has(enemy)
				
				if lost_enemy0 or lost_enemy1:
					continue;
				elif get_node("YSort/Enemies").has_node(str(enemy)):
					var position_delta = (enemies1[enemy]["position"] - enemies0[enemy]["position"])
					var new_position = enemies1[enemy]["position"] + (position_delta * extrapolation_factor)
					get_node("YSort/Enemies/" + str(enemy)).MoveEnemy(new_position)
				else:
					SpawnNewEnemy(enemy, enemies1[enemy]["position"], enemies1[enemy]["name"])
			
			#Refresh Objects
			RefreshObjects(world_state_buffer[1]["O"])
	
	for i in active_projectiles:
		if get_node("YSort/Pool")[i].visible == true:
			if Server.client_clock - get_node("YSort/Pool")[i].projectile_data["start_time"] < get_node("YSort/Pool")[i].projectile_data["lifespan"]:
				var time_difference =  Server.client_clock - get_node("YSort/Pool")[i].projectile_data["start_time"]
				get_node("YSort/Pool")[i].projectile_data["path"] = get_node("YSort/Pool")[i].projectile_data["speed"] * get_node("YSort/Pool")[i].projectile_data["direction"] * time_difference
				var perpendicular_vector = Vector2(-get_node("YSort/Pool")[i].projectile_data["position"].y, get_node("YSort/Pool")[i].projectile_data["position"].x)
				var perpendicular_move = get_node("YSort/Pool")[i].projectile_data["direction"] * expression.parse(get_node("YSort/Pool")[i],["x"])
				var move = perpendicular_move + get_node("YSort/Pool")[i].projectile_data["path"]
				get_node("YSort/Pool")[i].position = move
				get_node("YSort/Pool")[i].projectile_data["position"] = move
			else:
				get_node("YSort/Pool")[i].visible = false
	
	if clock_sync_timer_2 >= 20:
		var enemies = get_node("YSort/Enemies")
		clock_sync_timer_2 = 0
		for child in enemies.get_children():
			if child.visible == true and not child.is_active and len(world_state_buffer) > 2 and world_state_buffer[2]["E"].has(child.name):
				child.Activate(child.enemy_type)
			elif child.visible == true and not child.is_active:
				child.DeActivate()
			elif child.visible == true and child.is_active and len(world_state_buffer) > 2 and not world_state_buffer[2]["E"].has(child.name):
				child.DeActivate()

func UpdateWorldState(world_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state_buffer.append(world_state)

#Enemy nodes
var living_enemies = []
func SpawnNewEnemy(enemy_id, enemy_position, enemy_name):
	if not living_enemies.has(enemy_id):
		living_enemies.append(enemy_id)
		for child in get_node("YSort/Enemies").get_children():
			if child.is_active == false:
				child.name = enemy_id
				child.position = enemy_position
				child.is_active = true
				child.Activate(enemy_name)
				return
		SpawnNewEnemyLegacy(enemy_id, enemy_position, enemy_name)
func SpawnNewEnemyLegacy(enemy_id, enemy_position, enemy_name):
	if not get_node("YSort/Enemies").has_node(str(enemy_id)):
		var enemy_scene = load("res://Scenes/SupportScenes/Npcs/"+enemy_name+".tscn")
		if not enemy_scene:
			return
		var enemy_instance = enemy_scene.instance()
		enemy_instance.name = enemy_id
		enemy_instance.position = enemy_position
		get_node("YSort/Enemies").add_child(enemy_instance)

func RefreshEnemies(enemies):
	for enemy_id in living_enemies:
		if not enemies.has(enemy_id) and has_node("YSort/Enemies/"+enemy_id):
			living_enemies.erase(enemy_id)
			get_node("YSort/Enemies/"+enemy_id).DeActivate()
 
#Object nodes
func RefreshObjects(objects):
	var expiring_types = [
		"DungeonPortals",
		"LootBags",
		"Buildings",
	]
	
	for object in objects.keys():
		var type = objects[object]["type"]
		var scene_name = objects[object]["name"]+".tscn"
		
		#Loot bags
		if type == "LootBags" and objects[object]["soulbound"] == true and objects[object]["name"] != "storage" and objects[object]["player_id"] != str(Server.get_tree().get_network_unique_id()):
			continue
		
		if not get_node("YSort/Objects/"+type).has_node(str(object)):
			var object_scene = load("res://Scenes/SupportScenes/Objects/"+type+"/"+scene_name)
			var object_instance = object_scene.instance()
			
			if objects[object]["position"] is String:
				var xy = (objects[object]["position"].replace("(","").replace(")","")).split(",")
				objects[object]["position"] = Vector2(int(xy[0]), int(xy[1]))
			
			object_instance.name = str(object)
			object_instance.object_id = str(object)
			object_instance.position = objects[object]["position"]
			
			if type == "DungeonPortals":
				object_instance.portal_name = objects[object]["name"]
				if objects[object]["name"] == "island":
					object_instance.portal_name = objects[object]["ruler"] + "'s_island"
					object_instance.ruler = objects[object]["ruler"]
			if type == "LootBags":
				object_instance.loot = objects[object]["loot"]
			
			get_node("YSort/Objects/"+type).add_child(object_instance)
	for type in expiring_types:
		for object_node in get_node("YSort/Objects/"+type).get_children():
			
			if not objects.has(object_node.name):
				get_node("YSort/Objects/"+type+"/"+object_node.name).queue_free()
			#Loot bags
			elif type == "LootBags":
				object_node.UpdateLoot(objects[object_node.name]["loot"])

#Player nodes
func SpawnNewPlayer(player_id, spawn_position, classname, username):
	if str(get_tree().get_network_unique_id()) == str(player_id):
		pass
	else:
		if not get_node("YSort/OtherPlayers").has_node(str(player_id)):
			var player_instance = player_spawn.instance()
			player_instance.name = str(player_id)
			player_instance.position = spawn_position
			player_instance.get_node("Nametag").Update(player_id, classname, username)
			get_node("YSort/OtherPlayers").add_child(player_instance)
func RefreshPlayers(players):
	for player_node in get_node("YSort/OtherPlayers").get_children():
		if not players.has(player_node.name):
			DespawnPlayer(player_node.name)
func DespawnPlayer(player_id):
	if get_node("YSort/OtherPlayers").has_node(str(player_id)):
		get_node("YSort/OtherPlayers/" + str(player_id)).queue_free()
	yield(get_tree().create_timer(0.2), "timeout")
	if get_node("YSort/OtherPlayers").has_node(str(player_id)):
		get_node("YSort/OtherPlayers/" + str(player_id)).queue_free()
