extends TouchScreenButton

func _ready():
	connect("pressed", self, "Pressed")
	
func Pressed():
	print("PRESSEDDD")
