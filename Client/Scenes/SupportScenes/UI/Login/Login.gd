extends CanvasLayer

onready var loginButton = $VBoxContainer/HBoxContainer/Login
onready var signupButton = $VBoxContainer/HBoxContainer/Signup
onready var guestButton = $Guest

var email = ""
var password = ""

func _ready():
	loginButton.connect("pressed", self, "LoginAttempt")
	signupButton.connect("pressed", self, "SignupAttempt")
	guestButton.connect("pressed", self, "GuestRequest")
	
	$Guest/PanelContainer/MarginContainer/VBoxContainer/Options/Yes.connect("pressed", self, "GuestSignup")
	$Guest/PanelContainer/MarginContainer/VBoxContainer/Options/Cancel.connect("pressed", self, "GuestCancel")

func GuestRequest():
	$Guest/PanelContainer.visible = true
func GuestSignup():
	$Guest/PanelContainer.visible = false
	password = str(randf()).sha256_text()
	email = str(randf()).sha256_text()
	$VBoxContainer/PasswordContainer/Password/MarginContainer/Password.text = password
	$VBoxContainer/EmailContainer/Email/MarginContainer/Email.text = email
	Gateway.GatewayRequest(email, password, 1)
func GuestCancel():
	$Guest/PanelContainer.visible = false

func SignupAttempt():
	password = $VBoxContainer/PasswordContainer/Password/MarginContainer/Password.text
	email = $VBoxContainer/EmailContainer/Email/MarginContainer/Email.text
	if email == "" or password == "":
		ErrorPopup.OpenPopup("Invalid credentials: Email/password cannot be blank")
	if password.length() < 7:
		ErrorPopup.OpenPopup("Invalid credentials: Password length must be greater then 7.")
	else:
		Gateway.GatewayRequest(email, password, 1)

func LoginAttempt():
	password = $VBoxContainer/PasswordContainer/Password/MarginContainer/Password.text
	email = $VBoxContainer/EmailContainer/Email/MarginContainer/Email.text
	if email == "" or password == "":
		ErrorPopup.OpenPopup("Invalid credentials: Email/password cannot be blank")
	else:
		Gateway.GatewayRequest(email, password, 0)
func LoginResult(result):
	if(result == true):
		get_node("/root/SceneHandler/Home").email = email
		get_node("/root/SceneHandler/Home").password = password
		get_node("/root/SceneHandler/Home").AuthenticatedUser()
	else:
		ErrorPopup.OpenPopup("Invalid credentials")


func _on_Password_text_changed(_password):
	password = _password
func _on_Email_text_changed(_email):
	email = _email
