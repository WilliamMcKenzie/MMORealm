extends Node

var audio_files = {
	"hit" : [preload("res://Assets/audio/impactPlate_medium_001.ogg"), 1],
	"open" : [preload("res://Assets/audio/click_001.ogg"), 1],
	"action" : [preload("res://Assets/audio/tick_004.ogg"), 1],
	"error" : [preload("res://Assets/audio/error_008.ogg"), 1],
	"warning" : [preload("res://Assets/audio/error_006.ogg"), 1],
}

var clock_sync_timer = 0
var playing_music = false

func Play(audio_name, volume = 1):
	if Settings.audio and audio_files.has(audio_name):
		var audio_player = AudioStreamPlayer.new()
		audio_player.stream = audio_files[audio_name][0]
		audio_player.volume_db = audio_files[audio_name][1]*volume
		audio_player.connect("finished", self, "RemoveNode", [audio_player])
		add_child(audio_player)
		audio_player.play()

func RemoveNode(node):
	node.queue_free()
