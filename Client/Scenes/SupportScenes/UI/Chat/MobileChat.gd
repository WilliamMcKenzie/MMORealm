extends CanvasLayer

var origin
func Open(_origin):
	origin = _origin
	$PanelContainer2.visible = true

func _on_ChatInput_text_entered(new_text):
	origin.text = new_text
	origin.emit_signal("text_entered", [new_text])

func _on_ChatInput_focus_exited():
	$PanelContainer2.visible = false
