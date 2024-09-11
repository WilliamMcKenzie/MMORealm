extends Node

var url = "wss://gameserver.lagso.com"
#var url = "ws://159.203.0.78:20200"
#var url = "ws://localhost:20200"

var ip_address = "159.203.0.78"
#var ip_address = "localhost"
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
var latency_array = []
var delta_latency = 0
var client_clock = 0
var decimal_collector : float = 0
var sync_clock_counter = 0

#Map preloads
var current_instance_tree = ["nexus"]
var nexus = preload("res://Scenes/MainScenes/Nexus/Nexus.tscn")
var island_container = preload("res://Scenes/MainScenes/Island/Island.tscn")
var dungeon_container = preload("res://Scenes/MainScenes/Dungeon/Dungeon.tscn")
var house_container = preload("res://Scenes/MainScenes/House/House.tscn")

#Projectile preload
var projectile = preload("res://Scenes/SupportScenes/Projectiles/Enemies/Projectile.tscn")
var projectile_pool = preload("res://Scenes/SupportScenes/Projectiles/Enemies/Pool.tscn")

#For player hierarchy
var ysort = preload("res://Scenes/SupportScenes/Misc/YSort.tscn")

func Init():
	current_instance_tree = ["nexus"]

var player_position
var latency_timer = 59
func _physics_process(delta):
	latency_timer += 1
	client_clock = OS.get_system_time_msecs()+latency
	
	if latency_timer % 20 == 0 and get_node("../SceneHandler").has_node(GetCurrentInstance()):
		player_position = get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player").position
	if latency_timer >= 60:
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

func _process(delta):
	if (html_network.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED ||
		html_network.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTING):
		html_network.poll();

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
		
	get_tree().connect("connection_closed ", self, "_Disconnected")
	get_tree().connect("server_close_request", self, "_Disconnected")
	get_tree().connect("connection_error", self, "_Disconnected")
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
	get_tree().connect("connected_to_server", self, "_onConnectionSucceeded")
	get_tree().connect("network_peer_disconnected", self, "_Disconnected")
	get_tree().connect("server_disconnected", self, "_Disconnected")

func _Disconnected():
	ErrorPopup.OpenPopup("Disconnected")
func _onConnectionFailed():
	ErrorPopup.OpenPopup("Connection failed")
func _onConnectionSucceeded():
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.autostart = true
	self.add_child(timer)

remote func ReturnServerTime(server_time, client_time):
	var _latency = (OS.get_system_time_msecs()-client_time)/2
	latency = server_time - client_time - _latency

remote func FetchToken():
	rpc_id(1, "ReturnToken", token, character_index)
remote func ReturnTokenVerificationResults(results):
	if(results == true):
		print("Successful token verification")
	else:
		ErrorPopup.OpenPopup("Login failed")

#Tutorial
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
remote func TutorialStep(step):
	GameUI.TutorialStep(step)

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
	get_node("../SceneHandler/"+GetCurrentInstance()).SpawnNewPlayer(player_id, spawn_position)
remote func DespawnPlayer(player_id):
	get_node("../SceneHandler/"+GetCurrentInstance()).DespawnPlayer(player_id)

#WORLD SYNCING
func SendProjectile(projectile_data):
	rpc_id(1, "SendPlayerProjectile", projectile_data)

remote func ReceivePlayerProjectile(projectile_data, instance_tree, player_id):
	if player_id == get_tree().get_network_unique_id() or instance_tree != current_instance_tree:
		return
	
	var node = get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/OtherPlayers/"+str(player_id))
	if node.projectile_dict.has(OS.get_system_time_msecs()):
		node.projectile_dict[OS.get_system_time_msecs()].append(projectile_data)
	else:
		node.projectile_dict[OS.get_system_time_msecs()] = [projectile_data]

remote func RecieveEnemyProjectile(projectile_data, instance_tree, enemy_id):
	if instance_tree != current_instance_tree:
		pass
	elif has_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/Enemies/"+str(enemy_id)):
		get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/Enemies/"+str(enemy_id)).ShootProjectile()
	if get_node("../SceneHandler/"+GetCurrentInstance()).has_node("Pool"):
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
	if has_node("../SceneHandler/"+GetCurrentInstance()+"/YSort") and get_node("../SceneHandler/"+GetCurrentInstance()).has_node("Pool"):
		for child in get_node("../SceneHandler/"+GetCurrentInstance()+"/Pool").get_children():
			if child.projectile_data and child.projectile_data.id == id:
				child.DeActivate()
				break

func SendPlayerState(player_state):
	rpc_unreliable_id(1, "RecievePlayerState", player_state)

remote func RecieveWorldState(world_state):
	if get_node("../SceneHandler/"+GetCurrentInstance()):
		get_node("../SceneHandler/"+GetCurrentInstance()).UpdateWorldState(world_state)
	
