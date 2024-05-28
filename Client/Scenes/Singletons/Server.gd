extends Node

var ip_address = "localhost"
var port = 20200
var network = NetworkedMultiplayerENet.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	connectToServer()

func connectToServer():
	network.create_client(ip_address, port)
	get_tree().network_peer = network
	
	get_tree().connect("connection_failed", self, "_onConnectionFailed")
	get_tree().connect("connected_to_server", self, "_onConnectionSucceeded")

func _onConnectionFailed():
	print("Connection failed.")
	
func _onConnectionSucceeded():
	print("Connection succeeded!")

func fetchPlayerData():
	rpc_id(1, "FetchPlayerData")

func sendKeyPress(k):
	rpc_id(1, "fetchPlayerKeyPress", k)

func sendKeyRelease(k):
	rpc_id(1, "fetchPlayerKeyRelease",k)

remote func returnPlayerData(player_data):
	get_node("/root/SceneHandler/Home").selectionScreen(player_data)


