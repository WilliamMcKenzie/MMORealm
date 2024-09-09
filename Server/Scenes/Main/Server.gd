extends Node

var max_players = 100
var port = 20200
var network = NetworkedMultiplayerENet.new()
var html_network = WebSocketServer.new()

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
	StartHTMLServer()
	GameplayLoop.CreateIslandTemplate()
	#GameplayLoop.CreateIslandTemplate()
	#GameplayLoop.CreateIslandTemplate()
	
	#Open realm
	#for i in range(100):
		#PlayerVerification.CreateFakePlayerContainer()
	
	#SpawnNPC("raa'sloth", ["nexus"], Vector2(0,0))
	#get_node("Instances/nexus").OpenPortal("island", ["nexus"], get_node("Instances/nexus").GetBoatSpawnpoints(), Vector2(750,750), "salazar")
	get_node("Instances/nexus").OpenPortal("island", ["nexus"], get_node("Instances/nexus").GetBoatSpawnpoints(), Vector2(750,750), "oranix")
	get_node("Instances/nexus").OpenPortal("island", ["nexus"], get_node("Instances/nexus").GetBoatSpawnpoints(), Vector2(750,750), "vajira")
	get_node("Instances/nexus").OpenPortal("island", ["nexus"], get_node("Instances/nexus").GetBoatSpawnpoints(), Vector2(750,750), "raa'sloth")
	get_node("Instances/nexus").OpenPortal("tutorial_island", ["nexus"], Vector2.ZERO, Vector2(200,200), "tutorial_troll_king")
	get_node("Instances/nexus").OpenPortal("ruined_temple", ["nexus"], Vector2.ZERO)

#Update connected players
var clock_sync_timer = 0
func _physics_process(delta):
	clock_sync_timer += 1
	if clock_sync_timer >= 60:
		var network_connected_peers = get_tree().get_network_connected_peers()
		for instance_tree in player_instance_tracker.keys():
			for id in player_instance_tracker[instance_tree]:
				if not network_connected_peers.has(id):
					player_instance_tracker[instance_tree].erase(id)

func _process(delta):
	if html_network.is_listening():
		html_network.poll();

func StartHTMLServer():
	var result = html_network.listen(port, PoolStringArray(), true);
	if result != OK:
		print("Failed to start server:", result)
	else:
		print("Server is running on port", port)
	
	get_tree().set_network_peer(html_network);
	
	get_tree().connect("network_peer_connected", self, "_Peer_Connected")
	get_tree().connect("network_peer_disconnected", self, "_Peer_Disconnected")

#This startserver func is now legacy, somehow html server works for mobile clients as well
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
	if player_state_collection.has(id) and player_instance_tracker[player_state_collection[id]["I"]].has(id) and get_node("Instances/"+StringifyInstanceTree(player_state_collection[id]["I"])+"/YSort/Players/"+str(id)):
		var instance_tree = player_state_collection[id]["I"]
		var player_container = get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(id))
		
		for stat in ["health", "attack", "defense", "speed", "dexterity", "vitality"]:
			if player_container.stat_buffs.has(stat):
				player_container.GiveBuff(0, stat, 0)
		DeleteHouse(id)
		PlayerVerification.verified_emails.erase(player_container.email)
		HubConnection.UpdateAccountData(player_container.email, player_container.account_data)
		get_node("Instances/"+StringifyInstanceTree(player_state_collection[id]["I"])).RemovePlayer(player_container)
		player_instance_tracker[player_state_collection[id]["I"]].erase(id)
		player_state_collection.erase(id)
		rpc_id(0, "DespawnPlayer", id)

#TUTORIAL
func StartTutorial(player_id):
	var instance_tree = player_state_collection[player_id]["I"].duplicate()
	var current_instance_node = get_node("Instances/"+StringifyInstanceTree(instance_tree))
	var player_container = current_instance_node.get_node("YSort/Players/"+str(player_id))
	
	var instance_id = null
	for child in current_instance_node.get_children():
		if "tutorial_island" in child.name:
			instance_id = child.name
			break
	
	if instance_id:
		player_instance_tracker[instance_tree].erase(player_id)
		instance_tree.append(str(instance_id))
		
		var island_node = get_node("Instances/"+StringifyInstanceTree(instance_tree))
		var spawnpoint = island_node.GetMapSpawnpoint()
			
		rpc_id(player_id, "ReturnIslandData", { "Name": current_instance_node.object_list[instance_id]["name"], "Id":instance_id, "Position": spawnpoint})
		get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])).RemovePlayer(player_container)
		get_node("Instances/"+StringifyInstanceTree(instance_tree)).SpawnPlayer(player_container)
		
		player_state_collection[player_id] = {"T": OS.get_system_time_msecs(), "P": spawnpoint, "A": "Idle", "I": instance_tree}
		player_instance_tracker[instance_tree].append(player_id)
		
		SendCharacterData(player_id, player_container.character)
		rpc_id(int(player_id), "StartTutorial")

