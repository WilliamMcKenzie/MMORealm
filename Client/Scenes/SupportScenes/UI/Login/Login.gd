extends Node2D

onready var loginButton = $ResizeContainer/Login
onready var signupButton = $ResizeContainer/Signup

var email = ""
var password = ""

func _ready():
	loginButton.connect("pressed", self, "LoginAttempt")
	signupButton.connect("pressed", self, "SignupAttempt")
	
func SignupAttempt():
	if email == "" or password == "":
		ErrorPopup.OpenPopup("Invalid credentials: Email/password cannot be blank")
	if password.length() < 7:
		ErrorPopup.OpenPopup("Invalid credentials: Password length must be greater then 7.")
	else:
		loginButton.disabled = true
		signupButton.disabled = true
		Gateway.ConnectToServer(email, password, 1)

func LoginAttempt():
	if email == "" or password == "":
		ErrorPopup.OpenPopup("Invalid credentials: Email/password cannot be blank")
	else:
		loginButton.disabled = true
		signupButton.disabled = true
		Gateway.ConnectToServer(email, password, 0)
func LoginResult(result):
	loginButton.disabled = false
	signupButton.disabled = false
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
