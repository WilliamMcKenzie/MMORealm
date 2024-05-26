extends Node

var PORT = 20200
var IP_ADDRESS = "127.0.0.1"


# Called when the node enters the scene tree for the first time.
func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(IP_ADDRESS, PORT)
	get_tree().network_peer = peer
	
	get_tree().connect("connected_to_server", self, "_connected_ok")
	
	print("poop")
	
func _connected_ok():
	print("connected to localhost")