func TutorialStep(step, player_id):
	rpc_id(int(player_id), "TutorialStep", step)

remote func ChooseUsername(username):
	var player_id = get_tree().get_rpc_sender_id()
	var instance_tree = player_state_collection[player_id]["I"].duplicate()
	var current_instance_node = get_node("Instances/"+StringifyInstanceTree(instance_tree))
	var player_container = current_instance_node.get_node("YSort/Players/"+str(player_id))
	if player_container.account_data.username == "[unset]":
		HubConnection.ConfirmUsername(username, player_id)
	else:
		ConfirmUsername(true, player_container.account_data.username, player_id)
	
func ConfirmUsername(result, username, player_id):
	var instance_tree = player_state_collection[player_id]["I"]
	var current_instance_node = get_node("Instances/"+StringifyInstanceTree(instance_tree))
	var player_container = get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id))
	if result:
		player_name_by_id[player_id] = username
		player_id_by_name[username] = player_id
		player_container.account_data.username = username
		current_instance_node.player_list[str(player_id)]["name"] = username
		get_node("/root/Server/Instances/nexus/house " + str(player_id)).SetHouseData(player_container.account_data)
		
		player_container.tutorial_step = 1
		player_container.in_tutorial = true
		TutorialStep("Controls", player_id)
	
	rpc_id(player_id, "ConfirmUsername", result, username)

#BUILDING
remote func AddGuest(guest):
	var player_id = get_tree().get_rpc_sender_id()
	var house_id = "house " + str(player_id)
	var house_node = get_node("Instances/nexus/"+house_id)
	
	if player_state_collection[player_id]["I"] != ["nexus", house_id]:
		return
	
	house_node.AddGuest(guest)
remote func RemoveGuest(guest):
	var player_id = get_tree().get_rpc_sender_id()
	var house_id = "house " + str(player_id)
	var house_node = get_node("Instances/nexus/"+house_id)
	
	if player_state_collection[player_id]["I"] != ["nexus", house_id]:
		return
	
	house_node.RemoveGuest(guest)
remote func ToggleState():
	var player_id = get_tree().get_rpc_sender_id()
	var house_id = "house " + str(player_id)
	var house_node = get_node("Instances/nexus/"+house_id)
	
	if player_state_collection[player_id]["I"] != ["nexus", house_id]:
		return
	
	house_node.ToggleState()

remote func RemoveBuilding(position):
	var player_id = get_tree().get_rpc_sender_id()
	var house_id = "house " + str(player_id)
	var house_node = get_node("Instances/nexus/"+house_id)
	
	if player_state_collection[player_id]["I"] != ["nexus", house_id]:
		return
	
	house_node.RemoveBuilding(position)

remote func PlaceBuilding(type, position):
	var player_id = get_tree().get_rpc_sender_id()
	var house_id = "house " + str(player_id)
	var house_node = get_node("Instances/nexus/"+house_id)
	
	if player_state_collection[player_id]["I"] != ["nexus", house_id]:
		return
	
	house_node.PlaceBuilding(type, position)

remote func BuildBuilding(type):
	var player_id = get_tree().get_rpc_sender_id()
	var house_id = "house " + str(player_id)
	var house_node = get_node("Instances/nexus/"+house_id)
	
	if player_state_collection[player_id]["I"] != ["nexus", house_id]:
		return
	
	house_node.BuildBuilding(type)

