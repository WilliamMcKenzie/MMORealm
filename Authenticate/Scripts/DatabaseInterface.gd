extends Node

var database = PostgreSQLClient.new()
var database_connected = false

var database_name = "defaultdb"
var db_username = "doadmin"
var db_password = "AVNS_4aWPimeaFiU2cmEoVlm"
var host = "mmorealm-database-do-user-16835911-0.c.db.ondigitalocean.com"
var port = 25060

var default_account_data = {
	"username" : "[unset]",
	"character_slots": 1,
	"gold": 5000,
	"achievements": {
		"Trial By Fire" : false
	},
	"statistics": {
		"tiles_covered" : 0,
		"damage_taken" : 0,
		"bow_projectiles" : 0,
		"staff_projectiles" : 0,
		"sword_projectiles" : 0,
		"projectiles_landed" : 0,
	},
	"characters":[]
}
var new_character = {
		"stats" : {
			"health" : 100,
			"attack" : 30,
			"defense" : 0,
			"speed" : 30,
			"dexterity" : 30,
			"vitality" : 30
		},
		"level" : 1,
		"exp" : 0,
		
		"class" : "Apprentice",
		"statistics": {
			"tiles_covered" : 0,
			"damage_taken" : 0,
			"bow_projectiles" : 0,
			"staff_projectiles" : 0,
			"sword_projectiles" : 0,
			"projectiles_landed" : 0,
		},
		"gear" : {
			"weapon" : {
				"item" : 1,
				"id" : generate_unique_id()
			},
			"helmet" : null,
			"armor" : null
		},
		"inventory" : [
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
		]
}

func _ready():
	var connection_string = "postgresql://%s:%s@%s:%d/%s" % [
		db_username, db_password, host, port, database_name
	]
	database.connect_to_host(connection_string, true)

func _physics_process(delta):
	database.poll()
	
#Essential CRUD functions
	
func FindUser(email):
	var user = null
	var command = """
		BEGIN;
		SELECT * FROM users WHERE email = '%s'
	""" % [email]
	var data_arr = database.execute(command)
	
	for _data in data_arr:
		var data = _data.data_row
		if data != []:
			var result = data[0]
			user = {
				"email" : result[0],
				"account_data" : JSON.parse(result[2]).result
			}
			return user
	
	return null

func AddUser(email, password):
	var user = null
	var command = """
		BEGIN;
		INSERT INTO users VALUES ('%s', '%s', '%s');
		COMMIT;
	""" % [email, generate_hashed_password(password), JSON.print(default_account_data)]
	database.execute(command)

func VerifyUser(email, password):
	var user = null
	var command = """
		BEGIN;
		SELECT * FROM users WHERE email = '%s' AND password = '%s';
	""" % [email, generate_hashed_password(password)]
	var data_arr = database.execute(command)
	
	for _data in data_arr:
		var data = _data.data_row
		if data != []:
			return true
	return false

func DeleteUser(email):
	var user = null
	var command = """
		BEGIN;
		DELETE FROM users WHERE email = '%s'
		COMMIT;
	""" % [email]
	database.execute(command)

func UpdateUser(email, account_data):
	var user = null
	var command = """
		BEGIN;
		UPDATE users SET account_data = '%s' WHERE email = '%s';
		COMMIT;
	""" % [JSON.print(account_data), email]
	database.execute(command)
	
#Specialized functions

func CreateCharacter(email):
	var user = FindUser(email)
	
	if user:
		var account_data = user.account_data
		account_data.characters.append(new_character)
		
		UpdateUser(email, account_data)
	
func UpdateCharacter(email, character_data, character_index):
	var user = FindUser(email)
	
	if user:
		var account_data = user.account_data
		account_data.characters[character_index] = character_data
		
		UpdateUser(email, account_data)

#Utility functions

func generate_unique_id():
	var timestamp = OS.get_unix_time()
	var random_value = randi()
	return (str(timestamp) + "_" + str(random_value)).sha256_text()

func generate_hashed_password(password):
	var hashed_password = password
	var rounds = pow(2, 7)
	while rounds > 0:
		hashed_password = (hashed_password).sha256_text()
		rounds -= 1
	return hashed_password
