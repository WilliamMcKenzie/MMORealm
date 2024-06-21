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
	if not PlayerData.player_data.has(email):
		return 
	if PlayerData.player_data[email].password != GenerateHashedPassword(password, PlayerData.player_data[email].salt):
		return
	
	var gateway_id = get_tree().get_rpc_sender_id()
	var account_data = PlayerData.player_data[email].account_data
	
	rpc_id(gateway_id, "ReturnAccountData", account_data, player_id)

remote func BuyCharacterSlot(email, password, player_id):
	if not PlayerData.player_data.has(email):
		return
	if PlayerData.player_data[email].password != GenerateHashedPassword(password, PlayerData.player_data[email].salt):
		return
	
	var gateway_id = get_tree().get_rpc_sender_id()
	var result = false
	var account_data = PlayerData.player_data[email].account_data
	
	var character_slots = account_data.character_slots
	var gold = account_data.gold
	
	var price = 500 + (character_slots*200)
	
	if gold > price:
		result = true
		PlayerData.player_data[email].account_data.character_slots += 1
		PlayerData.player_data[email].account_data.gold -= price
	rpc_id(gateway_id, "ReturnBuyCharacterSlotRequest", result, player_id)

func generate_unique_id():
	var timestamp = OS.get_unix_time()
	var random_value = randi()
	return (str(timestamp) + "_" + str(random_value)).sha256_text()

remote func CreateCharacter(email, password, player_id):
	if not PlayerData.player_data.has(email):
		return
	if PlayerData.player_data[email].password != GenerateHashedPassword(password, PlayerData.player_data[email].salt):
		return
	
	var new_character = {
		"stats" : {
			"health" : 100,
			"attack" : 30,
			"defense" : 0,
			"speed" : 100,
			"dexterity" : 30,
			"vitality" : 30
		},
		"level" : 1,
		"exp" : 0,
		"class" : "Apprentice",
		"gear" : {
			"weapon" : {
				"item" : 1,
				"id" : generate_unique_id()
			},
			"helmet" : null,
			"armor" : null
		},
		"inventory" : [
			{
				"item" : 3,
				"id" : generate_unique_id()
			},
			null,
			null,
			null,
			null,
			null,
			null,
			null,
		]
	}
	
	var gateway_id = get_tree().get_rpc_sender_id()
	var result = false
	var account_data = PlayerData.player_data[email].account_data
	
	var char_slots = account_data.character_slots
	var characters = account_data.characters
	
	if char_slots > characters.size():
		result = true
		PlayerData.player_data[email].account_data.characters.append(new_character)
		
	rpc_id(gateway_id, "ReturnCreateCharacterRequest", result, new_character, player_id)

remote func CreateAccount(email, password, player_id):
	var gateway_id = get_tree().get_rpc_sender_id()
	var result
	var message
	if PlayerData.player_data.has(email):
		result = false
		message = 2
	else:
		result = true
		message = 3
		#This is where we would attatch the email/password to a database
		var salt = GenerateSalt()
		var hashed_password = GenerateHashedPassword(password, salt)
		PlayerData.player_data[email] = {"password": hashed_password, "salt": salt, "account_data": {
			"character_slots": 1,
			"gold": 5000,
			"characters":[]
		}}
		PlayerData.savePlayerIDs()
	rpc_id(gateway_id, "ReturnCreateAccountRequest", result, player_id, message)

func GenerateSalt():
	randomize()
	var salt = str(randi()).sha256_text()
	print("Salt: " + salt)
	return salt
func GenerateHashedPassword(password, salt):
	var hashed_password = password
	var rounds = pow(2, 7)
	while rounds > 0:
		hashed_password = (hashed_password + salt).sha256_text()
		rounds -= 1
	return hashed_password

remote func AuthenticatePlayer(email, password, player_id):
	var token
	var hashed_password
	var result
	var gateway_id = get_tree().get_rpc_sender_id()
	if not PlayerData.player_data.has(email):
		result = false
	else:
		var retrieved_salt = PlayerData.player_data[email].salt
		hashed_password = GenerateHashedPassword(password, retrieved_salt)
		if not PlayerData.player_data[email].password == hashed_password:
			result = false
		else:
			result = true
			randomize()
			token = str(randi()).sha256_text() + str(OS.get_unix_time())
			var gameserver = "GameServer1"
			
			#Change this to instead of distrbuting account data disrbute email
			#Then on the game server we can use email to get account data from this auth server seperately
			GameServers.DistributeLogToken(token, email, gameserver)
	rpc_id(gateway_id, "AuthenticateResults", result, player_id, token)
