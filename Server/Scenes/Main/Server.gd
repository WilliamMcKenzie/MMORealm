extends Node

var max_players = 100
var port = 20200
var network = NetworkedMultiplayerENet.new()

var expected_tokens = []

#For rendering the positions/instance to the player
var player_state_collection = {}
var objects_state_collection = {}
var enemies_state_collection = {}

func _ready():
	StartServer()
	CreateIsland("perseus", ["nexus"], Vector2.ZERO)
	CreateObstacle("tree", ["nexus"], Vector2(80, 80), "Small")
func StartServer():
	network.create_server(port, max_players)
	get_tree().network_peer = network
	
	get_tree().connect("network_peer_connected", self, "_Peer_Connected")
	get_tree().connect("network_peer_disconnected", self, "_Peer_Disconnected")
	
func _Peer_Connected(id):
	print("User " + str(id) + " has connected!")
	PlayerVerification.Start(id)
func _Peer_Disconnected(id):
	print("User " + str(id) + " has disconnected!")
	if(get_parent().has_node(str(id))):	
		get_parent().get_node(str(id)).queue_free()
		player_state_collection.erase(id)
		rpc_id(0, "DespawnPlayer", id)

remote func FetchPlayerData(email):
	var player_id = get_tree().get_rpc_sender_id()
	var player_data = get_parent().get_node(str(player_id)).getPlayerData()
	rpc_id(player_id, "ReturnPlayerData", player_data)

#PLAYER SYNCING
remote func FetchServerTime(client_time):
	var player_id =  get_tree().get_rpc_sender_id()
	rpc_id(player_id, "ReturnServerTime", OS.get_system_time_msecs(), client_time)
	
remote func DetermineLatency(client_time):
	var player_id =  get_tree().get_rpc_sender_id()
	rpc_id(player_id, "ReturnLatency", client_time)
	
remote func RecievePlayerState(player_state):
	var player_id = get_tree().get_rpc_sender_id()
	if player_state_collection.has(player_id):
		if(player_state_collection[player_id]["T"] <  player_state["T"]):
			player_state["I"] = player_state_collection[player_id]["I"]
			player_state_collection[player_id] = player_state
			if get_node("Instances/"+StringifyInstanceTree(player_state["I"])+"/YSort/Players").has_node(str(player_id)):
				get_node("Instances/"+StringifyInstanceTree(player_state["I"])+"/YSort/Players/"+str(player_id)).position = player_state["P"]
	else:
		player_state["I"] = ["nexus"]
		player_state_collection[player_id] = player_state
func SendWorldState(world_state):
	rpc_unreliable_id(0, "RecieveWorldState", world_state)

#TOKENS
func _on_TokenExpiration_timeout():
	var current_time = OS.get_unix_time()
	var token_time
	if expected_tokens == []:
		pass
	else:
		for i in range(expected_tokens.size() -1, -1, -1):
			token_time = int(expected_tokens[i].right(64))
			if current_time - token_time >= 30:
				expected_tokens.remove(i)

#Make sure if players manually set tokens to expire say a year from now, they still get kicked
func _on_VerificationExpiration_timeout():
	PlayerVerification.VerificationExpiration()

func FetchToken(player_id):
	rpc_id(player_id, "FetchToken")

remote func ReturnToken(token):
	var player_id = get_tree().get_rpc_sender_id()
	PlayerVerification.Verify(player_id, token)

func ReturnTokenVerificationResults(player_id, result):
	rpc_id(player_id, "ReturnTokenVerificationResults", result)
	if result == true:
		rpc_id(0, "SpawnNewPlayer", player_id, Vector2(79, 56))

