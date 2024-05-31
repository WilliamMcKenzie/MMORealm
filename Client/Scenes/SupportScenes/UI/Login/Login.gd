extends Node2D

onready var emailEle = $ResizeContainer/Email
onready var passwordEle = $ResizeContainer/Password
onready var loginButton = $ResizeContainer/Login
onready var signupButton = $ResizeContainer/Signup

var email = ""
var password = ""

func _ready():
	loginButton.connect("pressed", self, "LoginAttempt")
	signupButton.connect("pressed", self, "SignupAttempt")
	emailEle.connect("text_changed", self, "EmailHandler")
	passwordEle.connect("text_changed", self, "PasswordHandler")

func EmailHandler():
	email = emailEle.text
	print(email)
func PasswordHandler():
	password = passwordEle.text
	print(password)

func SignupAttempt():
	if email == "" or password == "":
		print("Invalid credentials: Email/password cannot be blank")
	if password.length() < 7:
		print("Invalid credentials: Password length must be greater then 7.")
	else:
		loginButton.disabled = true
		signupButton.disabled = true
		print("Attempting login!!")
		Gateway.ConnectToServer(email, password, true)

func LoginAttempt():
	if email == "" or password == "":
		print("Invalid credentials: Email/password cannot be blank")
	else:
		loginButton.disabled = true
		signupButton.disabled = true
		print("Attempting login!!")
		Gateway.ConnectToServer(email, password, false)
func LoginResult(result):
	loginButton.disabled = false
	signupButton.disabled = false
	if(result == true):
		get_node("/root/SceneHandler/Home").selectionScreen()
	else:
		print("Invalid credentials")
