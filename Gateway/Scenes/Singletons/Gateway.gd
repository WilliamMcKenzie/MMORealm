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

	network.connect("network_peer_connected", self, "_Peer_Connected")
	network.connect("network_peer_disconnected", self, "_Peer_Disconnected")


func _Peer_Connected(id):
	print("User " + str(id) + " has connected!")
func _Peer_Disconnected(id):
	print("User " + str(id) + " has disconnected!")

remote func LoginRequest(username, password):
	pass
func ReturnLoginRequest(result, player_id):
	pass
