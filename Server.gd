extends Node


var MAX_PLAYERS = 10
var PORT = 20200

# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_tree().get_network_peer())
	
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	print(get_tree().is_network_server())
	rpc("print_once_per_client")
func print_once_per_client():
	print("I will be printed to the console once per each connected client.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
