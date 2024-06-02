extends Node

var ip_address = "localhost"
var port = 20200
var network = NetworkedMultiplayerENet.new()

var token

#Map preloads
var current_instance_tree = ["nexus"]
var nexus = preload("res://Scenes/MainScenes/nexus.tscn")
var dungeon_container = preload("res://Scenes/MainScenes/dungeon_container.tscn")

func _ready():
	pass

func ConnectToServer():
	network.create_client(ip_address, port)
	get_tree().network_peer = network
	
	get_tree().connect("connection_failed", self, "_onConnectionFailed")
	get_tree().connect("connected_to_server", self, "_onConnectionSucceeded")

func _onConnectionFailed():
	print("Connection failed.")
func _onConnectionSucceeded():
	print("Connection succeeded!")
	
remote func FetchToken():
	rpc_id(1, "ReturnToken", token)
remote func ReturnTokenVerificationResults(results):
	if(results == true):
		print("Successful token verification")
	else:
		print("Login failed")

#PLAYER SPAWNING
remote func SpawnNewPlayer(player_id, spawn_position):
	get_node("../SceneHandler/"+GetCurrentInstance()).SpawnNewPlayer(player_id, spawn_position)
remote func DespawnPlayer(player_id):
	get_node("../SceneHandler/"+GetCurrentInstance()).DespawnPlayer(player_id)

#WORLD SYNCING
func SendProjectile(projectile_data):
	rpc_id(1, "SendProjectile", projectile_data)
remote func ReceiveProjectile(projectile_data, instance_tree, player_id):
	if player_id == get_tree().get_network_unique_id() or instance_tree != current_instance_tree:
		pass
	else:
		get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/OtherPlayers/"+str(player_id)).projectile_dict[OS.get_system_time_msecs()] = projectile_data
	
func SendPlayerState(player_state):
	rpc_unreliable_id(1, "RecievePlayerState", player_state)
remote func RecieveWorldState(world_state):
	get_node("../SceneHandler/"+GetCurrentInstance()).UpdateWorldState(world_state)
	
#INSTANCES
func GetCurrentInstance():
	return current_instance_tree[current_instance_tree.size()-1]

func SendChatMessage(message):
	rpc_id(1,"RecieveChatMessage", message)
remote func RecieveChat(message,plr):
	GameUI.get_node("ChatControl").AddChat(message,plr)

func Nexus():
	if "nexus" == GetCurrentInstance():
		return
	rpc_id(1, "Nexus")
remote func ConfirmNexus():
	var nexus_instance = nexus.instance()
	var map_instance = get_node("../SceneHandler/"+GetCurrentInstance())
	nexus_instance.get_node("YSort/player").level = map_instance.get_node("YSort/player").level
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
remote func ReturnInstanceData(instance_data):
	var dungeon_instance = dungeon_container.instance()
	var map_instance = get_node("../SceneHandler/"+GetCurrentInstance())
	dungeon_instance.get_node("YSort/player").level = map_instance.get_node("YSort/player").level
	dungeon_instance.get_node("YSort/player").stats = map_instance.get_node("YSort/player").stats
	dungeon_instance.get_node("YSort/player").gear = map_instance.get_node("YSort/player").gear
	dungeon_instance.name = instance_data["Id"]
	dungeon_instance.PopulateDungeon(instance_data)
	get_node("../SceneHandler/"+GetCurrentInstance()).queue_free()
	get_node("../SceneHandler").add_child(dungeon_instance)
	current_instance_tree.append(instance_data["Id"])
	
#ENEMIES
func NPCHit(enemy_id, damage):
	rpc_id(1, "NPCHit", enemy_id, current_instance_tree, damage)
