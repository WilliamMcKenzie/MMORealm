extends Node2D


onready var clientButton = $Client
onready var serverButton = $Server
var MAX_PLAYERS = 10
var PORT = 20200

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready")
	clientButton.connect("pressed", self, "connectClient")
	serverButton.connect("pressed", self, "createServer")

func connectClient():
	print("Connection")
	var mychar = load("res://PlayerCharacter/Player.tscn")
	var player_instance = mychar.instance()
	add_child(player_instance)
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client("localhost", PORT)
	print("client connected")
	rpc("say_hello")

func createServer():
	print("Creation")
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, MAX_PLAYERS)
	get_tree().network_peer = peer

func say_hello():
	print("hello")
