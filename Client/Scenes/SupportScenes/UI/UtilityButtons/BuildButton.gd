extends PanelContainer

func _ready():
	$MarginContainer/TouchScreenButton.connect("pressed", self, "OpenBuilding")
	$MarginContainer/TextureButton.connect("pressed", self, "OpenBuilding")

func _physics_process(delta):
	if len(Server.current_instance_tree) > 1 and Server.current_instance_tree[1] == "house " + str(Server.get_tree().get_network_unique_id()):
		visible = true
	else:
		visible = false

func OpenBuilding():
	GameUI.Toggle("building")
