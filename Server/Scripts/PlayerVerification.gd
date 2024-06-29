extends Node

onready var main_interface = get_tree().get_root().get_node("Server")
onready var player_container_scene = preload("res://Scenes/SupportScenes/PlayerContainer.tscn")

var awaiting_verification = {}
var verified_emails = {}

func Start(player_id):
	awaiting_verification[player_id] = { "Timestamp" : OS.get_unix_time()}
	main_interface.FetchToken(player_id)

func Verify(player_id, token, character_index):
	var token_verification = false
	while OS.get_unix_time() - int(token.right(64)) <= 30:
		if main_interface.expected_tokens.has(token):
			
			#Check if same account is already in the game
			if(verified_emails.has(main_interface.expected_tokens[token])):
				break
				
			token_verification = true
			CreatePlayerContainer(player_id, main_interface.expected_tokens[token], character_index)
			awaiting_verification.erase(player_id)
			main_interface.expected_tokens.erase(token)
			break
		else:
			print("token:" + token)
			print(main_interface.expected_tokens)
			yield(get_tree().create_timer(2), "timeout")
	main_interface.ReturnTokenVerificationResults(player_id, token_verification)
	if(token_verification == false): #make sure they are disconnected
		awaiting_verification.erase(player_id)
		main_interface.network.disconnect_peer(player_id)

func CreatePlayerContainer(player_id, email, character_index):
	verified_emails[email] = true
	var instance_tree = get_node("/root/Server").player_state_collection[player_id]["I"]
	var new_player_container = player_container_scene.instance()
	new_player_container.email = email
	new_player_container.name = str(player_id)
	new_player_container.character_index = character_index
	get_node("/root/Server/Instances/"+StringifyInstanceTree(instance_tree)).SpawnPlayer(new_player_container)
	FillPlayerContainer(player_id, email)

func CreateFakePlayerContainer():
	var instance_tree = ["nexus"]
	var new_player_container = player_container_scene.instance()
	var default_account_data = {
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
		"characters":[{
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
					"id" : get_node("/root/Server").generate_unique_id()
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
		}]
	}
	new_player_container.position = Vector2(rand_range(-25,25), rand_range(-25,25))
	new_player_container.email = str(rand_range(0,5)).sha256_text()
	new_player_container.name =  str(rand_range(0,5)).sha256_text()
	new_player_container.character_index = 0
	get_node("/root/Server/Instances/"+StringifyInstanceTree(instance_tree)).SpawnPlayer(new_player_container)
	get_node("/root/Server/Instances/"+get_node("/root/Server").StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(new_player_container.name)).account_data = default_account_data
	get_node("/root/Server/Instances/"+get_node("/root/Server").StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(new_player_container.name)).SetCharacter(default_account_data.characters)
	
func StringifyInstanceTree(instance_tree):
	var res = ""
	for instance in instance_tree:
		res += (instance+"/")
	return res.left(res.length() - 1) 

func FillPlayerContainer(player_id, email):
	HubConnection.GetAccountData(player_id, email)

func VerificationExpiration():
	var current_time = OS.get_unix_time()
	var start_time
	if awaiting_verification == {}:
		pass
	else:
		for key in awaiting_verification.keys():
			start_time = awaiting_verification[key].Timestamp
			if current_time - start_time >= 30:
				awaiting_verification.erase(key)
				var connected_peers = Array(get_tree().get_network_connected_peers())
				if connected_peers.has(key):
					main_interface.ReturnTokenVerificationResults(key, false)
					main_interface.network.disconnect_peer(key)
	
	
	
	
	
	
