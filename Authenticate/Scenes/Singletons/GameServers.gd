extends Node

var max_players = 100
var port = 1912
var network = NetworkedMultiplayerENet.new()
var gameserver_api = MultiplayerAPI.new()

var gameserverlist = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	startServer()

func _process(delta):
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()

func startServer():
	network.create_server(port, max_players)
	set_custom_multiplayer(gameserver_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	print("Gameserver hub started")

	custom_multiplayer.connect("network_peer_connected", self, "_Peer_Connected")
	custom_multiplayer.connect("network_peer_disconnected", self, "_Peer_Disconnected")


func _Peer_Connected(id):
	print("Game server " + str(id) + " has connected!")
	gameserverlist["GameServer1"] = id
	print(gameserverlist)
func _Peer_Disconnected(id):
	print("Game server " + str(id) + " has disconnected!")

func DistributeLogToken(token, gameserver):
	var gameserver_peer_id = gameserverlist[gameserver]
	rpc_id(gameserver_peer_id, "RecievingLoginToken", token)