#TRADE
remote func AcceptTrade(player1_name):
	if not player_id_by_name.has(player1_name) or not player_name_by_id[get_tree().get_rpc_sender_id()]:
		return
	
	var player1_id = player_id_by_name[player1_name]
	var player2_id = get_tree().get_rpc_sender_id()
	var player2_name = player_name_by_id[player2_id]
	
	if not player_state_collection.has(int(player1_id)) or not player_state_collection.has(int(player2_id)):
		return
	
	var instance_tree1 = player_state_collection[int(player1_id)]["I"]
	var player_container1 = get_node("Instances/"+StringifyInstanceTree(instance_tree1)+"/YSort/Players/"+str(player1_id))
	
	var instance_tree2 = player_state_collection[int(player2_id)]["I"]
	var player_container2 = get_node("Instances/"+StringifyInstanceTree(instance_tree2)+"/YSort/Players/"+str(player2_id))
	
	player_container1.StartTrade(player2_name)
	player_container2.StartTrade(player1_name)
	rpc_id(player1_id, "StartTrade", player2_name)
	rpc_id(player2_id, "StartTrade", player1_name)

func SendTradeData(player_id, other_player_inventory, other_player_selection):
	rpc_id(int(player_id), "RecieveTradeData", other_player_inventory, other_player_selection)

remote func OfferWithdrawn(player_id1, player_id2):
	rpc_id(int(player_id1), "OfferWithdrawn")
	rpc_id(int(player_id2), "OfferWithdrawn")

remote func SelectItem(i):
	var player_id = get_tree().get_rpc_sender_id()
	
	var instance_tree = player_state_collection[int(player_id)]["I"]
	var player_container = get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id))
	player_container.SelectItem(i)
	
remote func DeselectItem(i):
	var player_id = get_tree().get_rpc_sender_id()
	
	var instance_tree = player_state_collection[int(player_id)]["I"]
	var player_container = get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id))
	player_container.DeselectItem(i)

remote func AcceptOffer():
	var player_id = get_tree().get_rpc_sender_id()
	
	var instance_tree = player_state_collection[int(player_id)]["I"]
	var player_container = get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id))
	player_container.AcceptOffer()

remote func CancelOffer():
	var player_id = get_tree().get_rpc_sender_id()
	
	var instance_tree = player_state_collection[int(player_id)]["I"]
	var player_container = get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id))
	player_container.CancelOffer(true)

func ForceCancelTrade(player_id):
	rpc_id(int(player_id), "ForceCancelTrade")

func OfferAccepted(player_id):
	rpc_id(int(player_id), "OfferAccepted")

func FinalizeTrade(player_id1, player_id2):
	rpc_id(int(player_id1), "FinalizeTrade")
	rpc_id(int(player_id2), "FinalizeTrade")

#INVENTORY/ITEMS
remote func FetchPlayerData(email):
	var player_id = get_tree().get_rpc_sender_id()
	var player_data = get_parent().get_node(str(player_id)).getPlayerData()
	rpc_id(player_id, "ReturnPlayerData", player_data)
remote func FetchBatchCharacterData(ids):
	var player_id = get_tree().get_rpc_sender_id()
	var characters_data = []
	for id in ids:
		if player_state_collection.has(int(id)):
			var instance_tree = player_state_collection[int(id)]["I"]
			var player_container = get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(id))
			if player_container:
				var character_data = player_container.character
				characters_data.append({
					"name" : player_name_by_id[int(id)],
					"class" : character_data.class,
					"level" : character_data.level,
					"gear" : character_data.gear,
				})
	rpc_id(player_id, "ReturnBatchCharacterData", characters_data)

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
	
	var loot = to_data.parent.split(" ")[0] == "loot" or from_data.parent.split(" ")[0] == "loot"
	var storage = to_data.parent.split(" ")[0] == "storage" or from_data.parent.split(" ")[0] == "storage"
	if loot or storage:
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
			var players = get_node("Instances/"+StringifyInstanceTree(player_state["I"])+"/YSort/Players")
			if players and players.has_node(str(player_id)):
				get_node("Instances/"+StringifyInstanceTree(player_state["I"])).UpdatePlayer(player_id, player_state)
	else:
		player_instance_tracker[["nexus"]].append(player_id)
		player_state["I"] = ["nexus"]
		player_state_collection[player_id] = player_state

func SendWorldState(id, world_state, instance_tree):
	var error = rpc_unreliable_id(int(id), "RecieveWorldState", world_state)

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
	print("Fetching...")
	rpc_id(player_id, "FetchToken")

remote func ReturnToken(token, character_index):
	var player_id = get_tree().get_rpc_sender_id()
	if not token:
		network.disconnect_peer(player_id)
		return
	PlayerVerification.Verify(player_id, token, character_index)

