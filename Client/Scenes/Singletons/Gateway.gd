extends Node

var ip = "localhost"
var port = 20201
var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()

var username
var password

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
	

func startServer():
	network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)

	get_tree().connect("connection_failed", self, "_onConnectionFailed")
	get_tree().connect("connected_to_server", self, "_onConnectionSucceeded")

func _onConnectionFailed():
	print("Connection failed.")
	
func _onConnectionSucceeded():
	print("Connection succeeded!")

func fetchProjectileData(skill_name, requester_id):
	rpc_id(1, "FetchProjectileData", skill_name, requester_id)

remote func returnProjectileData(skill_data, requester_id):
	instance_from_id(requester_id).SetData(skill_data)
