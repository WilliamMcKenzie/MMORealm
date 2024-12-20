extends Node

var max_players = 100
var port = 20201

var network = NetworkedMultiplayerENet.new()
var html_network = WebSocketServer.new()
var current_network

var gateway_api = MultiplayerAPI.new()
var gateway_html_api = MultiplayerAPI.new()
var player_id_by_email = {}

func _ready():
	VisualServer.render_loop_enabled = false
	current_network = html_network
	#StartServer()
	StartHTMLServer()

func _process(delta):
	if not custom_multiplayer or not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()

func StartHTMLServer():
	var result = html_network.listen(port, PoolStringArray(), true);
	if result != OK:
		print("Failed to start server:", result)
	else:
		print("Server is running on port", port)
	
	get_tree().set_network_peer(html_network);
	set_custom_multiplayer(gateway_html_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(html_network)

	custom_multiplayer.connect("network_peer_connected", self, "_Peer_Connected")
	custom_multiplayer.connect("network_peer_disconnected", self, "_Peer_Disconnected")

#This startserver func is now legacy, somehow html server works for mobile clients as well
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

remote func KeepAlive():
	rpc_id(custom_multiplayer.get_rpc_sender_id(), "StillAlive")

remote func FetchAccountData(email, password):
	var player_id = custom_multiplayer.get_rpc_sender_id()
	player_id_by_email[email] = player_id
	Authenticate.GenericRequest(email.to_lower(), password, player_id, "FetchAccountData")

func ReturnAccountData(account_data, player_id):
	rpc_id(player_id, "ReturnAccountData", account_data)

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

remote func ReviveCharacter(index, email, password):
	var player_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.ReviveCharacter(index, email, password, player_id)

remote func VerifyPurchase(token,type,value,username):
	Authenticate.VerifyPurchase(token,type,value,username)
