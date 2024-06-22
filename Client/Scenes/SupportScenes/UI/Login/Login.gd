extends Node2D

onready var loginButton = $ResizeContainer/Login
onready var signupButton = $ResizeContainer/Signup

var email = ""
var password = ""

func _ready():
	loginButton.connect("pressed", self, "LoginAttempt")
	signupButton.connect("pressed", self, "SignupAttempt")
	
func SignupAttempt():
	$ResizeContainer/WarningLabel.text = "SIGNING IN"
	
	if email == "" or password == "":
		print("Invalid credentials: Email/password cannot be blank")
		$ResizeContainer/WarningLabel.text = "Blank passwrd"
	if password.length() < 7:
		print("Invalid credentials: Password length must be greater then 7.")
		$ResizeContainer/WarningLabel.text = "shrt passwrd"
	else:
		$ResizeContainer/WarningLabel.text = "Attempting logijn"
		loginButton.disabled = true
		signupButton.disabled = true
		print("Attempting login!!")
		Gateway.ConnectToServer(email, password, 1)

func LoginAttempt():
	if email == "" or password == "":
		$ResizeContainer/WarningLabel.text = "Invalid"
		print("Invalid credentials: Email/password cannot be blank")
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
		print("Invalid credentials")


func _on_Password_text_changed(_password):
	password = _password
func _on_Email_text_changed(_email):
	email = _email
