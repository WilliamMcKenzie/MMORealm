extends Node

var cached_password = null
var cached_email = null

func _ready():
	var result = LoadUser()
	if result:
		cached_email = result.email
		cached_password = result.password

func SaveUser(email, password):
	var config = ConfigFile.new()
	config.set_value("login", "email", email)
	config.set_value("login", "password", password)
	config.save("user://login.cfg")

func LoadUser():
	var config = ConfigFile.new()
	var error = config.load("user://login.cfg")
	if error == OK:
		var email = config.get_value("login", "email", "")
		var password = config.get_value("login", "password", "")
		return { "email" : email, "password" : password }
	return
