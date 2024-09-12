extends Node

var url = "wss://lagso.com"
#var url = "ws://143.110.213.88:20201"
#var url = "ws://localhost:20201"

var ip_address = "143.110.213.88"
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

	custom_multiplayer.connect("connection_failed", self, "_onConnectionFailed")
	custom_multiplayer.connect("connected_to_server", self, "_onConnectionSucceeded")

func ConnectToServerDefault():
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	
	network.create_client(ip_address, port)
	set_custom_multiplayer(gateway_api)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)

	custom_multiplayer.connect("connection_failed", self, "_onConnectionFailed")
	custom_multiplayer.connect("connected_to_server", self, "_onConnectionSucceeded")

func ConnectToServer(_email, _password, _task):
	email = _email
	task = _task
	password = _password
	
	if html:
		ConnectToServerHTML()
	else:
		ConnectToServerDefault()
	
func _onConnectionSucceeded():
	print("Connection succeeded!")
	LoadingScreen.EndWaiting()
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

func _onConnectionFailed():
	print("connectionFailed")

func FetchAccountData():
	rpc_id(1, "FetchAccountData", email, password)

remote func ReturnAccountData(account_data):
	html_network.disconnect_from_host()
	get_node("../SceneHandler/Home").SelectionScreen(account_data)

func RequestBuyCharacterSlot():
	rpc_id(1, "BuyCharacterSlot", email, password)
remote func ReturnBuyCharacterSlotRequest(result):
	html_network.disconnect_from_host()
	if result == true:
		get_node("../SceneHandler/Home/CharacterSelection").AddCharacterSlot()
		get_node("../SceneHandler/Home/CharacterSelection").Populate()

func RequestCreateCharacter():
	rpc_id(1, "CreateCharacter", email, password)
remote func ReturnCreateCharacterRequest(result, new_character):
	html_network.disconnect_from_host()
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
	html_network.disconnect_from_host()
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
	html_network.disconnect("connection_failed", self, "_onConnectionFailed")
	html_network.disconnect("connected_to_server", self, "_onConnectionSucceeded")

func RequestLogin():
	LoadingScreen.StartWaiting()
	rpc_id(1, "LoginRequest", email, password)
remote func ReturnLogin(result):
	html_network.disconnect_from_host()
	LoadingScreen.EndWaiting()
	get_node("../SceneHandler/Home/LoginPopup").LoginResult(result)
	
func GetLeaderboards():
	rpc_id(1, "GetLeaderboards")
remote func ReturnLeaderboards(weekly, monthly, all_time):
	html_network.disconnect_from_host()
	get_node("../SceneHandler/Home/Leaderboard").SetLeaderboard(weekly, monthly, all_time)
	GameUI.SetLeaderboard(weekly, monthly, all_time)
	
func SendToken():
	rpc_id(1, "SendToken", email)
remote func ReturnToken(token):
	html_network.disconnect_from_host()
	print("Returend")
	Server.token = token

func ReviveCharacter():
	if index != null:
		rpc_id(1, "ReviveCharacter", index, email, password)
		index = null
