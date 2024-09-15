extends Node

var audio_files = {
	"hit" : [preload("res://Assets/audio/hit.ogg"), 1],
	"shoot" : [preload("res://Assets/audio/hit.ogg"), 1],
	"title" : [preload("res://Assets/audio/title.mp3"), 4],
}

var clock_sync_timer = 0
var playing_music = false
func _process(delta):
	clock_sync_timer += 1
	if clock_sync_timer >= 30 and not playing_music and get_node("/root/SceneHandler").has_node("Home"):
		playing_music = true
		var audio_player = AudioStreamPlayer.new()
		audio_player.stream = audio_files["title"][0]
		audio_player.volume_db = audio_files["title"][1]
		audio_player.name = "TitleTrack"
		add_child(audio_player)
		audio_player.play()
	elif clock_sync_timer >= 30 and playing_music and not get_node("/root/SceneHandler").has_node("Home"):
		playing_music = false
		get_node("TitleTrack").queue_free()

func Play(audio_name):
	if audio_files.has(audio_name):
		var audio_player = AudioStreamPlayer.new()
		audio_player.stream = audio_files[audio_name][0]
		audio_player.volume_db = audio_files[audio_name][1]
		audio_player.connect("finished", self, "RemoveNode", [audio_player])
		add_child(audio_player)
		audio_player.play()

func RemoveNode(node):
	node.queue_free()
