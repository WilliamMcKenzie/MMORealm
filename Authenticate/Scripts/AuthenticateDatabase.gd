extends Node

var max_players = 100
var port = 1913
var network = NetworkedMultiplayerENet.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	StartServer()

func StartServer():
	network.create_server(port, max_players)
	get_tree().network_peer = network
	print("Server started")
	
	get_tree().connect("network_peer_connected", self, "_Peer_Connected")
	get_tree().connect("network_peer_disconnected", self, "_Peer_Disconnected")

func _Peer_Connected(id):
	print("Gateway " + str(id) + " has connected to authentication server!")
func _Peer_Disconnected(id):
	print("Gateway " + str(id) + " has disconnected to authentication server!")

remote func FetchAccountData(email, password, player_id):
	var verification = DatabaseInterface.VerifyUser(email, password)
	if not verification:
		return
	
	var gateway_id = get_tree().get_rpc_sender_id()
	var account_data = DatabaseInterface.FindUser(email).account_data
	
	rpc_id(gateway_id, "ReturnAccountData", account_data, player_id)

remote func BuyCharacterSlot(email, password, player_id):
	var verification = DatabaseInterface.VerifyUser(email, password)
	if not verification:
		return
	
	var gateway_id = get_tree().get_rpc_sender_id()
	var result = false
	var account_data = DatabaseInterface.FindUser(email).account_data
	
	var character_slots = account_data.character_slots
	var gold = account_data.gold
	
	var price = 500 + (character_slots*200)
	
	if gold > price:
		result = true
		account_data.character_slots += 1
		account_data.gold -= price
		DatabaseInterface.UpdateUser(email, account_data)
	rpc_id(gateway_id, "ReturnBuyCharacterSlotRequest", result, player_id)

func generate_unique_id():
	var timestamp = OS.get_unix_time()
	var random_value = randi()
	return (str(timestamp) + "_" + str(random_value)).sha256_text()

remote func CreateCharacter(email, password, player_id):
	var verification = DatabaseInterface.VerifyUser(email, password)
	if not verification:
		return
	
	var gateway_id = get_tree().get_rpc_sender_id()
	var result = false
	var account_data = DatabaseInterface.FindUser(email).account_data
	
	var char_slots = account_data.character_slots
	var characters = account_data.characters
	
	if char_slots > characters.size():
		result = true
		DatabaseInterface.CreateCharacter(email)
		
	rpc_id(gateway_id, "ReturnCreateCharacterRequest", result, DatabaseInterface.new_character, player_id)

remote func CreateAccount(email, password, player_id):
	var taken_email = DatabaseInterface.FindUser(email) != null
	var gateway_id = get_tree().get_rpc_sender_id()
	var result
	var message
	
	if taken_email:
		result = false
		message = 2
	else:
		result = true
		message = 3
		DatabaseInterface.AddUser(email, password)
	rpc_id(gateway_id, "ReturnCreateAccountRequest", result, player_id, message)

remote func AuthenticatePlayer(email, password, player_id):
	var token
	var result
	var gateway_id = get_tree().get_rpc_sender_id()
	
	var verification = DatabaseInterface.FindUser(email)
	
	if not verification:
		result = false
	else:
		result = true
		randomize()
		token = str(randi()).sha256_text() + str(OS.get_unix_time())
			
		var gameserver = "GameServer1"
		GameServers.DistributeLogToken(token, email, gameserver)
			
	rpc_id(gateway_id, "AuthenticateResults", result, player_id, token)