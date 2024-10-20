extends YSort

var player_spawn = preload("res://Scenes/SupportScenes/PlayerCharacter/PlayerTemplate.tscn")
var last_world_state = 0

var world_state_buffer = []
var expression = Expression.new()

var clock_sync_timer_2 = 0
func _ready():
	var pool = get_node_or_null("PlayerPool")
	if not pool:
		Server.CreatePool(Server.projectile_pool_amount)

func _physics_process(delta):
	clock_sync_timer_2 += 1
	if not has_node("YSort") or GameUI.is_dead:
		return
	
	var render_time = Server.client_clock - Settings.interpolation_offset
	var other_players_node = get_node("YSort/OtherPlayers")
	var enemies_node = get_node("YSort/Enemies")
	
	if world_state_buffer.size() > 1:
		while(world_state_buffer.size() > 2 and render_time > world_state_buffer[2].T):
			world_state_buffer.remove(0)
		
		if world_state_buffer.size() > 2:
			RefreshPlayers(world_state_buffer[2]["P"])
			RefreshObjects(world_state_buffer[2]["O"])
			
			var t1 = world_state_buffer[1]["T"]
			var t2 = world_state_buffer[2]["T"]
			var interpolation_factor = float(render_time - t1) / max(float(t2 - t1), 1)
			var lost = 0
			
			for player_id in world_state_buffer[2]["P"].keys():
				var players1 = world_state_buffer[1]["P"]
				var players2 = world_state_buffer[2]["P"]
				
				var player_data1 = players1[player_id] if players1.has(player_id) else null
				var player_data2 = players2[player_id] if players2.has(player_id) else null
				
				var current_player = player_id == str(get_tree().get_network_unique_id())
				var other_player = other_players_node.get_node_or_null(str(player_id))
				
				if current_player or not player_data1 or not player_data2:
					continue;
				elif other_player:
					var new_position = lerp(player_data1["position"], player_data2["position"], interpolation_factor)
					other_player.MovePlayer(new_position, player_data2["animation"], player_data2["sprite"])
					other_player.UpdateStatusEffects(player_data2["status_effects"])
				else:
					SpawnNewPlayer(player_id, player_data2["position"], player_data2["sprite"]["C"], player_data2["name"])
			
			for enemy_id in world_state_buffer[2]["E"].keys():
				var enemies1 = world_state_buffer[1]["E"]
				var enemies2 = world_state_buffer[2]["E"]
				
				var enemy_data1 = enemies1[enemy_id] if enemies1.has(enemy_id) else null
				var enemy_data2 = enemies2[enemy_id]if enemies2.has(enemy_id) else null
				var enemy = enemies_node.get_node_or_null(str(enemy_id))
				
				if not enemy_data1 or not enemy_data2:
					pass
				elif enemy:
					var new_position = lerp(enemy_data1["position"], enemy_data2["position"], interpolation_factor)
					
					#Update position
					if enemy.theoretical_position != new_position:
						var flip = enemy_data1["flip"] if enemy_data1.has("flip") else -1
						enemy.MoveEnemy(new_position, flip)
					
					#Update everything else
					enemy.effects = enemy_data2["effects"]
					if enemy_data2.has("dead"):
						enemy.death_stance = enemy_data2["dead"]
				elif not dead_enemies.has(enemy_id):
					SpawnNewEnemy(enemy_id, enemy_data2["position"], enemy_data2["name"])
		
		elif render_time > world_state_buffer[1]["T"]:
			var t1 = world_state_buffer[0]["T"]
			var t2 = world_state_buffer[1]["T"]
			var extrapolation_factor = float(render_time - t1) / max(float(t2 - t1), 1) - 1.00
			
			#Update players
			for player in world_state_buffer[1]["P"].keys():
				var players0 = world_state_buffer[0]["P"]
				var players1 = world_state_buffer[1]["P"]
				
				var current_player = player == str(get_tree().get_network_unique_id())
				var lost_player = not players1.has(player) or not players0.has(player) or not players1[player] or not players0[player]
				
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
					var flip = enemies1[enemy]["flip"] if enemies1[enemy].has("flip") else -1
					get_node("YSort/Enemies/" + str(enemy)).MoveEnemy(new_position, flip)
				elif not dead_enemies.has(enemy):
					SpawnNewEnemy(enemy, enemies1[enemy]["position"], enemies1[enemy]["name"])
	if clock_sync_timer_2 >= 20 and len(world_state_buffer) > 2:
		var enemies = get_node("YSort/Enemies")
		clock_sync_timer_2 = 0
		var i = 0
		for child in enemies.get_children():
			var is_visible = child.visible
			var is_active = child.is_active
			var exists = world_state_buffer[2]["E"].has(child.name)
			if is_active:
				i += 1
			
			if dead_enemies.has(child.name):
				child.DeActivate()
			elif is_visible and not is_active and len(world_state_buffer) > 2 and exists:
				child.Activate(child.enemy_type)
			elif is_visible and not is_active and not exists:
				child.DeActivate()
			elif is_active and not is_visible and not exists:
				child.DeActivate()
			elif (is_visible or is_active) and len(world_state_buffer) > 2 and not exists:
				child.DeActivate()
