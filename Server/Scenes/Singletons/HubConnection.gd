extends Node

#var ip = "159.203.0.78"
var ip = "localhost"
var port = 1912
var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()

onready var gameserver = get_node("/root/Server")

# Called when the node enters the scene tree for the first time.
func _ready():
	ConnectToServer()

func _process(delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()

func ConnectToServer():
	network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)

	custom_multiplayer.connect("connection_failed", self, "_onConnectionFailed")
	custom_multiplayer.connect("connected_to_server", self, "_onConnectionSucceeded")

func _onConnectionFailed():
	print("Connection failed, gateway server down.")
	
func _onConnectionSucceeded():
	print("Connection succeeded!")

remote func RecieveLoginToken(token, email):
	gameserver.expected_tokens[token] = email
	
func GetAccountData(player_id, email):
	rpc_id(1, "GetAccountData", player_id, email)

remote func ReturnAccountData(player_id, account_data):
	if not get_node("/root/Server").player_state_collection.has(player_id):
		get_node("/root/Server").network.disconnect_peer(int(player_id))
		return
	
	var instance_tree = get_node("/root/Server").player_state_collection[player_id]["I"]
	get_node("/root/Server").player_name_by_id[player_id] = account_data.username
	get_node("/root/Server").player_id_by_name[account_data.username] = player_id
	get_node("/root/Server/Instances/"+get_node("/root/Server").StringifyInstanceTree(instance_tree)).player_list[str(player_id)].name = account_data.username
	get_node("/root/Server/Instances/"+get_node("/root/Server").StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id)).account_data = account_data
	get_node("/root/Server/Instances/"+get_node("/root/Server").StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id)).SetCharacter(account_data.characters)
	get_node("/root/Server/Instances/nexus/house " + str(player_id)).SetHouseData(account_data)
	if not account_data.finished_tutorial:
		get_node("/root/Server").StartTutorial(player_id)

func UpdateCharacterData(email, character_data, character_index):
	rpc_id(1, "UpdateCharacterData", email, character_data, character_index)
func UpdateAccountData(email, account_data):
	rpc_id(1, "UpdateAccountData", email, account_data)
	
func UpdateLeaderboard(username, character_data):
	var character = { "gear" : character_data.gear, "class" : character_data.class, "level" : character_data.level}
	rpc_id(1, "UpdateLeaderboard", username, character)

func ConfirmUsername(username, player_id):
	rpc_id(1, "ConfirmUsername", username, player_id)
remote func ReturnUsernameConfirmation(result, username, player_id):
	get_node("/root/Server").ConfirmUsername(result, username, player_id)
