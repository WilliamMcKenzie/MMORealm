extends CanvasLayer

var stat_bar = preload("res://Scenes/SupportScenes/UI/Stats/Stat.tscn")

func _ready():
	$NearbyBackground.connect("button_down", self, "ToggleNearby")
	$NearbyContainer/CloseButton.connect("pressed", self, "ToggleNearby")
	Open()

func ToggleNearby():
	get_parent().Toggle("nearby")

func Open():
	var nearby_tween = $NearbyTween
	var nearby_element = $NearbyContainer
	
	nearby_tween.interpolate_property(nearby_element, "rect_position", nearby_element.rect_position, Vector2(-280, 0)+nearby_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	nearby_tween.start()
	
	var timer = Timer.new()
	timer.wait_time = 0.4
	timer.one_shot = true
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	
	$NearbyBackground.visible = true

func Close():
	var nearby_tween = $NearbyTween
	var nearby_element = $NearbyContainer
	
	nearby_tween.interpolate_property(nearby_element, "rect_position", nearby_element.rect_position, Vector2(280, 0)+nearby_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	nearby_tween.start()
	$NearbyBackground.visible = false
