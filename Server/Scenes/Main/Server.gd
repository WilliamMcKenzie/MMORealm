extends Node

var max_players = 100
var port = 20200
var network = NetworkedMultiplayerENet.new()

var expected_tokens = []

var player_state_collection = {}
var objects_state_collection = {}



func _ready():
	StartServer()
	CreateInstance("test_dungeon", "nexus", Vector2.ZERO)
	CreateInstance("test_dungeon", "nexus", Vector2(50, 20))
func StartServer():
	network.create_server(port, max_players)
	get_tree().network_peer = network
	
	get_tree().connect("network_peer_connected", self, "_Peer_Connected")
	get_tree().connect("network_peer_disconnected", self, "_Peer_Disconnected")
	

func _Peer_Connected(id):
	print("User " + str(id) + " has connected!")
	PlayerVerification.Start(id)
func _Peer_Disconnected(id):
	print("User " + str(id) + " has disconnected!")
	if(get_parent().has_node(str(id))):	
		get_parent().get_node(str(id)).queue_free()
		player_state_collection.erase(id)
		rpc_id(0, "DespawnPlayer", id)

remote func FetchPlayerData():
	var player_id = get_tree().get_rpc_sender_id()
	var player_data = get_parent().get_node(str(player_id)).getPlayerData()
	rpc_id(player_id, "ReturnPlayerData", player_data)

#PLAYER SYNCING
remote func RecievePlayerState(player_state):
	var player_id = get_tree().get_rpc_sender_id()
	if player_state_collection.has(player_id):
		if(player_state_collection[player_id]["T"] <  player_state["T"]):
			player_state["I"] = player_state_collection[player_id]["I"]
			player_state_collection[player_id] = player_state
	else:
		player_state["I"] = "nexus"
		player_state_collection[player_id] = player_state
func SendWorldState(world_state):
	rpc_unreliable_id(0, "RecieveWorldState", world_state)

#TOKENS
func _on_TokenExpiration_timeout():
	var current_time = OS.get_unix_time()
	var token_time
	if expected_tokens == []:
		pass
	else:
		for i in range(expected_tokens.size() -1, -1, -1):
			token_time = int(expected_tokens[i].right(64))
			if current_time - token_time >= 30:
				expected_tokens.remove(i)

#Make sure if players manually set tokens to expire say a year from now, they still get kicked
func _on_VerificationExpiration_timeout():
	PlayerVerification.VerificationExpiration()

func FetchToken(player_id):
	rpc_id(player_id, "FetchToken")

remote func ReturnToken(token):
	var player_id = get_tree().get_rpc_sender_id()
	PlayerVerification.Verify(player_id, token)

func ReturnTokenVerificationResults(player_id, result):
	rpc_id(player_id, "ReturnTokenVerificationResults", result)
	if result == true:
		rpc_id(0, "SpawnNewPlayer", player_id, Vector2(79, 56))

#DUNGEON INSTANCES
func CreateInstance(instance_name, parent_instance, portal_position):
	var instance_id = generate_unique_id()
	var instance_map = Dungeons.GenerateDungeon(instance_name)
	if get_node("Instances").has_node(parent_instance):
		var instance = load("res://Scenes/Instances/Dungeons/Dungeon.tscn").instance()
		instance.name = instance_id
		instance.map = instance_map
		get_node("Instances/"+parent_instance).add_child(instance)
		objects_state_collection[instance_id] = {"T": OS.get_system_time_msecs(), "P": portal_position, "I": str(parent_instance), "N":instance_name, "Type":"DungeonPortals"}

func generate_unique_id():
	var timestamp = OS.get_unix_time()
	var random_value = randi()
	return (str(timestamp) + "_" + str(random_value)).sha256_text()

remote func Nexus():
	var player_id = get_tree().get_rpc_sender_id()
	var previous_instance = player_state_collection[player_id]["I"]
	player_state_collection[player_id] = {"T": OS.get_system_time_msecs(), "P": Vector2.ZERO, "A": "Idle", "I": "nexus"}
	rpc_id(player_id, "ConfirmNexus")
remote func EnterInstance(instance_id):
	var player_id = get_tree().get_rpc_sender_id()
	print("Instance request recieved")
	print(instance_id)
	if get_node("Instances/"+player_state_collection[player_id]["I"]).has_node(instance_id):
		print("Changed instance")
		var previous_instance = player_state_collection[player_id]["I"]
		player_state_collection[player_id] = {"T": OS.get_system_time_msecs(), "P": Vector2.ZERO, "A": "Idle", "I": str(instance_id)}
		rpc_id(player_id, "ReturnInstanceData", { "Map":get_node("Instances/"+previous_instance+"/"+instance_id).map, "Name":objects_state_collection[instance_id]["N"], "Id":instance_id})

remote func RecieveChatMessage(message):
	if message[0] == "/":
		if message[1] == "d":
			CreateInstance(message.substr(3,-1),player_state_collection[get_tree().get_rpc_sender_id()]["I"],player_state_collection[get_tree().get_rpc_sender_id()]["P"])
	else:
		print("server has recieved message : " + message)
		rpc("RecieveChat", message,str(get_tree().get_rpc_sender_id()))
