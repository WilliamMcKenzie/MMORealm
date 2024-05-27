extends Node

var max_players = 100
var port = 20200
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
	print("User " + str(id) + " has connected!")
func _Peer_Disconnected(id):
	print("User " + str(id) + " has disconnected!")

remote func FetchProjectileData(skill_name, requester_id):
	var player_id = get_tree().get_rpc_sender_id()
	var data = Combat.FetchProjectileData(skill_name)
	rpc_id(player_id, "returnProjectileData", data, requester_id)
