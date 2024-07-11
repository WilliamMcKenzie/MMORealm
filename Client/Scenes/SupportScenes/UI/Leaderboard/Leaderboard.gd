extends CanvasLayer

var character_scene = preload("res://Scenes/SupportScenes/UI/Leaderboard/Character.tscn")
var leaderboards = {
	"weekly" : [],
	"monthly" : [],
	"all_time" : [],
}
var current = "weekly"

func _ready():
	$HBoxContainer/weekly.connect("pressed", self, "SwitchLeaderboard", ["weekly"])
	$HBoxContainer/monthly.connect("pressed", self, "SwitchLeaderboard", ["monthly"])
	$HBoxContainer/all_time.connect("pressed", self, "SwitchLeaderboard", ["all_time"])
	$Back.connect("button_down", self, "CloseLeaderboard")

func SwitchLeaderboard(which):
	get_node("HBoxContainer/"+current).self_modulate = 80
	get_node("HBoxContainer/"+which).self_modulate = 160
	
	current = which
	var container = $MarginContainer/ScrollContainer/Top
	for child in container.get_children():
		container.remove_child(child)
	
	var leaderboard = leaderboards[current]
	var index = 0
	for character in leaderboard:
		index += 1
		var character_instance = character_scene.instance()
		character_instance.SetData(character, index)
		container.add_child(character_instance)
	
func SetLeaderboard(weekly, monthly, all_time):
	var container = $MarginContainer/ScrollContainer/Top
	for child in container.get_children():
		container.remove_child(child)
	
	leaderboards.weekly = weekly
	leaderboards.monthly = monthly
	leaderboards.all_time = all_time
	
	SwitchLeaderboard("weekly")
	
func CloseLeaderboard():
	get_parent().CloseLeaderboard()
