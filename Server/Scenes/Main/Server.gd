extends Node

var max_players = 100
var port = 20200
var network = NetworkedMultiplayerENet.new()

var expected_tokens = {}

#We need to make each instance have a unique posiition and not intersect with one another
var instance_positions = { Vector2.ZERO : true }
#List of all the current instances with their current connected player ids
#Keys are the instance trees
#Values are the player ids in a list
var player_instance_tracker = {["nexus"] : []}

#Keep track of players instance
#Keys are player ids
#Values are instance trees, position, animation and last updated time-
#-in this format: { "T" : {time}, "I" : {index_tree}, "P" : {position}, "A" : {animationstate}}
var player_state_collection = {}

func _ready():
	StartServer()
	
	#Open realm
	get_node("Instances/"+StringifyInstanceTree(["nexus"])).OpenPortal("island", ["nexus"], Vector2.ZERO)
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
	if player_instance_tracker[player_state_collection[id]["I"]].has(id):
		var instance_tree = player_state_collection[id]["I"]
		var player_container = get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(id))
		get_node("Instances/"+StringifyInstanceTree(player_state_collection[id]["I"])).RemovePlayer(player_container)
		player_instance_tracker[player_state_collection[id]["I"]].erase(id)
	player_state_collection.erase(id)
	rpc_id(0, "DespawnPlayer", id)

#INVENTORY/ITEMS
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
				get_node("Instances/"+StringifyInstanceTree(player_state["I"])).UpdatePlayer(player_id, player_state)
	else:
		player_instance_tracker[["nexus"]].append(player_id)
		player_state["I"] = ["nexus"]
		player_state_collection[player_id] = player_state
func SendWorldState(id, world_state):
	rpc_unreliable_id(int(id), "RecieveWorldState", world_state)

#TOKENS
func _on_TokenExpiration_timeout():
	var current_time = OS.get_unix_time()
	var token_time
	if expected_tokens == {}:
		pass
	else:
		for i in range(expected_tokens.keys().size() -1, -1, -1):
			token_time = int(expected_tokens.keys()[i].right(64))
			if current_time - token_time >= 30:
				expected_tokens.keys().remove(i)

#Make sure if players manually set tokens to expire say a year from now, they still get kicked
func _on_VerificationExpiration_timeout():
	PlayerVerification.VerificationExpiration()

func FetchToken(player_id):
	rpc_id(player_id, "FetchToken")

remote func ReturnToken(token, character_index):
	var player_id = get_tree().get_rpc_sender_id()
	PlayerVerification.Verify(player_id, token, character_index)

func ReturnTokenVerificationResults(player_id, result):
	rpc_id(player_id, "ReturnTokenVerificationResults", result)
	if result == true:
		rpc_id(0, "SpawnNewPlayer", player_id, Vector2(79, 56))

#CHARACTERS
func SendCharacterData(player_id, character):
	rpc_id(int(player_id), "RecieveCharacterData", character)

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
			"Behavior":enemy_data.behavior,
			"Exp" : enemy_data.exp
		}
		get_node("Instances/"+StringifyInstanceTree(instance_tree)).SpawnEnemy(enemy, enemy_id)

remote func SendPlayerProjectile(projectile_data):
	var player_id = get_tree().get_rpc_sender_id()
	var instance_tree = player_state_collection[player_id]["I"]
	if get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])).has_method("SpawnPlayerProjectile"):
		get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])).SpawnPlayerProjectile(projectile_data, player_id)
	rpc_id(0, "ReceivePlayerProjectile", projectile_data, instance_tree, player_id)
	
func SendEnemyProjectile(projectile_data, instance_tree, enemy_id, position_offset):
	var data_to_send = projectile_data.duplicate(true)
	data_to_send["Position"] = data_to_send["Position"] - position_offset
	data_to_send["TargetPosition"] = data_to_send["TargetPosition"] - position_offset
	rpc("RecieveEnemyProjectile", data_to_send, instance_tree, enemy_id)

func generate_unique_id():
	var timestamp = OS.get_unix_time()
	var random_value = randi()
	return (str(timestamp) + "_" + str(random_value)).sha256_text()

remote func Nexus():
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "ConfirmNexus")
	var player_container = get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])+"/YSort/Players/"+str(player_id))
	var instance_tree = player_state_collection[player_id]["I"].duplicate(true)
	
	player_instance_tracker[instance_tree].erase(player_id)
	player_instance_tracker[["nexus"]].append(player_id)
	get_node("Instances/"+StringifyInstanceTree(instance_tree)).RemovePlayer(player_container)
	get_node("Instances/"+StringifyInstanceTree(["nexus"])).SpawnPlayer(player_container)
	
	player_state_collection[player_id] = {"T": OS.get_system_time_msecs(), "P": Vector2.ZERO, "A": "Idle", "I": ["nexus"]}
	
