extends Node

var url = "wss://gameserver.lagso.com/port20201/"
#var url = "ws://159.203.0.78:20201"
#var url = "ws://localhost:20201"

var ip_address = "159.203.0.78"
#var ip_address = "localhost"
var port = 20201
var network = NetworkedMultiplayerENet.new()
var html_network = WebSocketClient.new();
var gateway_api = MultiplayerAPI.new()

var email
var password
var task
var index = null

#if we are using the web client
var html = true

func _ready():
	ConnectToServerHTML()

func _process(delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()

func ConnectToServerHTML():
	# Connect to WebSocket server
	var connection_result = html_network.connect_to_url(url, PoolStringArray(), true)
	if connection_result == OK:
		pass
	else:
		LoadingScreen.StartWaiting()
		while(connection_result != OK):
			yield(get_tree().create_timer(1), "timeout")
			connection_result = html_network.connect_to_url(url, PoolStringArray(), true)
			print("Failed to connect to WebSocket server.")
	gateway_api = MultiplayerAPI.new()
	
	set_custom_multiplayer(gateway_api)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(html_network)
	custom_multiplayer.connect("connected_to_server", self, "_onConnectionSucceeded")

var connected = false
func _onConnectionSucceeded():
	connected = true

func GatewayRequest(_email, _password, _task):
	email = _email
	task = _task
	password = _password
	
	while(not connected):
		yield(get_tree().create_timer(1), "timeout")
	
	if(task == 7):
		ReviveCharacter()
	if(task == 6):
		SendToken()
	if(task == 5):
		GetLeaderboards()
	if(task == 4):
		FetchAccountData()
	if(task == 3):
		RequestBuyCharacterSlot()
	if(task == 2):
		RequestCreateCharacter()
	if(task == 1):
		RequestCreateAccount()
	if(task == 0):
		RequestLogin()

func FetchAccountData():
	rpc_id(1, "FetchAccountData", email, password)

remote func ReturnAccountData(account_data):
	get_node("../SceneHandler/Home").SelectionScreen(account_data)

func RequestBuyCharacterSlot():
	rpc_id(1, "BuyCharacterSlot", email, password)
remote func ReturnBuyCharacterSlotRequest(result):
	if result == true:
		get_node("../SceneHandler/Home/CharacterSelection").AddCharacterSlot()
		get_node("../SceneHandler/Home/CharacterSelection").Populate()

func RequestCreateCharacter():
	rpc_id(1, "CreateCharacter", email, password)
remote func ReturnCreateCharacterRequest(result, new_character):
	if result == true:
		get_node("../SceneHandler/Home/CharacterSelection").characters.append(new_character)
		get_node("../SceneHandler/Home/CharacterSelection").Populate()
	
func RequestCreateAccount():
	LoadingScreen.StartWaiting()
	print("Requesting create account from gateway")
	print(email)
	print(password)
	rpc_id(1, "CreateAccountRequest", email, password)
	email = ""
	password = ""
remote func ReturnCreateAccountRequest(results, message):
	LoadingScreen.EndWaiting()
	print("Results recieved")
	print(results)
	print(message)
	if(results == true):
		print("Account created successfully.")
		get_node("../SceneHandler/Home/LoginPopup").LoginAttempt()
	else:
		if(message == 1):
			print("Couldnt create account, please try again.")
		else:
			print("Email in use, please try another.")
		get_node("../SceneHandler/Home/LoginPopup").loginButton.disabled = false
		get_node("../SceneHandler/Home/LoginPopup").signupButton.disabled = false

func RequestLogin():
	LoadingScreen.StartWaiting()
	rpc_id(1, "LoginRequest", email, password)
remote func ReturnLogin(result):
	LoadingScreen.EndWaiting()
	get_node("../SceneHandler/Home/LoginPopup").LoginResult(result)
	
func GetLeaderboards():
	rpc_id(1, "GetLeaderboards")
remote func ReturnLeaderboards(weekly, monthly, all_time):
	get_node("../SceneHandler/Home/Leaderboard").SetLeaderboard(weekly, monthly, all_time)
	GameUI.SetLeaderboard(weekly, monthly, all_time)
	
func SendToken():
	rpc_id(1, "SendToken", email)
remote func ReturnToken(token):
	print("Returend")
	Server.token = token

func ReviveCharacter():
	if index != null:
		rpc_id(1, "ReviveCharacter", index, email, password)
		index = null
