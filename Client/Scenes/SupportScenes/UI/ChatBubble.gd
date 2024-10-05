extends Node2D
var timer = 0

func _physics_process(delta):
	timer += delta
	if timer > 4:
		self.visible = false

func Update(_id, text):
	self.visible = true
	$PanelContainer/MarginContainer/Label.text = text
	timer = 0