func ReturnTokenVerificationResults(player_id, result):
	rpc_id(player_id, "ReturnTokenVerificationResults", result)
	if result == true:
		rpc_id(0, "SpawnNewPlayer", player_id, Vector2(79, 56))

#CHARACTERS
func SendQuestData(player_id, current_quest_data):
	rpc_id(int(player_id), "RecieveQuestData", current_quest_data)
func SendCharacterData(player_id, character):
	rpc_id(int(player_id), "RecieveCharacterData", character)
func SendAccountData(player_id, account_data):
	rpc_id(int(player_id), "RecieveAccountData", account_data)

#NPCS/ENEMIES
func SpawnNPC(enemy_name, instance_tree, spawn_position, origin="player"):
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
			
			"behavior": enemy_data.behavior,
			"current_direction" : null,
			"last_position" : Vector2.ZERO,
			"stuck_timer" : 5,
			
			"speed":enemy_data.speed,
			"exp": enemy_data.exp,
			"damage_tracker": {},
			"target": spawn_position + get_node("Instances/"+StringifyInstanceTree(instance_tree)).position,
			"anchor_position": spawn_position + get_node("Instances/"+StringifyInstanceTree(instance_tree)).position,
			"origin" : origin,
			"effects" : {},
			"signals" : {},
			
			"pattern_index" : 0,
			"pattern_timer" : 0,
			"phase_index" : 0,
			"phase_timer" : 0,
			"used_phases" : {},
		}
		get_node("Instances/"+StringifyInstanceTree(instance_tree)).SpawnEnemy(enemy, enemy_id)

func OffsetProjectileAngle(base_direction, offset_vector):
	var base_angle = base_direction.angle()
	var offset_angle = offset_vector.angle()
	var new_angle = base_angle + offset_angle
	var new_direction = Vector2(cos(new_angle), sin(new_angle))
	
	return new_direction
remote func SendPlayerProjectile(projectile_data):
	var player_id = get_tree().get_rpc_sender_id()
	var instance_tree = player_state_collection[player_id]["I"]
	var player_container = get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id))
	if not player_container:
		return
	
	var weapon = player_container.gear.weapon
	var projectile = weapon.projectiles[projectile_data.ProjectileIndex]
	projectile_data.Direction = OffsetProjectileAngle(projectile_data.Direction, projectile.offset)
	projectile_data.merge({
		"Projectile":projectile.projectile,
		"TileRange":projectile.tile_range,
		"Piercing":projectile.piercing,
		"Formula":projectile.formula,
		"Speed":projectile.speed,
		"Size":projectile.size,
	})
	
	rpc_id(0, "ReceivePlayerProjectile", projectile_data, instance_tree, player_id)
	
func SendEnemyProjectile(projectile_data, instance_tree, enemy_id):
	for player_id in player_instance_tracker[instance_tree]:
		rpc_id(player_id, "RecieveEnemyProjectile", projectile_data, instance_tree, enemy_id)
func RemoveEnemyProjectile(projectile_id, instance_tree):
	for player_id in player_instance_tracker[instance_tree]:
		rpc_id(player_id, "RemoveEnemyProjectile", projectile_id, instance_tree)

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
		if enemy_container.effects.has("invincible"):
			total_damage = 0
		
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
	var player_container = get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])+"/YSort/Players/"+str(player_id))
	var instance_tree = player_state_collection[player_id]["I"].duplicate(true)
	
	if not player_container.in_tutorial:
		rpc_id(player_id, "ConfirmNexus")
	
		player_instance_tracker[instance_tree].erase(player_id)
		player_instance_tracker[["nexus"]].append(player_id)
		get_node("Instances/"+StringifyInstanceTree(instance_tree)).RemovePlayer(player_container)
		get_node("Instances/"+StringifyInstanceTree(["nexus"])).SpawnPlayer(player_container)
		
		player_state_collection[player_id] = {"T": OS.get_system_time_msecs(), "P": Vector2.ZERO, "A": "Idle", "I": ["nexus"]}

