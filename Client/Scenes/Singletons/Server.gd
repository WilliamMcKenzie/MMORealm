extends Node

var ip_address = "localhost"
var port = 20200
var network = NetworkedMultiplayerENet.new()

var token

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
	get_node("../SceneHandler/Map").SpawnNewPlayer(player_id, spawn_position)
remote func DespawnPlayer(player_id):
	get_node("../SceneHandler/Map").DespawnPlayer(player_id)

#WORLD SYNCING
func SendPlayerState(player_state):
	rpc_unreliable_id(1, "RecievePlayerState", player_state)
remote func RecieveWorldState(world_state):
	get_node("../SceneHandler/Map").UpdateWorldState(world_state)
	
func SendChatMessage(message):
	rpc_id(1,"RecieveChatMessage", message)
remote func RecieveChat(message):
	get_parent().get_node("SceneHandler/Map/YSort/player/ChatControl").AddChat(message)
