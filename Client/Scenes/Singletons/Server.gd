extends Node

#var ip_address = "159.203.0.78"
var ip_address = "localhost"
var port = 20200
var network = NetworkedMultiplayerENet.new()

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

#Projectile preload
var projectile = preload("res://Scenes/SupportScenes/Projectiles/Enemies/Projectile.tscn")
var projectile_pool = preload("res://Scenes/SupportScenes/Projectiles/Enemies/Pool.tscn")

#For player hierarchy
var ysort = preload("res://Scenes/SupportScenes/Misc/YSort.tscn")

func _ready():
	pass
func _physics_process(delta):
	client_clock = OS.get_system_time_msecs()+latency

func UpdateRightJoystick(output):
	if get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player"):
		get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player").right_joystick_output = output.normalized()
func UpdateLeftJoystick(output):
	if get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player"):
		get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player").left_joystick_output = output.normalized()

func ConnectToServer():
	network.create_client(ip_address, port)
	get_tree().network_peer = network
	
	get_tree().connect("connection_failed", self, "_onConnectionFailed")
	get_tree().connect("connected_to_server", self, "_onConnectionSucceeded")
	get_tree().connect("network_peer_disconnected", self, "_Disconnected")

func _Disconnected():
	ErrorPopup.OpenPopup("Disconnected")
func _onConnectionFailed():
	ErrorPopup.OpenPopup("Connection failed")
func _onConnectionSucceeded():
	rpc_id(1, "FetchServerTime", OS.get_system_time_msecs())
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.autostart = true
	timer.connect("timeout", self, "DetermineLatency")
	self.add_child(timer)

func DetermineLatency():
	rpc_id(1, "DetermineLatency", OS.get_system_time_msecs())
remote func ReturnLatency(client_time):
	latency_array.append((OS.get_system_time_msecs() - client_time)/2)
	if latency_array.size() == 9:
		var total_latency = 0
		latency_array.sort()
		var mid_point = latency_array[4]
		for i in range(latency_array.size()-1-1-1):
			if latency_array[i] > (2 * mid_point) and latency_array[i] > 20:
				latency_array.remove(i)
			else:
				total_latency += latency_array[i]
		delta_latency = (total_latency / latency_array.size()) - latency
		latency = total_latency / latency_array.size()
		latency_array.clear()

remote func ReturnServerTime(server_time, client_time):
	latency = (OS.get_system_time_msecs()-client_time)/2
	client_clock = server_time+latency
	
remote func FetchToken():
	rpc_id(1, "ReturnToken", token, character_index)
remote func ReturnTokenVerificationResults(results):
	if(results == true):
		print("Successful token verification")
	else:
		ErrorPopup.OpenPopup("Login failed")

#INVENTORY/ITEMS
func SetCharacterIndex(_character_index):
	character_index = _character_index
remote func RecieveCharacterData(character):
	var player_node = get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player")
	GameUI.SetCharacterData(character)
	player_node.SetCharacter(character)

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
	get_node("../SceneHandler/"+GetCurrentInstance()).SpawnNewPlayer(player_id, spawn_position)
remote func DespawnPlayer(player_id):
	get_node("../SceneHandler/"+GetCurrentInstance()).DespawnPlayer(player_id)

#WORLD SYNCING
func SendProjectile(projectile_data):
	rpc_id(1, "SendPlayerProjectile", projectile_data)

remote func ReceivePlayerProjectile(projectile_data, instance_tree, player_id):
	if player_id == get_tree().get_network_unique_id() or instance_tree != current_instance_tree or not get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/OtherPlayers/"+str(player_id)):
		pass
	else:
		get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/OtherPlayers/"+str(player_id)).projectile_dict[OS.get_system_time_msecs()] = projectile_data

remote func RecieveEnemyProjectile(projectile_data, instance_tree, enemy_id):
	print("receieve enemy projectile")
	if instance_tree != current_instance_tree:
		pass
		print("not relevant instance tree")
	elif get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/Enemies/"+str(enemy_id)):
		print("enemy does exist")
		if get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort").has_node("Pool"):
			for i in range(get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/Pool").get_child_count()):
				if get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/Pool").get_child(i).is_active == false:
					get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/Pool").get_child(i).projectile_data = projectile_data
					get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/Pool").get_child(i).is_active = true
					print("spawned projectile")
					break
		else:
			CreatePool(projectile_pool_amount)

func SendPlayerState(player_state):
	rpc_unreliable_id(1, "RecievePlayerState", player_state)

remote func RecieveWorldState(world_state):
	get_node("../SceneHandler/"+GetCurrentInstance()).UpdateWorldState(world_state)
	
func UseAbility():
	rpc_id(1, "UseAbility")

#INSTANCES
func GetCurrentInstance():
	return current_instance_tree[current_instance_tree.size()-1]

func SendChatMessage(message):
	rpc_id(1,"RecieveChatMessage", message)
remote func RecieveChat(message,username,classname=null):
	GameUI.get_node("ChatControl").AddChat(message,username,classname)
remote func MovePlayer(new_position):
	get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player").position = new_position

func Nexus():
	if "nexus" == GetCurrentInstance():
		return
	rpc_id(1, "Nexus")
remote func ConfirmNexus():
	var nexus_instance = nexus.instance()
	var map_instance = get_node("../SceneHandler/"+GetCurrentInstance())
	
	nexus_instance.get_node("YSort/player").character = map_instance.get_node("YSort/player").character
	nexus_instance.get_node("YSort/player").stats = map_instance.get_node("YSort/player").stats
	nexus_instance.get_node("YSort/player").gear = map_instance.get_node("YSort/player").gear
	
	nexus_instance.name = "nexus"
	get_node("../SceneHandler/"+GetCurrentInstance()).queue_free()
	get_node("../SceneHandler").add_child(nexus_instance)
	current_instance_tree = ["nexus"]
func EnterInstance(instance_id):
	if instance_id == GetCurrentInstance():
		return
	rpc_id(1, "EnterInstance", instance_id)
	
remote func ReturnDungeonData(instance_data):
	var dungeon_instance = dungeon_container.instance()
	var map_instance = get_node("../SceneHandler/"+GetCurrentInstance())
	
	dungeon_instance.get_node("YSort/player").character = map_instance.get_node("YSort/player").character
	dungeon_instance.get_node("YSort/player").stats = map_instance.get_node("YSort/player").stats
	dungeon_instance.get_node("YSort/player").gear = map_instance.get_node("YSort/player").gear
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
	island_instance.get_node("YSort/player").character = map_instance.get_node("YSort/player").character
	island_instance.get_node("YSort/player").stats = map_instance.get_node("YSort/player").stats
	island_instance.get_node("YSort/player").gear = map_instance.get_node("YSort/player").gear
	island_instance.get_node("YSort/player").global_position = instance_data["Position"]
	island_instance.name = instance_data["Id"]
	
	get_node("../SceneHandler/"+GetCurrentInstance()).queue_free()
	get_node("../SceneHandler").add_child(island_instance)
	current_instance_tree.append(instance_data["Id"])

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
	print("Dead")

remote func SetHealth(max_health, current_health):
	GameUI.ChangeHealth(max_health, current_health)

func NPCHit(enemy_id, damage):
	rpc_id(1, "NPCHit", enemy_id, damage)
	
func CreatePool(amount):
	var new_pool = projectile_pool.instance()
	get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort").add_child(new_pool)
	for i in range(amount):
		new_pool.add_child(projectile.instance())
