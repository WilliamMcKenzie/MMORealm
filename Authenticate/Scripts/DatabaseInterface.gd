extends Node

var database = "defaultdb"
var db_username = "doadmin"
var db_password = "AVNS_4aWPimeaFiU2cmEoVlm"
var host = "mmorealm-database-do-user-16835911-0.c.db.ondigitalocean.com"
var port = 25060

var default_account_data = {
	"character_slots": 1,
	"gold": 5000,
	"characters":[]
}
	
var executable_path = "/root/sql-client"

func _ready():
	AddUser("goku", "dragonballs")
	print("Verifying... : " + str(VerifyUser("goku", "dragonballs")))

#Essential CRUD functions

func AddUser(user_email, user_password):
	var output = []
	var command = "add-user"
	var account_data_json = JSON.print(default_account_data)
	var args = [command, database, db_username, db_password, host, port, user_email, user_password, account_data_json]
	
	OS.execute(executable_path, args, false, output, true, false)

func FindUser(user_email):
	var output = []
	var command = "find-user"
	var args = [command, database, db_username, db_password, host, port, user_email]
	
	OS.execute(executable_path, args, true, output, true, false)
	
	if output[0] == "NIL":
		return null
	else:
		return output[0]

func DeleteUser(user_email):
	var output = []
	var command = "delete-user"
	var args = [command, database, db_username, db_password, host, port, user_email]
	
	OS.execute(executable_path, args, false, output, true, false)

func UpdateUser(user_email, new_user_email, new_user_password, new_account_data):
	var output = []
	var command = "update-user"
	var args = [command, database, db_username, db_password, host, port, user_email, new_user_email, new_user_password, new_account_data]
	
	OS.execute(executable_path, args, false, output, true, false)

func VerifyUser(user_email, user_password):
	var output = []
	var command = "verify-user"
	var args = [command, database, db_username, db_password, host, port, user_email, user_password]
	
	OS.execute(executable_path, args, true, output, true, false)
	
	return output[0]

#Specialized functions
	
func CreateCharacter(user_email, character_data):
	var user = FindUser(user_email)
	var account_data = user.account_data
	account_data.characters.append(character_data)
	
	UpdateUser(user.email, user.email, user.password, account_data)
	
func UpdateCharacter(user_email, character_data, character_index):
	var user = FindUser(user_email)
	var account_data = user.account_data
	account_data.characters[character_index] = character_data
	
	UpdateUser(user.email, user.email, user.password, account_data)
