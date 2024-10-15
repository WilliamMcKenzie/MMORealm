extends Node

#var url = "wss://gameserver.lagso.com"
#var url = "ws://159.203.0.78:20200"
var url = "ws://localhost:20200"

#var ip_address = "159.203.0.78"
var ip_address = "localhost"
var port = 20200

var network = NetworkedMultiplayerENet.new()
var html_network = WebSocketClient.new();

#if we are using the web client
var html = true

var character_index
var token

var projectile_pool_amount = 500
#Clock sync
var latency = 0
var server_delay = 0
var client_clock = 0
var decimal_collector : float = 0
var sync_clock_counter = 0

#Map preloads
var current_instance_tree = ["nexus"]
var nexus = preload("res://Scenes/MainScenes/Nexus/Nexus.tscn")
var island_container = preload("res://Scenes/MainScenes/Island/Island.tscn")
var dungeon_container = preload("res://Scenes/MainScenes/Dungeon/Dungeon.tscn")
var arena_container = preload("res://Scenes/MainScenes/Arena/Arena.tscn")
var house_container = preload("res://Scenes/MainScenes/House/House.tscn")


#Projectile preload
var projectile = preload("res://Scenes/SupportScenes/Projectiles/Enemies/Projectile.tscn")
var projectile_pool = preload("res://Scenes/SupportScenes/Projectiles/Enemies/Pool.tscn")

#For player hierarchy
var ysort_scene = preload("res://Scenes/SupportScenes/Misc/YSort.tscn")

func Init():
	current_instance_tree = ["nexus"]

var player_position
var latency_timer = 59
func _physics_process(delta):
	client_clock = OS.get_system_time_msecs()-latency
	
	latency_timer += 1
	if (html_network.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED ||
		html_network.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTING):
		html_network.poll();
	
	if latency_timer % 20 == 0 and get_node("../SceneHandler").has_node(GetCurrentInstance()):
		player_position = get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player").position
	if latency_timer >= 60 and html_network.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
		latency_timer = 0
		rpc_id(1, "FetchServerTime", OS.get_system_time_msecs())

func UpdateRightJoystick(output):
	if get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player"):
		get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player").right_joystick_output = output.normalized()
func UpdateLeftJoystick(output):
	if get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player"):
		get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player").left_joystick_output = output.normalized()

#Check if vector is within a certain range of player
func IsWithinRange(_vector, _range = 16):
	return true if (player_position.distance_to(_vector) <= _range*8) else false

func ConnectToServerHTML():
	if not token:
		var start = OS.get_system_time_secs()
		var current = OS.get_system_time_secs()
		
		while current - start < 4:
			yield(get_tree().create_timer(1), "timeout")
			current = OS.get_system_time_secs()
			if token:
				break
	
	if not token:
		ErrorPopup.OpenPopup("Connection failed")
	
	var error = html_network.connect_to_url(url, PoolStringArray(), true);
	
	network.create_client(ip_address, port)
	get_tree().set_network_peer(null)
	get_tree().network_peer = html_network
	
	get_tree().connect("network_peer_disconnected", self, "_Disconnected")
	get_tree().connect("server_disconnected", self, "_Disconnected")

func ConnectToServer():
	ConnectToServerHTML()
	return
	
	if not token:
		var start = OS.get_system_time_secs()
		var current = OS.get_system_time_secs()
		
		while current - start < 10:
			yield(get_tree().create_timer(1), "timeout")
			current = OS.get_system_time_secs()
			if token:
				break
	
	if not token:
		ErrorPopup.OpenPopup("Connection failed")
	
	network.create_client(ip_address, port)
	get_tree().set_network_peer(null)
	get_tree().network_peer = network
	
	get_tree().connect("connection_failed", self, "_onConnectionFailed")
	get_tree().connect("network_peer_disconnected", self, "_Disconnected")
	get_tree().connect("server_disconnected", self, "_Disconnected")

func _Disconnected():
	ErrorPopup.OpenPopup("Disconnected")
