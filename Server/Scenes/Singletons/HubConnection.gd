extends Node

#var ip = "138.197.146.70"
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
	
func GetAccountData(player_id, email, instance_tree):
	rpc_id(1, "GetAccountData", player_id, email, instance_tree)

remote func ReturnAccountData(player_id, instance_tree, account_data):
	get_node("/root/Server/Instances/"+get_node("/root/Server").StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id)).SetCharacter(account_data.characters)
