extends Node

#var ip_address = "138.197.146.70"
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

func GenericRequest(email, password, player_id, destination):
	rpc_id(1, destination, email, password, player_id)

remote func ReturnAccountData(account_data, player_id):
	Gateway.ReturnAccountData(account_data, player_id)

remote func ReturnBuyCharacterSlotRequest(result, player_id):
	Gateway.ReturnBuyCharacterSlotRequest(result, player_id)

remote func ReturnCreateCharacterRequest(result, new_character, player_id):
	Gateway.ReturnCreateCharacterRequest(result, new_character, player_id)

remote func ReturnCreateAccountRequest(result, player_id, message):
	Gateway.ReturnCreateAccountRequest(result, player_id, message)

func AuthenticatePlayer(email, password, id):
	rpc_id(1, "AuthenticatePlayer", email, password, id) 
remote func AuthenticateResults(result, player_id, token):
	Gateway.ReturnLoginRequest(player_id, result, token)

