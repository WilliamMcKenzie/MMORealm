extends Node

var PORT = 20200
var MAX_PLAYERS = 10

func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT,MAX_PLAYERS)
	get_tree().network_peer = peer
