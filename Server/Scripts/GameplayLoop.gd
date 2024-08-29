extends Node

var at_spire = false
var bosses_status = {
	"oranix" : true,
	"vajira" : true,
	"raa'sloth" : true,
	"salazar" : false,
}

func _physics_process(delta):
	var oranix = bosses_status["oranix"]
	var vajira = bosses_status["vajira"]
	var raasloth = bosses_status["raa'sloth"]
	var salazar = bosses_status["salazar"]
	
	var vessels_dead = not oranix and not at_spire
	var salazar_dead = not oranix and not vajira and not raasloth and not salazar and at_spire
	
	var server = get_node("/root/Server")
	
	if vessels_dead:
		server.get_node("Instances/nexus").OpenPortal("island", ["nexus"], server.get_node("Instances/nexus").GetBoatSpawnpoints(), Vector2(1000,1000), "salazar")
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