func _onConnectionFailed():
	ErrorPopup.OpenPopup("Connection failed")

var first_fetch = true
remote func ReturnServerTime(server_time, client_time):
	server_delay = (OS.get_system_time_msecs()-client_time)/2
	var temp_latency = abs(server_time - client_time - server_delay)
	
	if first_fetch or abs(latency-temp_latency) < 30:
		first_fetch = false
		latency = temp_latency

remote func FetchToken():
	rpc_id(1, "ReturnToken", token, character_index)
remote func ReturnTokenVerificationResults(results):
	if(results == true):
		print("Successful token verification")
	else:
		ErrorPopup.OpenPopup("Login failed")

#REALM CLOSE
remote func RealmClosed(ruler_id, dungeon_name):
	var ysort = get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort")
	var enemies = ysort.get_node("Enemies")
	
	LoadingScreen.RealmClosed()
	if ruler_id and enemies.has_node(ruler_id):
		var enemy = enemies.get_node(ruler_id)
		var camera = ysort.get_node("player/Camera2D").duplicate(true)
		camera.set_script(load("res://Scenes/SupportScenes/PlayerCharacter/CameraShake.gd"))
		enemy.add_child(camera)
		camera.target = enemy
		
		var original_instance = current_instance_tree[len(current_instance_tree)-1]
		while(current_instance_tree[len(current_instance_tree)-1] == original_instance):
			yield(get_tree().create_timer(0.1), "timeout")
		
		camera.queue_free()
		ysort.get_node("player/Camera2D").current = true
	else:
		var camera = ysort.get_node("player/Camera2D")
		camera.target = ysort.get_node("player")
		var original_instance = current_instance_tree[len(current_instance_tree)-1]
		while(current_instance_tree[len(current_instance_tree)-1] == original_instance):
			yield(get_tree().create_timer(0.1), "timeout")
	
	LoadingScreen.Transition(IdentifierToString(dungeon_name))
	yield(get_tree().create_timer(0.3), "timeout")
	LoadingScreen.RealmClosedEnd()

#TUTORIAL
func DialogueResponse(response):
	rpc_id(1, "DialogueResponse", response)
remote func StartTutorial():
	GameUI.StartTutorial()
func ChooseUsername(username):
	rpc_id(1, "ChooseUsername", username)
remote func ConfirmUsername(result, username):
	if result:
		GameUI.account_data.username = username
		GameUI.get_node("ChooseName").visible = false
	else:
		GameUI.get_node("ChooseName/MarginContainer/Container/InputContainer/NameContainter/NameWarning").text = "Name is taken!"
remote func Dialogue(step):
	GameUI.get_node("NpcDialogue").StartSubject(step)

#OTHER PLAYERS
func FetchBatchCharacterData(other_players_ids):
	rpc_id(1, "FetchBatchCharacterData", other_players_ids)
remote func ReturnBatchCharacterData(characters_data):
	GameUI.SetNearbyCharacters(characters_data)

#TRADE
remote func RequestTrade(player_name):
	GameUI.TradeRequest(player_name)

func AcceptTrade(player_name):
	rpc_id(1, "AcceptTrade", player_name)

remote func StartTrade(player_name):
	GameUI.Toggle("all")
	GameUI.is_in_menu = false
	GameUI.get_node("TradingMenu").other_player_name = player_name
	GameUI.Toggle("trade")
	
	if GameUI.is_in_menu == false:
		GameUI.Toggle("trade")

remote func RecieveTradeData(other_player_inventory, other_player_selection):
	GameUI.get_node("TradingMenu").SetTradeData(other_player_inventory, other_player_selection)
remote func OfferWithdrawn():
	GameUI.get_node("TradingMenu").OfferWithdrawn()

func SelectItem(i):
	rpc_id(1, "SelectItem", i)
func DeselectItem(i):
	rpc_id(1, "DeselectItem", i)
func AcceptOffer():
	rpc_id(1, "AcceptOffer")
func CancelOffer():
	rpc_id(1, "CancelOffer")

