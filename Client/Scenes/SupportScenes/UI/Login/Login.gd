extends Node2D

onready var emailEle = $ResizeContainer/Email
onready var passwordEle = $ResizeContainer/Password
onready var loginButton = $ResizeContainer/Login

var email = ""
var password = ""

func _ready():
	loginButton.connect("pressed", self, "loginAttempt")
	emailEle.connect("text_changed", self, "emailHandler")
	passwordEle.connect("text_changed", self, "passwordHandler")

func emailHandler():
	email = emailEle.text
	print(email)
func passwordHandler():
	password = passwordEle.text
	print(password)

func loginAttempt():
	if email == "" or password == "":
		print("Invalid credentials")
	else:
		loginButton.disabled = true
		print("Attempting login!!")
		Gateway.connectToServer(email, password)
func loginResult(result):
	loginButton.disabled = false
	if(result == true):
		queue_free()
	else:
		print("Invalid credentials")
