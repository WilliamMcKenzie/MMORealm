extends Node

var ip_address = "localhost"
var port = 1912
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
	print("Authentication server connection failed.")
	
func _onConnectionSucceeded():
	print("Authentication server connection succeeded!")

func authenticatePlayer(email, password, id):
	rpc_id(1, "AuthenticatePlayer", email, password, id) 

remote func authenticateResults(player_id, result):
	Gateway.returnLoginRequest(player_id, result)
