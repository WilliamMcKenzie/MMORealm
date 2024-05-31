extends Node

var max_players = 100
var port = 20201
var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	startServer()

func _process(delta):
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
	

func startServer():
	network.create_server(port, max_players)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)

	custom_multiplayer.connect("network_peer_connected", self, "_Peer_Connected")
	custom_multiplayer.connect("network_peer_disconnected", self, "_Peer_Disconnected")


func _Peer_Connected(id):
	print("User " + str(id) + " has connected!")
func _Peer_Disconnected(id):
	print("User " + str(id) + " has disconnected!")

remote func createAccountRequest(email, password):
	print("Processing Request...")
	var player_id = custom_multiplayer.get_rpc_sender_id()
	print("sender id:" + str(player_id))
	var valid_request = true
	if(email == ""):
		valid_request = false
	if(password == ""):
		valid_request = false
	if(password.length() < 7):
		valid_request = false
	if valid_request == false:
		print("Request rejected")
		returnCreateAccountRequest(valid_request, player_id, 1)
	else:
		print("Request accepted")
		Authenticate.createAccount(email.to_lower(), password, player_id)
func returnCreateAccountRequest(result, player_id, message):
	print("Result: " + str(result))
	rpc_id(player_id, "returnCreateAccountRequest", result, message)
	network.disconnect_peer(player_id)
	print("Disconnected Player: " + str(player_id))

remote func loginRequest(email, password):
	var player_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.authenticatePlayer(email, password, player_id)
func returnLoginRequest(player_id, result, token):
	rpc_id(player_id, "returnLogin", result, token)

