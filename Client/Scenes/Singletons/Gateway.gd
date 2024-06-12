extends Node

#var ip_address = "143.110.213.88"
var ip_address = "localhost"
var port = 20201
var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()

var email
var password
var task

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
	

func ConnectToServer(_email, _password, _task):
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	email = _email
	task = _task
	password = _password
	
	network.create_client(ip_address, port)
	set_custom_multiplayer(gateway_api)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)

	custom_multiplayer.connect("connection_failed", self, "_onConnectionFailed")
	custom_multiplayer.connect("connected_to_server", self, "_onConnectionSucceeded")

func _onConnectionFailed():
	print("Connection failed, gateway server down.")
	get_node("../SceneHandler/Home/LoginPopup").loginButton.disabled = false
	get_node("../SceneHandler/Home/LoginPopup").signupButton.disabled = false
	
func _onConnectionSucceeded():
	print("Connection succeeded!")
	if(task == 2):
		RequestCreateCharacter()
	if(task == 1):
		RequestCreateAccount()
	else:
		RequestLogin()
	
func RequestCreateCharacter():
	rpc_id(1, "CreateCharacter", email, password)
	email = ""
	password = ""
remote func ReturnCreateCharacterRequest(result, new_character):
	if result == true:
		get_node("../SceneHandler/Home/CharacterSelection").characters.append(new_character)
		get_node("../SceneHandler/Home/CharacterSelection").PopulateCharacters()
	
func RequestCreateAccount():
	print("Requesting create account from gateway")
	rpc_id(1, "CreateAccountRequest", email, password)
	email = ""
	password = ""
remote func ReturnCreateAccountRequest(results, message):
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
	network.disconnect("connection_failed", self, "_onConnectionFailed")
	network.disconnect("connected_to_server", self, "_onConnectionSucceeded")

func RequestLogin():
	rpc_id(1, "LoginRequest", email, password)
	email = ""
	password = ""

remote func ReturnLogin(result, token):
	if(result):
		Server.token = token
	get_node("../SceneHandler/Home/LoginPopup").LoginResult(result)
