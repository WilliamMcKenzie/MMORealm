extends Node

onready var main_interface = get_tree().get_root().get_node("Server")
onready var player_container_scene = preload("res://Scenes/Instances/PlayerContainer.tscn")

var awaiting_verification = {}

func Start(player_id):
	awaiting_verification[player_id] = { "Timestamp" : OS.get_unix_time()}
	main_interface.FetchToken(player_id)

func Verify(player_id, token):
	var token_verification = false
	while OS.get_unix_time() - int(token.right(64)) <= 30:
		if main_interface.expected_tokens.has(token):
			token_verification = true
			CreatePlayerContainer(player_id)
			awaiting_verification.erase(player_id)
			main_interface.expected_tokens.erase(token)
			break
		else:
			yield(get_tree().create_timer(2), "timeout")
	main_interface.ReturnTokenVerificationResults(player_id, token_verification)
	if(token_verification == false): #make sure they are disconnected
		awaiting_verification.erase(player_id)
		main_interface.network.disconnect_peer(player_id)

func CreatePlayerContainer(player_id):
	var instance_tree = get_node("/root/Server").player_state_collection[player_id]["I"]
	var new_player_container = player_container_scene.instance()
	new_player_container.name = str(player_id)
	get_node("/root/Server/Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players").add_child(new_player_container, true)
	FillPlayerContainer(get_node("/root/Server/Instances/"+StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id)))
func StringifyInstanceTree(instance_tree):
	var res = ""
	for instance in instance_tree:
		res += (instance+"/")
	return res.left(res.length() - 1) 

func FillPlayerContainer(player_container):
	var selectedPlayer = ServerData.player_data["williamqmckenzie@gmail.com"]
	player_container.character = selectedPlayer.characters[0]

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
	

	
	
	
	
	
	