remote func ForceCancelTrade():
	GameUI.is_in_menu = true
	GameUI.Toggle("trade")
remote func OfferAccepted():
	GameUI.get_node("TradingMenu").OfferAccepted()

remote func FinalizeTrade():
	GameUI.is_in_menu = true
	GameUI.Toggle("trade")

#INVENTORY/ITEMS
remote func RecieveAccountData(account_data):
	GameUI.SetAccountData(account_data)
func SetCharacterIndex(_character_index):
	character_index = _character_index
remote func RecieveCharacterData(character):
	var player_node = get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player")
	GameUI.SetCharacterData(character)
	player_node.SetCharacter(character)
remote func RecieveQuestData(current_quest_data):
	GameUI.SetQuest(current_quest_data)
remote func ShowIndicator(type, amount):
	var player_node = get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player")
	player_node.ShowIndicator(type, amount)

func UseItem(index):
	rpc_id(1, "UseItem", index)
func EquipItem(index):
	rpc_id(1, "EquipItem", index)
func ChangeItem(to_data, from_data):
	rpc_id(1, "ChangeItem", to_data, from_data)
func DropItem(data):
	rpc_id(1, "DropItem", data)
func IncreaseStat(stat):
	rpc_id(1, "IncreaseStat", stat)


#PLAYER SPAWNING
remote func SpawnNewPlayer(player_id, spawn_position):
	return
	GetCurrentInstanceNode().SpawnNewPlayer(player_id, spawn_position)
remote func DespawnPlayer(player_id):
	GetCurrentInstanceNode().DespawnPlayer(player_id)

#WORLD SYNCING
func SendProjectile(projectile_data):
	rpc_id(1, "SendPlayerProjectile", projectile_data)

remote func ReceivePlayerProjectile(projectile_data, instance_tree, player_id):
	if player_id == get_tree().get_network_unique_id() or instance_tree != current_instance_tree or Settings.hide_player_shots:
		return
	
	var player_node = get_node_or_null("../SceneHandler/"+GetCurrentInstance()+"/YSort/OtherPlayers/"+str(player_id))
	if player_node:
		var projectile_dict = player_node.projectile_dict
		if projectile_dict.has(OS.get_system_time_msecs()):
			var add = OS.get_system_time_msecs() 
			while(projectile_dict.has(add)):
				add += 1
			projectile_dict[add] = [projectile_data]
		else:
			projectile_dict[OS.get_system_time_msecs()] = [projectile_data]

remote func RecieveEnemyProjectile(projectile_data, instance_tree, enemy_id):
	var enemy_node = get_node_or_null("../SceneHandler/"+GetCurrentInstance()+"/YSort/Enemies/"+str(enemy_id))
	if instance_tree != current_instance_tree:
		pass
	elif enemy_node:
		enemy_node.ShootProjectile()
	if GetCurrentInstanceNode().has_node("Pool"):
		for child in get_node("../SceneHandler/"+GetCurrentInstance()+"/Pool").get_children():
			if child.is_active == false:
				child.projectile_data = projectile_data
				child.is_active = true
				child.Activate()
				break
	else:
		CreatePool(projectile_pool_amount)
		for child in get_node("../SceneHandler/"+GetCurrentInstance()+"/Pool").get_children():
			if child.is_active == false:
				child.projectile_data = projectile_data
				child.is_active = true
				child.Activate()
				break

remote func RemoveEnemyProjectile(id, instance_tree):
	if instance_tree != current_instance_tree:
		pass
	if has_node("../SceneHandler/"+GetCurrentInstance()+"/YSort") and GetCurrentInstanceNode().has_node("Pool"):
		for child in get_node("../SceneHandler/"+GetCurrentInstance()+"/Pool").get_children():
			if child.projectile_data and child.projectile_data.id == id:
				child.DeActivate()
				break

remote func RemoveEnemy(enemy_id):
	var instance = get_node_or_null("../SceneHandler/"+GetCurrentInstance())
	var enemy_node = instance.get_node_or_null("/YSort/Enemies/"+str(enemy_id))
	
	instance.dead_enemies[enemy_id] = true
	if enemy_node:
		enemy_node.DeActivate()

