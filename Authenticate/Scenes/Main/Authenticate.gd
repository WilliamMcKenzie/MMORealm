extends Node

var max_players = 100
var port = 1913
var network = NetworkedMultiplayerENet.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	startServer()

func startServer():
	network.create_server(port, max_players)
	get_tree().network_peer = network
	print("Server started")
	
	get_tree().connect("network_peer_connected", self, "_Peer_Connected")
	get_tree().connect("network_peer_disconnected", self, "_Peer_Disconnected")

func _Peer_Connected(id):
	print("Gateway " + str(id) + " has connected to authentication server!")
func _Peer_Disconnected(id):
	print("Gateway " + str(id) + " has disconnected to authentication server!")


remote func AuthenticatePlayer(email, password, player_id):
	var token
	var result
	var gateway_id = get_tree().get_rpc_sender_id()
	if PlayerAuth.FetchUserData(email, password) != true:
		result = false
	else:
		result = true
		randomize()
		var random_number = randi()
		print(random_number)
		var hashed = str(random_number).sha256_text()
		print(hashed)
		var timestamp = str(OS.get_unix_time())
		print(timestamp)
		token = hashed + timestamp
		print(token)
		var gameserver = "GameServer1"
		GameServers.DistributeLogToken(token, gameserver)
	rpc_id(gateway_id, "authenticateResults", result, player_id, token)
