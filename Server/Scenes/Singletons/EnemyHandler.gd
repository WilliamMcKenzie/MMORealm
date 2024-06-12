extends Node


var time = 0
var NPC_tick = 1
var last_tick = 0

func _ready():
	time = 0
	
func _physics_process(delta):
	for i in range(int((time-last_tick)/NPC_tick)):
		for j in get_parent().get_node("Server").get_node("Instances").get_children():
			for z in j.get_node("YSort").get_node("Enemies").get_children():
				z.movement(NPC_tick)
		
		last_tick += NPC_tick
	time += delta