func SendPlayerState(player_state):
	if html_network.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
		rpc_unreliable_id(1, "RecievePlayerState", player_state)

remote func RecieveWorldState(world_state):
	if GetCurrentInstanceNode():
		GetCurrentInstanceNode().UpdateWorldState(world_state)
	
func UseAbility():
	rpc_id(1, "UseAbility")

#INSTANCES
func GetCurrentInstanceNode():
	return get_node("../SceneHandler/"+GetCurrentInstance())
func GetCurrentInstance():
	return current_instance_tree[current_instance_tree.size()-1]

func SendChatMessage(message):
	rpc_id(1,"RecieveChatMessage", message)
remote func RecieveChat(message,username,classname=null,id=null):
	if not username == "Enemy" or Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()).has_node("YSort/Enemies/"+id):
		GameUI.get_node("ChatControl").AddChat(message,username,classname,id)
remote func MovePlayer(new_position):
	get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player").position = new_position

var last_nexus = 0
func Nexus():
	if GameUI.get_node("NpcDialogue").subject == "Final":
		GameUI.get_node("GameButtons/HomeButton/TutorialArrow").visible = false
	if "nexus" == GetCurrentInstance() or OS.get_system_time_msecs()-last_nexus < 500:
		return
	rpc_id(1, "Nexus")
	last_nexus = OS.get_system_time_msecs()
remote func ConfirmNexus(spawnpoint = Vector2.ZERO):
	LoadingScreen.Transition("")
	yield(get_tree().create_timer(0.3), "timeout")
	var nexus_instance = nexus.instance()
	var map_instance = GetCurrentInstanceNode()
	var ysort = map_instance.get_node("YSort")
	for object in ysort.get_node("Objects/Npcs").get_children():
		object.queue_free()
	map_instance.remove_child(ysort)
	nexus_instance.add_child(ysort)
	nexus_instance.get_node("YSort/player").global_position = spawnpoint
	
	nexus_instance.name = "nexus"
	GetCurrentInstanceNode().queue_free()
	get_node("../SceneHandler").add_child(nexus_instance)
	current_instance_tree = ["nexus"]

func EnterInstance(instance_id, portal_name):
	LoadingScreen.Transition(IdentifierToString(portal_name))
	if instance_id == GetCurrentInstance():
		return
	if portal_name == "house":
		rpc_id(1,"RecieveChatMessage", "/home")
	else:
		rpc_id(1, "EnterInstance", instance_id)

remote func UpdateHouseData(house_data):
	GameUI.account_data.home = house_data
	GameUI.get_node("Building").SetHouseData(house_data)

remote func UpdateHouseTiles(tiles):
	var house_instance = GetCurrentInstanceNode()
	house_instance.UpdateTiles(tiles)
	
remote func ReturnHouseData(instance_data):
	LoadingScreen.Transition(instance_data.Name + "'s House")
	var house_instance = house_container.instance()
	var map_instance = GetCurrentInstanceNode()
	
	var ysort = map_instance.get_node("YSort")
	for object in ysort.get_node("Objects/Npcs").get_children():
		object.queue_free()
	map_instance.remove_child(ysort)
	house_instance.add_child(ysort)
	house_instance.get_node("YSort/player").global_position = instance_data["Position"]
	house_instance.name = instance_data["Id"]
	house_instance.PopulateHouse(instance_data)
	
	get_node("../SceneHandler").remove_child(GetCurrentInstanceNode())
	get_node("../SceneHandler").add_child(house_instance)
	current_instance_tree = ["nexus", instance_data["Id"]]

remote func Wave(gold, wave):
	LoadingScreen.Wave(gold, wave)

