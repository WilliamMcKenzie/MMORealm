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

#Keep trak of usernames for easy access
var player_name_by_id = {}
var player_id_by_name = {}

func _ready():
	StartServer()
	
	#Open realm
	#for i in range(100):
		#PlayerVerification.CreateFakePlayerContainer()
		
	SpawnNPC("crab", ["nexus"], Vector2.ZERO)
	get_node("Instances/"+StringifyInstanceTree(["nexus"])).OpenPortal("island", ["nexus"], Vector2.ZERO)
	get_node("Instances/"+StringifyInstanceTree(["nexus"])).OpenPortal("overgrown_temple", ["nexus"], Vector2(20,20))
	
	get_node("Instances/"+StringifyInstanceTree(["nexus"])).SpawnLootBag([ 
			{
				"item" : 1,
				"id" : generate_unique_id()
			}], null, ["nexus"], Vector2(50, 50))
	
	get_node("Instances/"+StringifyInstanceTree(["nexus"])).SpawnLootBag([ 
			{
				"item" : 2,
				"id" : generate_unique_id()
			}], null, ["nexus"], Vector2(80, 50))
	
	get_node("Instances/"+StringifyInstanceTree(["nexus"])).SpawnLootBag([ 
			{
				"item" : 4,
				"id" : generate_unique_id()
			}], null, ["nexus"], Vector2(120, 50))
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
	if player_instance_tracker[player_state_collection[id]["I"]].has(id) and get_node("Instances/"+StringifyInstanceTree(player_state_collection[id]["I"])+"/YSort/Players/"+str(id)):
		var instance_tree = player_state_collection[id]["I"]
		var player_container = get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(id))
		
		PlayerVerification.verified_emails.erase(player_container.email)
		HubConnection.UpdateAccountData(player_container.email, player_container.account_data)
		get_node("Instances/"+StringifyInstanceTree(player_state_collection[id]["I"])).RemovePlayer(player_container)
		player_instance_tracker[player_state_collection[id]["I"]].erase(id)
		player_state_collection.erase(id)
		rpc_id(0, "DespawnPlayer", id)

#INVENTORY/ITEMS	
remote func FetchPlayerData(email):
	var player_id = get_tree().get_rpc_sender_id()
	var player_data = get_parent().get_node(str(player_id)).getPlayerData()
	rpc_id(player_id, "ReturnPlayerData", player_data)

remote func UseItem(index):
	var player_id = get_tree().get_rpc_sender_id()
	var instance_tree = player_state_collection[player_id]["I"]
	var player_data = get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id)).UseItem(index)

remote func EquipItem(index):
	var player_id = get_tree().get_rpc_sender_id()
	var instance_tree = player_state_collection[player_id]["I"]
	var player_data = get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id)).EquipItem(index)

remote func ChangeItem(to_data, from_data):
	var player_id = get_tree().get_rpc_sender_id()
	var instance_tree = player_state_collection[player_id]["I"]
	
	if to_data.parent.split(" ")[0] == "loot" or from_data.parent.split(" ")[0] == "loot":
		get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id)).LootItem(to_data, from_data)
	else:
		get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id)).ChangeItem(to_data, from_data)
		
remote func DropItem(data):
	var player_id = get_tree().get_rpc_sender_id()
	var instance_tree = player_state_collection[player_id]["I"]
	get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id)).DropItem(data)

remote func IncreaseStat(stat):
	var player_id = get_tree().get_rpc_sender_id()
	var instance_tree = player_state_collection[player_id]["I"]
	get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id)).IncreaseStat(stat)

remote func UseAbility():
	var player_id = get_tree().get_rpc_sender_id()
	var instance_tree = player_state_collection[player_id]["I"]
	get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id)).UseAbility()
	
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
func SendAccountData(player_id, account_data):
	rpc_id(int(player_id), "RecieveAccountData", account_data)

#NPCS/ENEMIES
func SpawnNPC(enemy_name, instance_tree, spawn_position):
	var enemy_id = generate_unique_id()
	
	if get_node("Instances/"+StringifyInstanceTree(instance_tree)):
		var enemy_data = ServerData.GetEnemy(enemy_name)
		var enemy = {
			"name":enemy_name,
			"position":spawn_position + get_node("Instances/"+StringifyInstanceTree(instance_tree)).position,
			"health":enemy_data.health,
			"max_health":enemy_data.health,
			"defense":enemy_data.defense,
			"state":"Idle",
			"behavior":enemy_data.behavior,
			"exp": enemy_data.exp,
			"damage_tracker": {},
			"target": spawn_position + get_node("Instances/"+StringifyInstanceTree(instance_tree)).position,
			"anchor_position": spawn_position + get_node("Instances/"+StringifyInstanceTree(instance_tree)).position,
			"pattern_index" : 0,
			"timer" : 0
		}
		get_node("Instances/"+StringifyInstanceTree(instance_tree)).SpawnEnemy(enemy, enemy_id)

