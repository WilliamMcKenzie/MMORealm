extends Node

var database = PostgreSQLClient.new()
var database_connected = false

var database_name = "defaultdb"
var db_username = "doadmin"
var db_password = "AVNS_4aWPimeaFiU2cmEoVlm"
var host = "mmorealm-database-do-user-16835911-0.c.db.ondigitalocean.com"
var port = 25060

var weekly_leaderboard = []
var monthly_leaderboard = []
var all_time_leaderboard = []

var default_account_data = {
	"username" : "[unset]",
	"character_slots": 1,
	"gold": 5000,
	"finished_tutorial": false,
	"achievements": {
	},
	"statistics": {
		"tiles_covered" : 0,
		"ability_used" : 0,
		"damage_taken" : 0,
		"bow_projectiles" : 0,
		"staff_projectiles" : 0,
		"sword_projectiles" : 0,
		"projectiles_landed" : 0,
		"deaths" : 0,
	},
	"home" : {
		"whitelist" : [],
		"open_mode" : "open",
		"objects" : [
			{
				"type" : "storage",
				"position" : Vector2(12*8,12*8),
				"loot" : [
					null,
					null,
					null,
					null,
					null,
					null,
					null,
					null,
				],
			}
		],
		"tiles" : [],
		"inventory" : {
			"objects" : {
				"storage" : 0,
				"apprentice_statue" : 1,
				"noble_statue" : 0,
				"nomad_statue" : 0,
				"scholar_statue" : 0,
			},
			"tiles" : {
				"grass" : 0,
				"stone" : 0,
				"stone_wall" : 0,
				"wooden_planks" : 0,
				"wooden_wall" : 0,
			},
		}
	},
	"classes": {
		"Apprentice": true,
		
		"Noble": false,
		"Nomad": false,
		"Scholar": false,
		
		"Knight": false,
		"Paladin": false,
		"Marauder": false,
		
		"Ranger": false,
		"Sentinel": false,
		"Scout": false,
		
		"Magician": false,
		"Druid": false,
		"Warlock": false,
	},
	"characters":[],
	"graveyard":[],
}
var new_character = {
		"stats" : {
			"health" : 100,
			"attack" : 20,
			"defense" : 0,
			"speed" : 20,
			"dexterity" : 20,
			"vitality" : 20
		},
		"level" : 1,
		"exp" : 0,
		
		"ascension_stones" : 0,
		"used_ascension_stones" : 0,
		
		"stat_buffs" : {},
		"status_effects" : [],
		"ability_cooldown" : 0,
		
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
				"item" : 100,
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

func Connect():
	var connection_string = "postgresql://%s:%s@%s:%d/%s" % [
		db_username, db_password, host, port, database_name
	]
	database.connect_to_host(connection_string, true)

func _ready():
	Connect()
	var default_home_tiles = []
	#Grass
	for x in range(24):
		default_home_tiles.append([])
		for y in range(24):
			default_home_tiles[x].append(2)
	
	default_account_data.home.tiles = default_home_tiles
	
	var timer = Timer.new()
	timer.wait_time = 1
	timer.one_shot = true
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	
	weekly_leaderboard = GetLeaderboard(7)
	monthly_leaderboard = GetLeaderboard(30)
	all_time_leaderboard = GetLeaderboard(OS.get_system_time_secs())
	
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
	randomize()
	var user = null
	var command = """
		BEGIN;
		INSERT INTO users VALUES ('%s', '%s', '%s');
		COMMIT;
	""" % [email.to_lower(), generate_hashed_password(password), JSON.print(default_account_data)]
	database.execute(command)

func VerifyUser(email, password):
	var user = null
	var command = """
		BEGIN;
		SELECT * FROM users WHERE email = '%s' AND password = '%s';
	""" % [email.to_lower(), generate_hashed_password(password)]
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
	#print(account_data.graveyard)
	#print(account_data.characters)
	
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

func ReviveCharacter(email, index, player_id, gateway_id):
	var user = FindUser(email)
	
	if user:
		var account_data = user.account_data
		var revived_character = account_data.graveyard[index].duplicate()
		var cost = account_data.graveyard[index].revive_cost
		account_data.gold -= cost
		
		if revived_character.level > 20:
			revived_character.level = 20
		
		account_data.graveyard.erase(account_data.graveyard[index])
		account_data.characters.append(revived_character)
		
		UpdateUser(email, account_data)
		get_node("/root/Authenticate").rpc_id(gateway_id, "ReturnAccountData", account_data, player_id)

func GetLeaderboard(days_ago):
	var seconds_ago = OS.get_system_time_secs()-days_ago*24*60*60
	var command = """
		BEGIN;
		SELECT * FROM leaderboard WHERE timestamp >= %s ORDER BY reputation DESC LIMIT 20;
	""" % [seconds_ago]
	
	var data_arr = database.execute(command)
	
	var leaderboard = []
	for _data in data_arr:
		var data = _data.data_row
		if data != []:
			for result in data:
				var character = {
					"data" : JSON.parse(result[0]).result,
					"reputation" : result[1],
					"name" : result[2],
					"timestamp" : result[3],
				}
				leaderboard.append(character)
	
	return leaderboard

func UpdateLeaderboard(_username, _character):
	randomize()
	var character = { "gear" : _character.gear, "class" : _character.class}
	var reputation = _character.level
	var timestamp = OS.get_system_time_secs()

	var command = """
		BEGIN;
		INSERT INTO leaderboard VALUES ('%s', '%s', '%s', '%s');
		COMMIT;
	""" % [JSON.print(character), reputation, _username, timestamp]
	database.execute(command)
	
	var leaderboard_data = {
		"data" : character,
		"reputation" : reputation,
		"name" : _username,
		"timestamp" : timestamp,
	}
	
	weekly_leaderboard = AddToLeaderboard(weekly_leaderboard, leaderboard_data)
	monthly_leaderboard = AddToLeaderboard(monthly_leaderboard, leaderboard_data)
	all_time_leaderboard = AddToLeaderboard(all_time_leaderboard, leaderboard_data)

func AddToLeaderboard(leaderboard, new_value):
	var size = leaderboard.size()
	
	if size == 0:
		leaderboard[0] = new_value
		return leaderboard
	
	if new_value.reputation <= leaderboard[size - 1].reputation:
		return leaderboard
	
	for i in range(size):
		if new_value.reputation > leaderboard[i].reputation:
			for j in range(size - 1, i, -1):
				leaderboard[j] = leaderboard[j - 1]
			leaderboard[i] = new_value
			break
	
	return leaderboard

func ConfirmUsername(username, player_id):
	var command = """
		BEGIN;
		SELECT * FROM users WHERE account_data->>'username' = '%s';
	""" % [username]
	
	var data_arr = database.execute(command)
	
	var result = true
	for _data in data_arr:
		var data = _data.data_row
		if data != []:
			result = false
			
	return result

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
