extends PanelContainer

func _ready():
	$MarginContainer/TextureButton.connect("pressed", self, "OpenClasses")

func OpenClasses():
	GameUI.Toggle("classes")

func _on_TouchScreenButton_pressed():
	GameUI.Toggle("classes")
