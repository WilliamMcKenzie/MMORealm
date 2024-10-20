extends Node

var hide_players = false
var hide_player_shots = false
var show_fps = false
var show_ping = false
var interpolation_offset = 100

var zoom = 1
var auto_open_chests = false

var open_inventory = InputEventKey.new()
var enter_dungeon = InputEventKey.new()
var use_ability = InputEventKey.new()
var return_to_port = InputEventKey.new()

var last_pressed = {
	"open_inventory" : 0,
}
func _physics_process(delta):
	if(Input.is_action_pressed("open_inventory") and OS.get_system_time_msecs() - last_pressed["open_inventory"] > 500) and not GameUI.in_chat:
		last_pressed["open_inventory"] = OS.get_system_time_msecs()
		GameUI.Toggle("inventory")
