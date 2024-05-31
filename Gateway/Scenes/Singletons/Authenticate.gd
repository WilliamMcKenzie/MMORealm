extends Node

var ip_address = "localhost"
var port = 1913
var network = NetworkedMultiplayerENet.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	ConnectToServer()

func ConnectToServer():
	network.create_client(ip_address, port)
	get_tree().network_peer = network
	
	get_tree().connect("connection_failed", self, "_onConnectionFailed")
	get_tree().connect("connected_to_server", self, "_onConnectionSucceeded")

func _onConnectionFailed():
	print("Authentication server connection failed.")
	
func _onConnectionSucceeded():
	print("Authentication server connection succeeded!")

func CreateAccount(email, password, player_id):
	print("Sending signal...")
	rpc_id(1, "CreateAccount", email, password, player_id)

remote func ReturnCreateAccountRequest(result, player_id, message):
	Gateway.ReturnCreateAccountRequest(result, player_id, message)

func AuthenticatePlayer(email, password, id):
	rpc_id(1, "AuthenticatePlayer", email, password, id) 

remote func AuthenticateResults(result, player_id, token):
	Gateway.ReturnLoginRequest(player_id, result, token)

