extends Node

var max_players = 100
var port = 20201
var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()

func _ready():
	StartServer()

func _process(delta):
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()

func StartServer():
	network.create_server(port, max_players)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)

	custom_multiplayer.connect("network_peer_connected", self, "_Peer_Connected")
	custom_multiplayer.connect("network_peer_disconnected", self, "_Peer_Disconnected")

func _Peer_Connected(id):
	print("User " + str(id) + " has connected!")
func _Peer_Disconnected(id):
	print("User " + str(id) + " has disconnected!")

remote func FetchAccountData(email, password):
	var player_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.GenericRequest(email.to_lower(), password, player_id, "FetchAccountData")
func ReturnAccountData(account_data, player_id):
	rpc_id(player_id, "ReturnAccountData", account_data)
	network.disconnect_peer(player_id)

remote func BuyCharacterSlot(email, password):
	var player_id = custom_multiplayer.get_rpc_sender_id()
	var valid_request = true
	if(email == ""):
		valid_request = false
	if(password == ""):
		valid_request = false
	if(password.length() < 7):
		valid_request = false
	if valid_request == false:
		ReturnBuyCharacterSlotRequest(valid_request, player_id)
	else:
		Authenticate.GenericRequest(email.to_lower(), password, player_id, "BuyCharacterSlot")
func ReturnBuyCharacterSlotRequest(result, player_id):
	rpc_id(player_id, "ReturnBuyCharacterSlotRequest", result)
	network.disconnect_peer(player_id)

remote func CreateCharacter(email, password):
	var player_id = custom_multiplayer.get_rpc_sender_id()
	var valid_request = true
	if(email == ""):
		valid_request = false
	if(password == ""):
		valid_request = false
	if(password.length() < 7):
		valid_request = false
	if valid_request == false:
		ReturnCreateCharacterRequest(valid_request, null, player_id)
	else:
		print("Request accepted")
		Authenticate.GenericRequest(email.to_lower(), password, player_id, "CreateCharacter")
func ReturnCreateCharacterRequest(result, new_character, player_id):
	rpc_id(player_id, "ReturnCreateCharacterRequest", result, new_character)
	network.disconnect_peer(player_id)

remote func CreateAccountRequest(email, password):
	var player_id = custom_multiplayer.get_rpc_sender_id()
	var valid_request = true
	if(email == ""):
		valid_request = false
	if(password == ""):
		valid_request = false
	if(password.length() < 7):
		valid_request = false
	if valid_request == false:
		ReturnCreateAccountRequest(valid_request, player_id, 1)
	else:
		print("Request accepted")
		Authenticate.GenericRequest(email.to_lower(), password, player_id, "CreateAccount")
func ReturnCreateAccountRequest(result, player_id, message):
	rpc_id(player_id, "ReturnCreateAccountRequest", result, message)
	network.disconnect_peer(player_id)

remote func LoginRequest(email, password):
	var player_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.AuthenticatePlayer(email, password, player_id)
func ReturnLoginRequest(player_id, result):
	rpc_id(player_id, "ReturnLogin", result)

remote func GetLeaderboards():
	var player_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.GetLeaderboards(player_id)
func ReturnLeaderboardsResult(weekly, monthly, all_time, player_id):
	rpc_id(player_id, "ReturnLeaderboards", weekly, monthly, all_time)
	
remote func SendToken(email):
	var player_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.SendToken(email, player_id)
func ReturnToken(token, player_id):
	rpc_id(player_id, "ReturnToken", token)