func ForcedNexus(player_id):
	var player_container = get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])+"/YSort/Players/"+str(player_id))
	var instance_tree = player_state_collection[player_id]["I"].duplicate(true)
	
	rpc_id(player_id, "ConfirmNexus")
	
	player_instance_tracker[instance_tree].erase(player_id)
	player_instance_tracker[["nexus"]].append(player_id)
	get_node("Instances/"+StringifyInstanceTree(instance_tree)).RemovePlayer(player_container)
	get_node("Instances/"+StringifyInstanceTree(["nexus"])).SpawnPlayer(player_container)
	
	player_state_collection[player_id] = {"T": OS.get_system_time_msecs(), "P": Vector2.ZERO, "A": "Idle", "I": ["nexus"]}

func EnterHouse(player_id, house_player_id):
	var house_id = "house " + str(house_player_id)
	var house_node = get_node("Instances/nexus/"+house_id)
	
	if not house_node.RequestEntry(player_name_by_id[player_id]):
		SendMessage(player_id, "error", "Access not permitted by owner!")
		return
	
	var player_container = get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])+"/YSort/Players/"+str(player_id))
	var instance_tree = player_state_collection[player_id]["I"].duplicate(true)
	
	player_instance_tracker[instance_tree].erase(player_id)
	player_instance_tracker[["nexus", house_id]].append(player_id)
	get_node("Instances/"+StringifyInstanceTree(instance_tree)).RemovePlayer(player_container)
	get_node("Instances/"+StringifyInstanceTree(["nexus", house_id])).SpawnPlayer(player_container)
	
	player_state_collection[player_id] = {"T": OS.get_system_time_msecs(), "P": Vector2.ZERO, "A": "Idle", "I": ["nexus", house_id]}
	rpc_id(player_id, "ReturnHouseData", {"Name": player_name_by_id[house_player_id], "Id":house_id, "Tiles" : house_node.tiles, "Position": Vector2(12*8,12*8)})

func CreateHouse(player_id):
	var house_id = "house " + str(player_id)
	var house_instance = load("res://Scenes/SupportScenes/Housing/House.tscn").instance()
	house_instance.name = house_id
	house_instance.player_id = player_id
	house_instance.instance_tree = ["nexus", house_id]
	house_instance.position = Instances.GetFreeInstancePosition()
	
	get_node("Instances/nexus").add_child(house_instance)
	Instances.AddInstanceToTracker(["nexus"], house_id)

func DeleteHouse(player_id):
	var house_id = "house " + str(player_id)
	var instance_tree = ["nexus", house_id]
	
	for _player_id in player_instance_tracker[instance_tree].duplicate():
		ForcedNexus(_player_id)
		SendMessage(_player_id, "warning", player_name_by_id[player_id] + "'s house has been closed.")
	
	player_instance_tracker.erase(instance_tree)
	get_node("Instances/nexus/"+house_id).SaveData()
	get_node("Instances/nexus/"+house_id).queue_free()

func ForcedEnterInstance(instance_id, player_id):
	var current_instance_node = get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"]))
	
	if current_instance_node.has_node(instance_id):
		var instance_tree = player_state_collection[player_id]["I"].duplicate(true)
		var player_container = get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id))
		player_container.GiveEffect("invincible", 5)
		
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
			
			rpc_id(player_id, "ReturnIslandData", { "Name": island_node.ruler, "Id":instance_id, "Position": spawnpoint})
			get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"])).RemovePlayer(player_container)
			get_node("Instances/"+StringifyInstanceTree(instance_tree)).SpawnPlayer(player_container)
			
			player_state_collection[player_id] = {"T": OS.get_system_time_msecs(), "P": spawnpoint, "A": "Idle", "I": instance_tree}
			player_instance_tracker[instance_tree].append(player_id)
		SendCharacterData(player_id, player_container.character)

remote func EnterInstance(instance_id):
	var player_id = get_tree().get_rpc_sender_id()
	var current_instance_node = get_node("Instances/"+StringifyInstanceTree(player_state_collection[player_id]["I"]))
	
	if current_instance_node.has_node(instance_id):
		var instance_tree = player_state_collection[player_id]["I"].duplicate(true)
		var player_container = get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id))
		player_container.GiveEffect("invincible", 5)
		
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
			
			rpc_id(player_id, "ReturnIslandData", { "Name": island_node.ruler, "Id":instance_id, "Position": spawnpoint})
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

func EnemySpeech(enemy_name, enemy_id, message):
	rpc("RecieveChat", message, "Enemy", enemy_name, enemy_id)

