extends Node

var ip = "localhost"
var port = 20201
var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()

var email
var password
var new_account

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
	

func connectToServer(_email, _password, _new_account):
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	email = _email
	new_account = _new_account
	password = _password
	
	network.create_client(ip, port)
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
	if(new_account):
		requestCreateAccount()
	else:
		requestLogin()
	
func requestCreateAccount():
	print("Requesting create account from gateway")
	rpc_id(1, "createAccountRequest", email, password)
	email = ""
	password = ""
remote func returnCreateAccountRequest(results, message):
	print("Results recieved")
	print(results)
	print(message)
	if(results == true):
		print("Account created successfully.")
		get_node("../SceneHandler/Home/LoginPopup").loginAttempt()
	else:
		if(message == 1):
			print("couldnt create account, please try again.")
		else:
			print("email in use, please try another.")
		get_node("../SceneHandler/Home/LoginPopup").loginButton.disabled = false
		get_node("../SceneHandler/Home/LoginPopup").signupButton.disabled = false
	network.disconnect("connection_failed", self, "_onConnectionFailed")
	network.disconnect("connected_to_server", self, "_onConnectionSucceeded")

func requestLogin():
	print("Requesting login from gateway")
	rpc_id(1, "loginRequest", email, password)
	email = ""
	password = ""

remote func returnLogin(result, token):
	print("token recieved")
	if(result):
		Server.token = token
	get_node("../SceneHandler/Home/LoginPopup").loginResult(result)