#NPCS/ENEMIES
func SpawnNPC(enemy_name, instance_tree, spawn_position):
	var enemy_id = generate_unique_id()
	if get_node("Instances/"+StringifyInstanceTree(instance_tree)):
		var enemy_data = ServerData.GetEnemyData(enemy_name)
		var enemy = {
			"Name":enemy_name,
			"Position":spawn_position,
			"Health":enemy_data.health,
			"MaxHealth":enemy_data.health,
			"Defense":enemy_data.defense,
			"State":"Idle",
			"Exp" : enemy_data.exp
		}
		#Put enemy into whatever instance node it should be put into
		get_node("Instances/"+StringifyInstanceTree(instance_tree)).enemy_list[enemy_id] = enemy
		get_node("Instances/"+StringifyInstanceTree(instance_tree)).SpawnEnemy(enemy_id, spawn_position, 0)
		#enemies_state_collection[enemy_id] = {"T": OS.get_system_time_msecs(), "P": spawn_position, "I": instance_tree, "N":enemy_name}
remote func SendPlayerProjectile(projectile_data):
	var player_id = get_tree().get_rpc_sender_id()
	var instance_tree = player_state_collection[player_id]["I"]
	if get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])).has_method("SpawnProjectile"):
		get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])).SpawnProjectile(projectile_data, player_id)
	rpc_id(0, "ReceivePlayerProjectile", projectile_data, instance_tree, player_id)
func SendEnemyProjectile(projectile_data, enemy_id):
	pass

#INSTANCES
func CreateIsland(instance_name, instance_tree, portal_position):
	var instance_id = instance_name
	if get_node("Instances/"+StringifyInstanceTree(instance_tree)):
		var instance = load("res://Scenes/Instances/Island/Island.tscn").instance()
		instance.name = instance_id
		instance.GenerateIslandMap()
		objects_state_collection[instance_id] = {"T": OS.get_system_time_msecs()+99999999999999, "P": portal_position, "I": instance_tree, "N":"island", "Type":"DungeonPortals"}
		get_node("Instances/"+StringifyInstanceTree(instance_tree)).add_child(instance)
func CreateDungeon(instance_name, instance_tree, portal_position):
	var instance_id = generate_unique_id()
	var instance_map = Dungeons.GenerateDungeon(instance_name)
	if get_node("Instances/"+StringifyInstanceTree(instance_tree)):
		var instance = load("res://Scenes/Instances/Dungeons/Dungeon.tscn").instance()
		instance.name = instance_id
		instance.map = instance_map
		get_node("Instances/"+StringifyInstanceTree(instance_tree)).add_child(instance)
		objects_state_collection[instance_id] = {"T": OS.get_system_time_msecs()+10000, "P": portal_position, "I": instance_tree, "N":instance_name, "Type":"DungeonPortals"}

#OBSTACLES
func CreateObstacle(obstacle_name, instance_tree, obstacle_position, hitbox_size):
	var obstacle_id = generate_unique_id()
	if get_node("Instances/"+StringifyInstanceTree(instance_tree)):
		var obstacle = load("res://Scenes/Instances/Obstacles/"+hitbox_size+".tscn").instance()
		obstacle.name = obstacle_id
		obstacle.position = obstacle_position
		get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Objects/Obstacles").add_child(obstacle)
		objects_state_collection[obstacle_id] = {"T": OS.get_system_time_msecs()+9999999999999, "P": obstacle_position, "I": instance_tree, "N":obstacle_name, "Type":"Obstacles"}

func generate_unique_id():
	var timestamp = OS.get_unix_time()
	var random_value = randi()
	return (str(timestamp) + "_" + str(random_value)).sha256_text()

remote func Nexus():
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "ConfirmNexus")
	var player_container = get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])+"/YSort/Players/"+str(player_id))
	
	get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])+"/YSort/Players").remove_child(player_container)
	get_node("Instances/"+StringifyInstanceTree(["nexus"])+"/YSort/Players").add_child(player_container)
	player_state_collection[player_id] = {"T": OS.get_system_time_msecs(), "P": Vector2.ZERO, "A": "Idle", "I": ["nexus"]}
	