func UpdateWorldState(world_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state["T"] = Server.client_clock
		world_state_buffer.append(world_state)

#Enemy nodes
var enemy_scene = preload("res://Scenes/SupportScenes/Npcs/BasicEnemy.tscn")
var dead_enemies = {}
var living_enemies = []
func SpawnNewEnemy(enemy_id, enemy_position, enemy_name):
	for child in get_node("YSort/Enemies").get_children():
		if child.is_active == false:
			child.name = enemy_id
			child.position = enemy_position
			child.is_active = true
			child.Activate(enemy_name)
			return
	CreateEnemy(30)
	SpawnNewEnemy(enemy_id, enemy_position, enemy_name)

func CreateEnemy(amount):
	for i in range(amount):
		var child = enemy_scene.instance()
		child.name = str(i)
		get_node("YSort/Enemies").add_child(child)

#Object nodes
func RefreshObjects(objects):
	var expiring_types = [
		"DungeonPortals",
		"LootBags",
		"Buildings",
	]
	
	for object in objects.keys():
		var object_data = objects[object]
		var type = object_data["type"]
		var scene_name = object_data["name"]+".tscn"
		
		#Loot bags
		if type == "LootBags" and object_data["soulbound"] == true and not object_data.has("permanent") and object_data["player_id"] != str(Server.get_tree().get_network_unique_id()):
			continue
		if not get_node("YSort/Objects/"+type).has_node(str(object)):
			var object_scene = load("res://Scenes/SupportScenes/Objects/"+type+"/"+scene_name)
			var object_instance = object_scene.instance()
			
			if object_data["position"] is String:
				var xy = (object_data["position"].replace("(","").replace(")","")).split(",")
				object_data["position"] = Vector2(int(xy[0]), int(xy[1]))
			
			object_instance.name = str(object)
			object_instance.object_id = str(object)
			object_instance.position = object_data["position"]
			
			if type == "DungeonPortals":
				object_instance.portal_name = object_data["name"]
				if object_data["name"] == "island" and object_data["ruler"]:
					object_instance.portal_name = object_data["ruler"] + "'s_kingdom"
					object_instance.ruler = object_data["ruler"]
				elif object_data["name"] == "island":
					object_instance.portal_name = "training_kingdom"
					object_instance.ruler = null
			if type == "LootBags":
				object_instance.loot = object_data["loot"]
			
			get_node("YSort/Objects/"+type).add_child(object_instance)
	for type in expiring_types:
		var objects_node = get_node("YSort/Objects/"+type)
		for object_node in objects_node.get_children():
			
			if not objects.has(object_node.name):
				objects_node.get_node(object_node.name).queue_free()
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
