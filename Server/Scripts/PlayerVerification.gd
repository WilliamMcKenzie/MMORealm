extends Node

onready var main_interface = get_tree().get_root().get_node("Server")
onready var player_container_scene = preload("res://Scenes/Instances/PlayerContainer.tscn")

var awaiting_verification = {}

func start(player_id):
	awaiting_verification[player_id] = { "Timestamp" : OS.get_unix_time()}
	main_interface.fetchToken(player_id)

func verify(player_id, token):
	print("my token is" + token)
	var token_verification = false
	while OS.get_unix_time() - int(token.right(64)) <= 30:
		if main_interface.expected_tokens.has(token):
			token_verification = true
			CreatePlayerContainer(player_id)
			awaiting_verification.erase(player_id)
			main_interface.expected_tokens.erase(token)
		else:
			yield(get_tree().create_timer(2), "timeout")
	print("my token is" + token)
	main_interface.ReturnTokenVerificationResults(player_id, token_verification)
	if(token_verification == false): #make sure they are disconnected
		awaiting_verification.erase(player_id)
		main_interface.network.disconnect_peer(player_id)
		
	

func CreatePlayerContainer(player_id):
	var new_player_container = player_container_scene.instance()
	new_player_container.name = str(player_id)
	get_parent().add_child(new_player_container, true)
	fillPlayerContainer(get_node("../" + str(player_id)))

func fillPlayerContainer(player_container):
	var selectedPlayer = ServerData.test_data
	player_container.characters = selectedPlayer.characters
	player_container.currentCharacterIndex = 0
	player_container.position = Vector2(0,0)
	player_container.moveVector = Vector2(0,0) 