remote func SendPlayerProjectile(projectile_data):
	var player_id = get_tree().get_rpc_sender_id()
	var instance_tree = player_state_collection[player_id]["I"]
	rpc_id(0, "ReceivePlayerProjectile", projectile_data, instance_tree, player_id)
	
func SendEnemyProjectile(projectile_data, instance_tree, enemy_id):
	rpc("RecieveEnemyProjectile", projectile_data, instance_tree, enemy_id)

remote func NPCHit(enemy_id, damage):
	var player_id = get_tree().get_rpc_sender_id()
	var instance_tree = player_state_collection[player_id]["I"]
	
	var player_container = get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id))
	var which_achievement = "bow_projectiles"
	
	if player_container.gear.has("weapon"):
		var weapon_type = player_container.gear.weapon.type
		if weapon_type == "Staff":
			which_achievement = "staff_projectiles"
		if weapon_type == "Sword":
			which_achievement = "sword_projectiles"

	if get_node("Instances/" + StringifyInstanceTree(instance_tree)).enemy_list.has(str(enemy_id)):
		var enemy_container = get_node("Instances/" + StringifyInstanceTree(instance_tree)).enemy_list[str(enemy_id)]
		var total_damage = floor(damage - ServerData.GetEnemy(enemy_container.name).defense)
		if total_damage < damage - damage*0.9:
			total_damage = floor(damage - damage*0.9)
		
		enemy_container["health"] -= total_damage
		var damage_tracker = get_node("Instances/" + StringifyInstanceTree(instance_tree)).enemy_list[str(enemy_id)]["damage_tracker"]
		
		if damage_tracker.has(str(player_id)):
			damage_tracker[str(player_id)] = total_damage + damage_tracker[str(player_id)]
		else:
			damage_tracker[str(player_id)] = total_damage
		
		player_container.UpdateStatistics("projectiles_landed", 1)
		player_container.UpdateStatistics(which_achievement, 1)

#INSTANCES
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
		if not current_instance_node.object_list[instance_id]["name"] == "island":	
			var dungeon_node = get_node("Instances/"+StringifyInstanceTree(instance_tree))
			var spawnpoint = dungeon_node.GetMapSpawnpoint()
			
			rpc_id(player_id, "ReturnDungeonData", { "Map": dungeon_node.map, "Name": current_instance_node.object_list[instance_id]["name"], "Id": instance_id, "RoomSize" : dungeon_node.room_size, "Position": spawnpoint})
			get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])).RemovePlayer(player_container)
			get_node("Instances/"+StringifyInstanceTree(instance_tree)).SpawnPlayer(player_container)
			
			player_state_collection[player_id] = {"T": OS.get_system_time_msecs(), "P": spawnpoint, "A": { "A" : "Idle", "C" : Vector2.ZERO }, "I": instance_tree}
			player_instance_tracker[instance_tree].append(player_id)
		#For islands (Map is a node instead of array here)
		else:
			var island_node = get_node("Instances/"+StringifyInstanceTree(instance_tree))
			var spawnpoint = island_node.GetMapSpawnpoint()
			
			rpc_id(player_id, "ReturnIslandData", { "Name": current_instance_node.object_list[instance_id]["name"], "Id":instance_id, "Position": spawnpoint})
			get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])).RemovePlayer(player_container)
			get_node("Instances/"+StringifyInstanceTree(instance_tree)).SpawnPlayer(player_container)
			
			player_state_collection[player_id] = {"T": OS.get_system_time_msecs(), "P": spawnpoint, "A": "Idle", "I": instance_tree}
			player_instance_tracker[instance_tree].append(player_id)
		SendCharacterData(player_id, player_container.character)
		
remote func FetchIslandChunk(chunk):
	var player_id = get_tree().get_rpc_sender_id()
	var instance_tree = player_state_collection[player_id]["I"]
	var island_node = get_node("Instances/"+StringifyInstanceTree(instance_tree))
	if(island_node.has_method("GetIslandChunk")):
		rpc_id(player_id, "ReturnIslandChunk", island_node.GetIslandChunk(chunk), chunk)

#COMMANDS
func SendMessage(player_id, type, message):
	if type == "warning":
		rpc_id(player_id, "RecieveChat", message, "SystemWARN")
	if type == "error":
		rpc_id(player_id, "RecieveChat", message, "SystemERROR")
	if type == "success":
		rpc_id(player_id, "RecieveChat", message, "SystemSUCCESS")

