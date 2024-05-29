extends Node

var ip_address = "localhost"
var port = 20200
var network = NetworkedMultiplayerENet.new()

var token
# Called when the node enters the scene tree for the first time.
func _ready():
	connectToServer()

func connectToServer():
	network.create_client(ip_address, port)
	get_tree().network_peer = network
	
	get_tree().connect("connection_failed", self, "_onConnectionFailed")
	get_tree().connect("connected_to_server", self, "_onConnectionSucceeded")

func _onConnectionFailed():
	print("Connection failed.")
	
func _onConnectionSucceeded():
	print("Connection succeeded!")

func fetchPlayerData():
	rpc_id(1, "FetchPlayerData")
	
remote func returnCharacterSpawnPosition(pos):
	get_node("/root/SceneHandler/Map/YSort/player").position = pos

func sendPlayerJoined(pos):
	#rpc_id(1, "fetchPlayerJoined", pos)
	#pass for now

remote func returnPlayerData(player_data):
	get_node("/root/SceneHandler/Home").selectionScreen(player_data)

remote func spawnOtherPlayers(player_data):
	pass
	# fires every time the state of the other players needs to be updated on the client
	# player_data will be an array of all the player_conatainers currently in the game
	# create a new res://Scenes/SupportScenes/OtherPlayers/OtherPlayer.tscn object that gets manipulated by this function
