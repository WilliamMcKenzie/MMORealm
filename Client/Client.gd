extends Node2D


onready var clientButton = $Client
onready var serverButton = $Server
var MAX_PLAYERS = 10
var PORT = 20200

var serverId
var infoBank = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	clientButton.connect("pressed", self, "connectClient")
	serverButton.connect("pressed", self, "createServer")

func connectClient():
	var mychar = load("res://PlayerCharacter/Player.tscn")
	var player_instance = mychar.instance()
	player_instance.scale.x = 4
	player_instance.scale.y = 4
	add_child(player_instance)
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client("localhost", PORT)
	get_tree().network_peer = peer

remote func print_hello():
	print("WASSSUP")