remote func RecieveChatMessage(message):
	var message_words = message.split(" ")
	var player_id = get_tree().get_rpc_sender_id()
	var player_name = player_name_by_id[player_id]
	var player_position = player_state_collection[player_id]["P"]
	var instance_tree = player_state_collection[player_id]["I"]
	var player_container = get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id))
	
	if len(message) >= 1:
		if message[0] == "/":
			if message_words[0] == "/class" and message_words.size() == 2 and player_container.account_data.classes.has(message_words[1]):
				player_container.character.class = message_words[1]
				SendCharacterData(player_id, player_container.character)
			if message_words[0] == "/exp" and message_words.size() == 2 and int(message_words[1]):
				player_container.AddExp(int(message_words[1]), "Ghoul", "123")
			if message_words[0] == "/invincible":
				player_container.GiveEffect("invincible", 99999)
			if message_words[0] == "/home" and message_words.size() == 1:
				EnterHouse(player_id, player_id)
			elif message_words[0] == "/home":
				var selected_player_name = message.substr(6,-1)
				if player_id_by_name.has(selected_player_name):
					var selected_player_id = player_id_by_name[selected_player_name]
					EnterHouse(player_id, selected_player_id)
				else:
					rpc_id(player_id, "RecieveChat", "Invalid username: " + selected_player_name, "SystemERROR")
			if message_words[0] == "/trade":
				var selected_player_name = message.substr(7,-1)
				if player_id_by_name.has(selected_player_name):
					var selected_player_id = player_id_by_name[selected_player_name]
					if player_state_collection.has(selected_player_id) and player_state_collection[selected_player_id]["I"] == player_state_collection[player_id]["I"] and player_container.position.distance_to(get_node("Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(selected_player_id)).position) > 32*8:
						rpc_id(player_id, "RecieveChat", "To far away!", "System")
					elif player_state_collection.has(selected_player_id) and player_state_collection[selected_player_id]["I"] == player_state_collection[player_id]["I"]:
						rpc_id(player_id, "RecieveChat", "You have requested a trade with " + selected_player_name, "System")
						rpc_id(selected_player_id, "RequestTrade", player_name)
					else:
						rpc_id(player_id, "RecieveChat", "Invalid username: " + selected_player_name, "System")
				else:
					rpc_id(player_id, "RecieveChat", "Invalid username: " + selected_player_name, "SystemERROR")
			if message_words[0] == "/tp":
				var selected_player_name = message.substr(4,-1)
				if player_id_by_name.has(selected_player_name):
					var selected_player_id =  player_id_by_name[message.substr(4,-1)]
					if OS.get_system_time_secs() - player_container.last_teleported < 5:
						rpc_id(player_id, "RecieveChat", "Teleport on cooldown, wait " + str(5 - (OS.get_system_time_secs() - player_container.last_teleported)) + " more seconds.", "System")
					elif player_state_collection.has(selected_player_id) and player_state_collection[selected_player_id]["I"] == player_state_collection[player_id]["I"]:
						player_container.last_teleported = OS.get_system_time_secs()
						player_state_collection[player_id]["P"] = player_state_collection[selected_player_id]["P"]
						rpc_id(player_id, "MovePlayer", player_state_collection[player_id]["P"])
						rpc_id(player_id, "RecieveChat", "You have teleported to " + selected_player_name, "System")
					else:
						rpc_id(player_id, "RecieveChat", "Invalid username: " + message.substr(4,-1), "System")
				else:
					rpc_id(player_id, "RecieveChat", "Invalid username: " + message.substr(4,-1), "SystemERROR")
			if message_words[0] == "/d":
				if message.substr(3,-1) in ServerData.dungeons.keys():
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
			rpc("RecieveChat", message, player_name, player_container.character.class, player_container.name)

#PLAYER INTERACTION

func SendError(player_id, error):
	rpc_id(player_id, "RecieveError", error)

func IdentifierToString(identifier):
	var words = identifier.split("_")
	var proper_string = ""
	for word in words:
		proper_string += word.capitalize() + " "
	proper_string = proper_string.strip_edges()
	
	return proper_string
func NotifyDeath(player_id, enemy_name):
	var instance_tree = player_state_collection[int(player_id)]["I"]
	
	rpc_id(player_id, "CharacterDied", enemy_name)
	rpc("RecieveChat", str(player_name_by_id[player_id]) + " has been killed by a "+IdentifierToString(enemy_name), "System")
	yield(get_tree().create_timer(1), "timeout")
	html_network.disconnect_peer(player_id)

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