remote func ReturnArenaData(instance_data):
	var arena_instance = arena_container.instance()
	var map_instance = GetCurrentInstanceNode()
	
	var ysort = map_instance.get_node("YSort")
	for object in ysort.get_node("Objects/Npcs").get_children():
		object.queue_free()
	map_instance.remove_child(ysort)
	arena_instance.add_child(ysort)
	arena_instance.get_node("YSort/player").global_position = instance_data["Position"]
	arena_instance.name = instance_data["Id"]
	
	GetCurrentInstanceNode().queue_free()
	get_node("../SceneHandler").add_child(arena_instance)
	current_instance_tree.append(instance_data["Id"])
	LoadingScreen.Countdown()

remote func ReturnDungeonData(instance_data):
	var dungeon_instance = dungeon_container.instance()
	var map_instance = GetCurrentInstanceNode()
	
	var ysort = map_instance.get_node("YSort")
	for object in ysort.get_node("Objects/Npcs").get_children():
		object.queue_free()
	map_instance.remove_child(ysort)
	dungeon_instance.add_child(ysort)
	dungeon_instance.get_node("YSort/player").global_position = instance_data["Position"]
	dungeon_instance.get_node("YSort/player/Camera2D").current = true
	
	dungeon_instance.name = instance_data["Id"]
	dungeon_instance.PopulateDungeon(instance_data)
	
	GetCurrentInstanceNode().queue_free()
	get_node("../SceneHandler").add_child(dungeon_instance)
	current_instance_tree.append(instance_data["Id"])

remote func ReturnIslandData(instance_data, which=null):
	var island_instance = island_container.instance()
	var map_instance = GetCurrentInstanceNode()
	
	if which:
		island_instance.SetSpecialIsland(which)

	var ysort = map_instance.get_node("YSort")
	for object in ysort.get_node("Objects/Npcs").get_children():
		object.queue_free()
	map_instance.remove_child(ysort)
	island_instance.add_child(ysort)
	island_instance.get_node("YSort/player").global_position = instance_data["Position"]
	island_instance.name = instance_data["Id"]
	
	GetCurrentInstanceNode().queue_free()
	get_node("../SceneHandler").add_child(island_instance)
	current_instance_tree.append(instance_data["Id"])

func AddGuest(guest):
	rpc_id(1, "AddGuest", guest)
func RemoveGuest(guest):
	rpc_id(1, "RemoveGuest", guest)
func ToggleState():
	rpc_id(1, "ToggleState")
func RemoveBuilding(position):
	rpc_id(1, "RemoveBuilding", position)
func PlaceBuilding(type, position):
	rpc_id(1, "PlaceBuilding", type, position)
func BuildBuilding(type):
	rpc_id(1, "BuildBuilding", type)

#For tiles and stuff
#One time call
func FetchIslandChunk(chunk):
	rpc_id(1, "FetchIslandChunk", chunk)
remote func ReturnIslandChunk(chunk_data, chunk):
	GetCurrentInstanceNode().GenerateChunk(chunk_data, chunk)

#For enemies and stuff
#Called 20 times per second
func FetchChunkData(chunk):
	rpc_id(1, "FetchChunkData", chunk)
remote func ReturnChunkData(chunk_data, chunk):
	GetCurrentInstanceNode().UpdateChunk(chunk_data, chunk)

remote func ShowExpIndicator(xp):
	get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player").ShowExpIndicator(xp)

#ENEMIES
remote func CharacterDied(enemy_name):
	GameUI.is_dead = true
	GameUI.Toggle("all")
	GameUI.Toggle("death")

remote func SetHealth(max_health, current_health):
	GameUI.ChangeHealth(max_health, current_health)

func NPCHit(enemy_id, damage):
	rpc_id(1, "NPCHit", enemy_id, damage)
	
func CreatePool(amount):
	var new_pool = projectile_pool.instance()
	GetCurrentInstanceNode().add_child(new_pool)
	GetCurrentInstanceNode().move_child(new_pool, 0)
	for i in range(amount):
		new_pool.add_child(projectile.instance())

func IdentifierToString(identifier):
	var words = identifier.split("_")
	var proper_string = ""
	for word in words:
		proper_string += word.capitalize() + " "
	proper_string = proper_string.strip_edges()
	
	return proper_string
