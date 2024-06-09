extends Node2D

var player_spawn = preload("res://Scenes/SupportScenes/PlayerCharacter/PlayerTemplate.tscn")
var last_world_state = 0

var world_state_buffer = []
const interpolation_offset = 100

func _physics_process(delta):
	var render_time = Server.client_clock - interpolation_offset
	if world_state_buffer.size() > 1:
		
		#Remove excess worldstates, leaving only usable ones
		while(world_state_buffer.size() > 2 and render_time > world_state_buffer[2].T):
			world_state_buffer.remove(0)
		
		#Loop through and update specific world elements
		if world_state_buffer.size() > 2:
			var interpolation_factor = float(render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[1]["T"])
			
			#Update players
			for player in world_state_buffer[2]["P"].keys():
				var players1 = world_state_buffer[1]["P"]
				var players2 = world_state_buffer[2]["P"]
				
				var current_player = player == str(get_tree().get_network_unique_id())
				var lost_player = not players1.has(player)
				
				if current_player or lost_player:
					continue;
				elif get_node("YSort/OtherPlayers").has_node(str(player)):
					var new_position = lerp(players1[player]["Position"], players2[player]["Position"], interpolation_factor)
					get_node("YSort/OtherPlayers/" + str(player)).MovePlayer(new_position, players2[player]["Animation"])
				else:
					SpawnNewPlayer(player, players2[player]["Position"])
			RefreshPlayers(world_state_buffer[2]["P"])
			
			#Update enemies
			for enemy in world_state_buffer[2]["E"].keys():
				var enemies1 = world_state_buffer[1]["E"]
				var enemies2 = world_state_buffer[2]["E"]
				
				var lost_enemy1 = not enemies2.has(enemy)
				var lost_enemy2 = not enemies1.has(enemy)
				
				if lost_enemy1 or lost_enemy2:
					continue
				elif get_node("YSort/Enemies").has_node(str(enemy)):
					var new_position = lerp(enemies1[enemy]["Position"], enemies2[enemy]["Position"], interpolation_factor)
					get_node("YSort/Enemies/"+str(enemy)).MoveEnemy(new_position)
				else:
					SpawnNewEnemy(enemy, enemies2[enemy]["Position"], enemies2[enemy]["Name"])
			RefreshEnemies(world_state_buffer[2]["E"])
			
			#Update objects
			RefreshObjects(world_state_buffer[2]["O"])
			
		elif render_time > world_state_buffer[1]["T"]:
			var extrapolation_factor = float(render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.00
			for player in world_state_buffer[1]["P"].keys():
				var players0 = world_state_buffer[0]["P"]
				var players1 = world_state_buffer[1]["P"]
				
				var current_player = player == str(get_tree().get_network_unique_id())
				var lost_player = not players1.has(player) or not players0.has(player)
				
				if current_player or lost_player:
					continue;
				elif get_node("YSort/OtherPlayers").has_node(str(player)):
					var position_delta = (players1[player]["Position"] - players0[player]["Position"])
					var new_position = players1[player]["Position"] + (position_delta * extrapolation_factor)
					get_node("YSort/OtherPlayers/" + str(player)).MovePlayer(new_position, players1[player]["Animation"])
				else:
					SpawnNewPlayer(player, players1[player]["Position"])

func UpdateWorldState(world_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state_buffer.append(world_state)

#Enemy nodes
func SpawnNewEnemy(enemy_id, enemy_position, enemy_name):
	if not get_node("YSort/Enemies").has_node(str(enemy_id)):
		var enemy_scene = load("res://Scenes/SupportScenes/Npcs/"+enemy_name+".tscn")
		var enemy_instance = enemy_scene.instance()
		enemy_instance.name = enemy_id
		enemy_instance.position = enemy_position
		get_node("YSort/Enemies").add_child(enemy_instance)
func RefreshEnemies(enemies):
	for enemy_node in get_node("YSort/Enemies").get_children():
		if not enemies.has(enemy_node.name):
			get_node("YSort/Enemies/"+enemy_node.name).queue_free()

#Object nodes
func RefreshObjects(objects):
	var expiring_types = [
		"DungeonPortals",
	]
	
	for object in objects.keys():
		var type = objects[object]["Type"]
		var scene_name = objects[object]["Name"]+".tscn"
		
		if not get_node("YSort/Objects/"+type).has_node(str(object)):
			var object_scene = load("res://Scenes/SupportScenes/Objects/"+type+"/"+scene_name)
			var object_instance = object_scene.instance()
			object_instance.name = str(object)
			object_instance.object_id = str(object)
			object_instance.position = objects[object]["Position"]
			get_node("YSort/Objects/"+type).add_child(object_instance)
	for type in expiring_types:
		for object_node in get_node("YSort/Objects/"+type).get_children():
			if not objects.has(object_node.name):
				get_node("YSort/Objects/"+type+"/"+object_node.name).queue_free()

#Player nodes
func SpawnNewPlayer(player_id, spawn_position):
	if str(get_tree().get_network_unique_id()) == str(player_id):
		pass
	else:
		if not get_node("YSort/OtherPlayers").has_node(str(player_id)):
			var player_instance = player_spawn.instance()
			player_instance.name = str(player_id)
			player_instance.position = spawn_position
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

#For creating new dungeon instances
func PopulateDungeon(instance_data):
	var map = instance_data["Map"]
	var dungeon_name = instance_data["Name"]
	var id = instance_data["Id"]
	
	var room_nodes = {}
	
	for path in map:
		for room in path:
			room_nodes[room] = load("res://Scenes/SupportScenes/Dungeons/"+dungeon_name+"/"+room+".tscn")
	
	var direction_map = {
		0 : Vector2(0, 1),
		1 : Vector2(1, 0),
		2 : Vector2(0, -1),
		3 : Vector2(-1, 0)
	}
	for i in range(map.size()):
		for k in range(map[i].size()):
			var room_to_add = room_nodes[map[i][k]].instance()
			room_to_add.position = direction_map[i]*k*(15)*8
			add_child(room_to_add)