func UseAbility():
	rpc_id(1, "UseAbility")

#INSTANCES
func GetCurrentInstance():
	return current_instance_tree[current_instance_tree.size()-1]

func SendChatMessage(message):
	rpc_id(1,"RecieveChatMessage", message)
remote func RecieveChat(message,username,classname=null,id=null):
	GameUI.get_node("ChatControl").AddChat(message,username,classname,id)
remote func MovePlayer(new_position):
	get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player").position = new_position

func Nexus():
	if "nexus" == GetCurrentInstance():
		return
	rpc_id(1, "Nexus")
remote func ConfirmNexus():
	LoadingScreen.Transition("Nexus")
	yield(get_tree().create_timer(0.3), "timeout")
	var nexus_instance = nexus.instance()
	var map_instance = get_node("../SceneHandler/"+GetCurrentInstance())
	nexus_instance.get_node("YSort/player").SetCharacter(map_instance.get_node("YSort/player").character)
	
	nexus_instance.name = "nexus"
	get_node("../SceneHandler/"+GetCurrentInstance()).queue_free()
	get_node("../SceneHandler").add_child(nexus_instance)
	current_instance_tree = ["nexus"]

func EnterInstance(instance_id, portal_name):
	LoadingScreen.Transition(IdentifierToString(portal_name))
	if instance_id == GetCurrentInstance():
		return
	rpc_id(1, "EnterInstance", instance_id)

remote func UpdateHouseData(house_data):
	GameUI.account_data.home = house_data
	GameUI.get_node("Building").SetHouseData(house_data)

remote func UpdateHouseTiles(tiles):
	var house_instance = get_node("../SceneHandler/"+GetCurrentInstance())
	house_instance.UpdateTiles(tiles)
	
remote func ReturnHouseData(instance_data):
	LoadingScreen.Transition(instance_data.Name + "'s House")
	var house_instance = house_container.instance()
	var map_instance = get_node("../SceneHandler/"+GetCurrentInstance())
	
	house_instance.get_node("YSort/player").SetCharacter(map_instance.get_node("YSort/player").character)
	house_instance.get_node("YSort/player").global_position = instance_data["Position"]
	house_instance.name = instance_data["Id"]
	house_instance.PopulateHouse(instance_data)
	
	get_node("../SceneHandler").remove_child(get_node("../SceneHandler/"+GetCurrentInstance()))
	get_node("../SceneHandler").add_child(house_instance)
	current_instance_tree = ["nexus", instance_data["Id"]]

remote func ReturnDungeonData(instance_data):
	var dungeon_instance = dungeon_container.instance()
	var map_instance = get_node("../SceneHandler/"+GetCurrentInstance())
	
	dungeon_instance.get_node("YSort/player").SetCharacter(map_instance.get_node("YSort/player").character)
	dungeon_instance.get_node("YSort/player").global_position = instance_data["Position"]
	dungeon_instance.name = instance_data["Id"]
	dungeon_instance.PopulateDungeon(instance_data)
	
	get_node("../SceneHandler/"+GetCurrentInstance()).queue_free()
	get_node("../SceneHandler").add_child(dungeon_instance)
	current_instance_tree.append(instance_data["Id"])
	
remote func ReturnIslandData(instance_data):
	var island_instance = island_container.instance()
	var map_instance = get_node("../SceneHandler/"+GetCurrentInstance())

	#island_instance.GenerateIslandMap(map_data["Tiles"], map_data["Objects"])
	island_instance.get_node("YSort/player").SetCharacter(map_instance.get_node("YSort/player").character)
	island_instance.get_node("YSort/player").global_position = instance_data["Position"]
	island_instance.name = instance_data["Id"]
	
	get_node("../SceneHandler/"+GetCurrentInstance()).queue_free()
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
	get_node("../SceneHandler/"+GetCurrentInstance()).GenerateChunk(chunk_data, chunk)

#For enemies and stuff
#Called 20 times per second
func FetchChunkData(chunk):
	rpc_id(1, "FetchChunkData", chunk)
remote func ReturnChunkData(chunk_data, chunk):
	get_node("../SceneHandler/"+GetCurrentInstance()).UpdateChunk(chunk_data, chunk)

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
	get_node("../SceneHandler/"+GetCurrentInstance()).add_child(new_pool)
	get_node("../SceneHandler/"+GetCurrentInstance()).move_child(new_pool, 0)
	for i in range(amount):
		new_pool.add_child(projectile.instance())

func IdentifierToString(identifier):
	var words = identifier.split("_")
	var proper_string = ""
	for word in words:
		proper_string += word.capitalize() + " "
	proper_string = proper_string.strip_edges()
	
	return proper_string