remote func EnterInstance(instance_id):
	var player_id = get_tree().get_rpc_sender_id()
	if get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])).has_node(instance_id):
		var instance_tree = player_state_collection[player_id]["I"].duplicate(true)
		instance_tree.append(str(instance_id))
		
		var player_container = get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])+"/YSort/Players/"+str(player_id))
		#For dungeons
		if not objects_state_collection[instance_id]["N"] == "island":	
			rpc_id(player_id, "ReturnDungeonData", { "Map":get_node("Instances/"+StringifyInstanceTree(instance_tree)).map, "Name":objects_state_collection[instance_id]["N"], "Id":instance_id})
			
			get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])+"/YSort/Players").remove_child(player_container)
			get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players").add_child(player_container)
			player_state_collection[player_id] = {"T": OS.get_system_time_msecs(), "P": Vector2.ZERO, "A": "Idle", "I": instance_tree}
		#For islands (Map is a node instead of array here)
		else:
			var island_node = get_node("Instances/"+StringifyInstanceTree(instance_tree))
			var spawnpoint = island_node.GetMapSpawnpoint()
			
			rpc_id(player_id, "ReturnIslandData", { "Name":objects_state_collection[instance_id]["N"], "Id":instance_id, "P": spawnpoint})

			get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])+"/YSort/Players").remove_child(player_container)
			get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players").add_child(player_container)
			player_state_collection[player_id] = {"T": OS.get_system_time_msecs(), "P": spawnpoint, "A": "Idle", "I": instance_tree}
remote func FetchChunk(chunk):
	var player_id = get_tree().get_rpc_sender_id()
	var instance_tree = player_state_collection[player_id]["I"]
	var instance_node = get_node("Instances/"+StringifyInstanceTree(instance_tree))
	if(instance_node.has_method("GetChunk")):
		rpc_id(player_id, "ReturnChunk", instance_node.GetChunk(chunk), chunk)
remote func FetchChunkData(chunk):
	var player_id = get_tree().get_rpc_sender_id()
	var instance_tree = player_state_collection[player_id]["I"]
	var instance_node = get_node("Instances/"+StringifyInstanceTree(instance_tree))
	if(instance_node.has_method("GetChunkData")):
		rpc_id(player_id, "ReturnChunkData", instance_node.GetChunkData(chunk), chunk)
remote func FetchIslandEnemies(chunk):
	var player_id = get_tree().get_rpc_sender_id()
	var instance_tree = player_state_collection[player_id]["I"]
	var island_node = get_node("Instances/"+StringifyInstanceTree(instance_tree))
	if(island_node.has_method("GetIslandEnemies")):
		rpc_id(player_id, "ReturnIslandEnemies", island_node.GetIslandEnemies(chunk), chunk)
func StringifyInstanceTree(instance_tree):
	var res = ""
	for instance in instance_tree:
		res += (instance+"/")
	return res.left(res.length() - 1) 

#COMMANDS
remote func RecieveChatMessage(message):
	var message_words = message.split(" ")
	var player_id = get_tree().get_rpc_sender_id()
	var player_position = player_state_collection[player_id]["P"]
	var instance_tree = player_state_collection[player_id]["I"]
	
	if message[0] == "/":
		if message_words[0] == "/tp":
			var selected_player_id = int(message.substr(4,-1))
			if player_state_collection.has(selected_player_id) and player_state_collection[selected_player_id]["I"] == player_state_collection[player_id]["I"]:
				player_state_collection[player_id]["P"] = player_state_collection[selected_player_id]["P"]
				rpc_id(player_id, "MovePlayer", player_state_collection[player_id]["P"])
				rpc_id(player_id, "RecieveChat", "You have teleported to " + message.substr(4,-1), "System")
			else:
				rpc_id(player_id, "RecieveChat", "Invalid player ID: " + message.substr(4,-1), "System")
		if message_words[0] == "/d":
			CreateDungeon(message.substr(3,-1), instance_tree, player_position)
			rpc_id(player_id, "RecieveChat", "You have opened a " + message.substr(3,-1), "System")
		if message_words[0] == "/spawn":
			SpawnNPC(message.substr(7,-1), instance_tree, player_position)
			rpc_id(player_id, "RecieveChat", "You have spawned a " + message.substr(7,-1), "System")
	else:
		print("server has recieved message : " + message)
		rpc("RecieveChat", message,str(get_tree().get_rpc_sender_id()))

func SetHealth(player_id, max_health,health):
	rpc_id(player_id,"SetHealth",max_health,health)
