extends Node

var max_players = 100
var port = 1913
var network = NetworkedMultiplayerENet.new()

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
	print("Gateway " + str(id) + " has connected to authentication server!")
func _Peer_Disconnected(id):
	print("Gateway " + str(id) + " has disconnected to authentication server!")

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
		PlayerData.player_data[email] = {"password": hashed_password, "salt": salt}
		PlayerData.savePlayerIDs()
	print("Returning result...")
	rpc_id(gateway_id, "returnCreateAccountRequest", result, player_id, message)
		
func GenerateSalt():
	randomize()
	var salt = str(randi()).sha256_text()
	print("Salt: " + salt)
	return salt
func GenerateHashedPassword(password, salt):
	print(str(OS.get_system_time_msecs()))
	var hashed_password = password
	var rounds = pow(2, 7)
	print("Hashed password as input: " + hashed_password)
	while rounds > 0:
		hashed_password = (hashed_password + salt).sha256_text()
		rounds -= 1
	print("Final hashed password: " + hashed_password)
	print(str(OS.get_system_time_msecs()))
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
			GameServers.DistributeLogToken(token, gameserver)
	rpc_id(gateway_id, "authenticateResults", result, player_id, token)
