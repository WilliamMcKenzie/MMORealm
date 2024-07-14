extends PanelContainer

func _ready():
	$MarginContainer/TextureButton.connect("pressed", self, "OpenAchievements")

func OpenAchievements():
	GameUI.Toggle("achievements")

func _on_TouchScreenButton_pressed():
	GameUI.Toggle("achievements")
