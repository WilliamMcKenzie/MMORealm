extends Node2D

onready var emailEle = $ResizeContainer/Email
onready var passwordEle = $ResizeContainer/Password
onready var loginButton = $ResizeContainer/Login
onready var signupButton = $ResizeContainer/Signup

var email = ""
var password = ""

func _ready():
	loginButton.connect("pressed", self, "loginAttempt")
	signupButton.connect("pressed", self, "signupAttempt")
	emailEle.connect("text_changed", self, "emailHandler")
	passwordEle.connect("text_changed", self, "passwordHandler")

func emailHandler():
	email = emailEle.text
	print(email)
func passwordHandler():
	password = passwordEle.text
	print(password)

func signupAttempt():
	if email == "" or password == "":
		print("Invalid credentials: Email/password cannot be blank")
	if password.length() < 7:
		print("Invalid credentials: Password length must be greater then 7.")
	else:
		loginButton.disabled = true
		signupButton.disabled = true
		print("Attempting login!!")
		Gateway.connectToServer(email, password, true)

func loginAttempt():
	if email == "" or password == "":
		print("Invalid credentials: Email/password cannot be blank")
	else:
		loginButton.disabled = true
		signupButton.disabled = true
		print("Attempting login!!")
		Gateway.connectToServer(email, password, false)
func loginResult(result):
	loginButton.disabled = false
	signupButton.disabled = false
	if(result == true):
		Server.connectToServer()
	else:
		print("Invalid credentials")
