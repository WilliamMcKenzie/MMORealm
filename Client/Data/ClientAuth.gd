extends Node

var cached_password = null
var cached_email = null

func _ready():
	var result = LoadUser()
	if result:
		cached_email = result.email
		cached_password = result.password

func SaveSettings(settings):
	var config = ConfigFile.new()
	
	for key in settings.keys():
		config.set_value("settings", key, settings[key])
	config.save("user://settings.cfg")

func LoadSettings():
	var config = ConfigFile.new()
	var error = config.load("user://settings.cfg")
	if error == OK and config.has_section("settings"):
		var settings = {}
		for key in config.get_section_keys("settings"):
			settings[key] = config.get_value("settings", key)
		return settings
	return {}

func DeleteUser():
	var config = ConfigFile.new()
	var error = config.load("user://login.cfg")
	if error == OK:
		config.erase_section("login")
		config.save("user://login.cfg")

func SaveUser(email, password):
	var config = ConfigFile.new()
	config.set_value("login", "email", email)
	config.set_value("login", "password", password)
	config.save("user://login.cfg")

func LoadUser():
	var config = ConfigFile.new()
	var error = config.load("user://login.cfg")
	if error == OK and config.has_section("login"):
		var email = config.get_value("login", "email", "")
		var password = config.get_value("login", "password", "")
		return { "email" : email, "password" : password }
	return
