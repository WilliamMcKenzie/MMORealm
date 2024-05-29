extends Node

onready var player_container_scene = preload("res://Scenes/Instances/PlayerContainer.tscn")

func start(player_id):
	# THIS IS WHERE WE ARE GOING TO VERIFY PLAYER VIA AUTH TOKEN FROM AUTHENTICATION SERVRE
	# If token verification is not successful kick player
	# Otherwise continue
	CreatePlayerContainer(player_id)

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
