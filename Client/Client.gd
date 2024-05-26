extends Node


var IP_ADDRESS = "127.0.0.1"
var PORT = 20200

# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_tree().get_network_peer())
	
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(IP_ADDRESS, PORT
	get_tree().network_peer = peer
	print(get_tree().is_network_server())
