extends Node


var MAX_PLAYERS = 10	
var PORT = 20200
remote var printme = "HELLO"

# Called when the node enters the scene tree for the first time.
func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	get_tree().connect("network_peer_connected", self, "_player_connected")

func _player_connected():
	rpc("print_hello")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(get_tree().get_network_connected_peers())