remote func EnterInstance(instance_id):
	var player_id = get_tree().get_rpc_sender_id()
	var current_instance_node = get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"]))
	
	if current_instance_node.has_node(instance_id):
		var instance_tree = player_state_collection[player_id]["I"].duplicate(true)
		var player_container = get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id))
		
		player_instance_tracker[instance_tree].erase(player_id)
		instance_tree.append(str(instance_id))
		
		#For dungeons
		if not current_instance_node.object_list[instance_id]["Name"] == "island":	
			rpc_id(player_id, "ReturnDungeonData", { "Map": get_node("Instances/"+StringifyInstanceTree(instance_tree)).map, "Name": current_instance_node.object_list[instance_id]["Name"], "Id": instance_id})
			
			get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])).RemovePlayer(player_container)
			get_node("Instances/"+StringifyInstanceTree(instance_tree)).SpawnPlayer(player_container)
			player_state_collection[player_id] = {"T": OS.get_system_time_msecs(), "P": Vector2.ZERO, "A": { "A" : "Idle", "C" : Vector2.ZERO }, "I": instance_tree}
			player_instance_tracker[instance_tree].append(player_id)
		#For islands (Map is a node instead of array here)
		else:
			var island_node = get_node("Instances/"+StringifyInstanceTree(instance_tree))
			var spawnpoint = island_node.GetMapSpawnpoint()
			
			rpc_id(player_id, "ReturnIslandData", { "Name": current_instance_node.object_list[instance_id]["Name"], "Id":instance_id, "Position": spawnpoint})
			get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])).RemovePlayer(player_container)
			get_node("Instances/"+StringifyInstanceTree(instance_tree)).SpawnPlayer(player_container)
			
			player_state_collection[player_id] = {"T": OS.get_system_time_msecs(), "P": spawnpoint, "A": "Idle", "I": instance_tree}
			player_instance_tracker[instance_tree].append(player_id)
remote func FetchIslandChunk(chunk):
	var player_id = get_tree().get_rpc_sender_id()
	var instance_tree = player_state_collection[player_id]["I"]
	var island_node = get_node("Instances/"+StringifyInstanceTree(instance_tree))
	if(island_node.has_method("GetIslandChunk")):
		rpc_id(player_id, "ReturnIslandChunk", island_node.GetIslandChunk(chunk), chunk)
func StringifyInstanceTree(instance_tree):
	var res = ""
	for instance in instance_tree:
		res += (str(instance)+"/")
	return res.left(res.length() - 1) 

#COMMANDS
remote func RecieveChatMessage(message):
	var message_words = message.split(" ")
	var player_id = get_tree().get_rpc_sender_id()
	var player_position = player_state_collection[player_id]["P"]
	var instance_tree = player_state_collection[player_id]["I"]
	if len(message) >= 1:
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
				if message.substr(3,-1) in Dungeons.valid_names:
					get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])).OpenPortal(message.substr(3,-1), instance_tree, player_position)
					rpc_id(player_id, "RecieveChat", "You have opened a " + message.substr(3,-1), "System")
				else:
					rpc_id(player_id, "RecieveChat", "Error spawning dungeon", "System")
			if message_words[0] == "/spawn" and message_words.size() > 1:
				var valid_enemy = message_words[1] in ServerData.enemy_data
				var multiple_enemies = message_words.size() > 2 and int(message_words[2])
				
				if valid_enemy and multiple_enemies:
					for i in range(int(message_words[2])):
						SpawnNPC(message_words[1], instance_tree, player_position)
				elif valid_enemy:
					SpawnNPC(message_words[1], instance_tree, player_position)
					rpc_id(player_id, "RecieveChat", "You have spawned a " + message.substr(7,-1), "System")
				else:
					rpc_id(player_id, "RecieveChat", "Error spawning NPC", "System")
		else:
			print("server has recieved message : " + message)
			rpc("RecieveChat", message,str(get_tree().get_rpc_sender_id()))

#PLAYER INTERACTION

func NotifyDeath(player_id, enemy_name):
	rpc_id(player_id, "CharacterDied", enemy_name)
	rpc("RecieveChat", str(player_id) + " has been killed!", "System")

func SetHealth(player_id, max_health, health):
	rpc_id(player_id,"SetHealth",max_health, health)
