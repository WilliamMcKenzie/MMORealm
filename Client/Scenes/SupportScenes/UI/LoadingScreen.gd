extends CanvasLayer

var waiting = false

func StartWaiting():
	if $LoadingAnimations.is_playing():
		return
	waiting = true
	$LoadingAnimations.play("Waiting")
	$BG.visible = true
	$Cycle.visible = true
	
func EndWaiting():
	if not waiting:
		return
	$LoadingAnimations.stop()
	$BG.visible = false
	$Cycle.visible = false
	waiting = false

var last_place = "Alphabetium Palace"
func Transition(place):
	last_place = place
	$LoadingAnimations.stop()
	$LoadingAnimations.play("Transition")
	$Label.visible = true
	$BG.visible = true
	$Label.text = place
	yield(get_tree().create_timer(2), "timeout")
	if last_place == place:
		$Label.visible = false
		$BG.visible = false