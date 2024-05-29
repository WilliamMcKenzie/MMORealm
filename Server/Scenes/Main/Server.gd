extends Node

var max_players = 100
var port = 20200
var network = NetworkedMultiplayerENet.new()

var expected_tokens = ["c07bdbcb2e25664a5567c38f121e0f38f27b0720886b4e3ccada1315128a710c1716997784"]

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
	PlayerVerification.start(id)
func _Peer_Disconnected(id):
	print("User " + str(id) + " has disconnected!")
	get_parent().get_node(str(id)).queue_free()

remote func FetchPlayerData():
	var player_id = get_tree().get_rpc_sender_id()
	var player_data = get_parent().get_node(str(player_id)).getPlayerData()
	rpc_id(player_id, "returnPlayerData", player_data)
	
remote func fetchCharacterSpawnPosition():
	#LATER WE WILL DEFINE SPAWN POSITIONS, maybe pick one with least people nearby. for now 55,11
	var requester_id = get_tree().get_rpc_sender_id()
	rpc_id(requester_id, "returnCharacterSpawnPosition", Vector2(55, 11))
	var player_container = get_parent().get_node(str(requester_id))
	var player_character = player_container.get_node("player_character")
	player_character.position = Vector2(55, 11)

remote func fetchPlayerKeyPress(k):
	
	var player_id = get_tree().get_rpc_sender_id()
	var player_data = get_parent().get_node(str(player_id))
	
	if k == "up":
		player_data.moveVector.y += 1
	if k == "down":
		player_data.moveVector.y -= 1
	if k == "right":
		player_data.moveVector.x += 1
	if k == "left":
		player_data.moveVector.x -= 1
	
remote func fetchPlayerKeyRelease(k):

	var player_id = get_tree().get_rpc_sender_id()
	var player_data = get_parent().get_node(str(player_id))
	
	if k == "up":
		player_data.moveVector.y -= 1
	if k == "down":
		player_data.moveVector.y += 1
	if k == "right":
		player_data.moveVector.x -= 1
	if k == "left":
		player_data.moveVector.x += 1
	

func _physics_process(_delta):
	for i in(get_tree().get_network_connected_peers()):
		var player_container = get_parent().get_node(str(i))
		var player_character = player_container.get_node("player_character")
		player_container.moveVector = player_container.moveVector.normalized()
		player_character.moveCharacterBody(player_container.moveVector * get_parent().get_node(str(i)).characters[player_container.currentCharacterIndex].stats.speed)
		print(player_character.position)
