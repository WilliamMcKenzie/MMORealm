extends Node

var ip_address = "localhost"
var port = 1913
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

func createAccount(email, password, player_id):
	print("Sending signal...")
	rpc_id(1, "CreateAccount", email, password, player_id)

remote func returnCreateAccountRequest(result, player_id, message):
	Gateway.returnCreateAccountRequest(result, player_id, message)

func authenticatePlayer(email, password, id):
	rpc_id(1, "AuthenticatePlayer", email, password, id) 

remote func authenticateResults(result, player_id, token):
	Gateway.returnLoginRequest(player_id, result, token)

