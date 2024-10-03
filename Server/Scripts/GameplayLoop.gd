extends Node

var island_preloads = {}
var at_spire = false
var bosses_status = {
	"oranix" : false,
	"vajira" : false,
	"raa'sloth" : false,
	"salazar" : true,
}

func CreateIslandTemplate(map_size = Vector2(750,750)):
	var island_instance = load("res://Scenes/SupportScenes/Island/Island.tscn").instance()
	
	island_instance.server_ref = get_node("/root/Server")
	island_instance.map_size = map_size
	island_instance.GenerateIslandMap()
	if GameplayLoop.island_preloads.has(map_size):
		GameplayLoop.island_preloads[map_size].append(island_instance)
	else:
		GameplayLoop.island_preloads[map_size] = [island_instance]

func _physics_process(delta):
	var oranix = bosses_status["oranix"]
	var vajira = bosses_status["vajira"]
	var raasloth = bosses_status["raa'sloth"]
	var salazar = bosses_status["salazar"]
	
	var vessels_dead = not oranix and not vajira and not raasloth and not salazar and not at_spire
	var salazar_dead = not oranix and not vajira and not raasloth and not salazar and at_spire
	
	var server = get_node("/root/Server")
	
	if vessels_dead:
		server.get_node("Instances/nexus").OpenPortal("island", ["nexus"], server.get_node("Instances/nexus").GetBoatSpawnpoints(), Vector2(750,750), "salazar")
		at_spire = true
		bosses_status = {
			"oranix" : false,
			"vajira" : false,
			"raa'sloth" : false,
			"salazar" : true,
		}
	if salazar_dead:
		server.get_node("Instances/nexus").OpenPortal("island", ["nexus"], server.get_node("Instances/nexus").GetBoatSpawnpoints(), Vector2(750,750), "oranix")
		server.get_node("Instances/nexus").OpenPortal("island", ["nexus"], server.get_node("Instances/nexus").GetBoatSpawnpoints(), Vector2(750,750), "vajira")
		server.get_node("Instances/nexus").OpenPortal("island", ["nexus"], server.get_node("Instances/nexus").GetBoatSpawnpoints(), Vector2(750,750), "raa'sloth")
		at_spire = false
		bosses_status = {
			"oranix" : true,
			"vajira" : true,
			"raa'sloth" : true,
			"salazar" : false,
		}
