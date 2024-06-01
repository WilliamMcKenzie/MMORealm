extends Node

var ip_address = "localhost"
var port = 20200
var network = NetworkedMultiplayerENet.new()

var token

#Map preloads
var current_instance = "nexus"
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
	get_node("../SceneHandler/"+current_instance).SpawnNewPlayer(player_id, spawn_position)
remote func DespawnPlayer(player_id):
	get_node("../SceneHandler/"+current_instance).DespawnPlayer(player_id)

#WORLD SYNCING
func SendPlayerState(player_state):
	rpc_unreliable_id(1, "RecievePlayerState", player_state)
remote func RecieveWorldState(world_state):
	get_node("../SceneHandler/"+current_instance).UpdateWorldState(world_state)
	
#INSTANCES
func SendChatMessage(message):
	rpc_id(1,"RecieveChatMessage", message)
remote func RecieveChat(message,plr):
	get_node("../SceneHandler/"+current_instance+"/YSort/player/ChatControl").AddChat(message,plr)

func Nexus():
	if "nexus" == current_instance:
		return
	rpc_id(1, "Nexus")
remote func ConfirmNexus():
	var nexus_instance = nexus.instance()
	var map_instance = get_node("../SceneHandler/"+current_instance)
	nexus_instance.get_node("YSort/player").level = map_instance.get_node("YSort/player").level
	nexus_instance.get_node("YSort/player").stats = map_instance.get_node("YSort/player").stats
	nexus_instance.get_node("YSort/player").gear = map_instance.get_node("YSort/player").gear
	nexus_instance.name = "nexus"
	get_node("../SceneHandler/"+current_instance).queue_free()
	get_node("../SceneHandler").add_child(nexus_instance)
	current_instance = "nexus"
func EnterInstance(instance_id):
	if instance_id == current_instance:
		return
	rpc_id(1, "EnterInstance", instance_id)
remote func ReturnInstanceData(instance_data):
	var dungeon_instance = dungeon_container.instance()
	var map_instance = get_node("../SceneHandler/"+current_instance)
	dungeon_instance.get_node("YSort/player").level = map_instance.get_node("YSort/player").level
	dungeon_instance.get_node("YSort/player").stats = map_instance.get_node("YSort/player").stats
	dungeon_instance.get_node("YSort/player").gear = map_instance.get_node("YSort/player").gear
	dungeon_instance.name = instance_data["Id"]
	dungeon_instance.PopulateDungeon(instance_data)
	get_node("../SceneHandler/"+current_instance).queue_free()
	get_node("../SceneHandler").add_child(dungeon_instance)
	current_instance = instance_data["Id"]