remote func RecieveChatMessage(message):
	var message_words = message.split(" ")
	var player_id = get_tree().get_rpc_sender_id()
	var player_name = player_name_by_id[player_id]
	var player_position = player_state_collection[player_id]["P"]
	var instance_tree = player_state_collection[player_id]["I"]
	var player_container = get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id))
	
	if len(message) >= 1:
		if message[0] == "/":
			if message_words[0] == "/tp":
				var selected_player_name = message.substr(4,-1)
				if player_id_by_name.has(selected_player_name):
					var selected_player_id =  player_id_by_name[message.substr(4,-1)]
					if player_state_collection.has(selected_player_id) and player_state_collection[selected_player_id]["I"] == player_state_collection[player_id]["I"]:
						player_state_collection[player_id]["P"] = player_state_collection[selected_player_id]["P"]
						rpc_id(player_id, "MovePlayer", player_state_collection[player_id]["P"])
						rpc_id(player_id, "RecieveChat", "You have teleported to " + selected_player_name, "System")
					else:
						rpc_id(player_id, "RecieveChat", "Invalid username: " + message.substr(4,-1), "System")
				else:
					rpc_id(player_id, "RecieveChat", "Invalid username: " + message.substr(4,-1), "SystemERROR")
			if message_words[0] == "/d":
				if message.substr(3,-1) in Dungeons.valid_names:
					get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])).OpenPortal(message.substr(3,-1), instance_tree, player_position)
					rpc_id(player_id, "RecieveChat", "You have opened a " + message.substr(3,-1), "System")
				else:
					rpc_id(player_id, "RecieveChat", "Error spawning dungeon", "SystemERROR")
			if message_words[0] == "/spawn" and message_words.size() > 1:
				var valid_enemy = message_words[1] in ServerData.enemies
				var multiple_enemies = message_words.size() > 2 and int(message_words[2])
				
				if valid_enemy and multiple_enemies:
					for _i in range(int(message_words[2])):
						SpawnNPC(message_words[1], instance_tree, player_position - (get_node("Instances/"+StringifyInstanceTree(instance_tree)).position))
					rpc_id(player_id, "RecieveChat", "You have spawned " + message_words[2] + message.substr(7,-1) + "s", "System")
				elif valid_enemy:
					SpawnNPC(message_words[1], instance_tree, player_position - (get_node("Instances/"+StringifyInstanceTree(instance_tree)).position))
					rpc_id(player_id, "RecieveChat", "You have spawned a " + message.substr(7,-1), "System")
				else:
					rpc_id(player_id, "RecieveChat", "Error spawning NPC", "SystemERROR")
			if message_words[0] == "/loot" and message_words.size() == 2:
				var valid = int(message_words[1]) in ServerData.items
				var item = ServerData.GetItem(int(message_words[1]))
				
				if valid and (item.tier == "UT" or int(item.tier) > 1):
					get_node("Instances/"+StringifyInstanceTree(instance_tree)).SpawnLootBag([ 
					{
						"item" : int(message_words[1]),
						"id" : generate_unique_id()
					}], player_id, instance_tree, player_position)
					rpc_id(player_id, "RecieveChat", "You have looted a " + message_words[1], "System")
				elif valid:
					get_node("Instances/"+StringifyInstanceTree(instance_tree)).SpawnLootBag([ 
					{
						"item" : int(message_words[1]),
						"id" : generate_unique_id()
					}], null, instance_tree, player_position)
					rpc_id(player_id, "RecieveChat", "You have looted a " + message_words[1], "System")
				else:
					rpc_id(player_id, "RecieveChat", "Invalid loot id", "SystemERROR")
			if message_words[0] == "/max" and message_words.size() == 1:
				player_container.Max()
		else:
			rpc("RecieveChat", message, player_name, player_container.character.class)

#PLAYER INTERACTION

func NotifyDeath(player_id, enemy_name):
	rpc_id(player_id, "CharacterDied", enemy_name)
	rpc("RecieveChat", str(player_id) + " has been killed by a "+enemy_name, "System")
	
func SetHealth(player_id, max_health, health):
	rpc_id(player_id,"SetHealth",max_health, health)

#Utility functions 

func StringifyInstanceTree(instance_tree):
	var res = ""
	for instance in instance_tree:
		res += (str(instance)+"/")
	return res.left(res.length() - 1) 

func generate_unique_id():
	var timestamp = OS.get_unix_time()
	var random_value = randi()
	return (str(timestamp) + "_" + str(random_value)).sha256_text()
