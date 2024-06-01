extends Node

var enemy_id_counter = 1
var enemy_maximum = 2
var enemy_types = ["Snake"]
var enemy_spawn_points = [Vector2(0,0), Vector2(40,23), Vector2(-20,42), Vector2(15,-30)]
var open_locations = [0,1,2,3]
var occupied_locations = {}
var enemy_list = {}

func _ready():
	var timer = Timer.new()
	timer.wait_time = 3
	timer.autostart = true
	timer.connect("timeout", self, "SpawnEnemy")
	self.add_child(timer)
func SpawnEnemy():
	if enemy_list.size() >= enemy_maximum:
		pass
	else:
		randomize()
