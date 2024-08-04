extends CanvasLayer

var username = ""
var animation_played = false

func _ready():
	$MarginContainer/Container/InputContainer/NameContainter/Name/MarginContainer/Name.connect("focus_entered", self, "EnterChat")
	$MarginContainer/Container/InputContainer/NameContainter/Name/MarginContainer/Name.connect("focus_exited", self, "ExitChat")

func EnterChat():
	GameUI.in_chat = true
func ExitChat():
	GameUI.in_chat = false

func _process(delta):
	if self.visible and not animation_played:
		$AnimationPlayer.play("Init")
		animation_played = true

func _on_Name_text_changed(new_text):
	username = new_text
	if len(username) > 10:
		$MarginContainer/Container/InputContainer/NameContainter/NameWarning.text = "Too long!"
	elif len(username) == 0:
		$MarginContainer/Container/InputContainer/NameContainter/NameWarning.text = "Name cannot be blank!"
	elif not username.is_valid_identifier():
		$MarginContainer/Container/InputContainer/NameContainter/NameWarning.text = "Invalid characters!"
	else:
		$MarginContainer/Container/InputContainer/NameContainter/NameWarning.text = ""

func _on_Confirm_pressed():
	if $MarginContainer/Container/InputContainer/NameContainter/NameWarning.text == "":
		Server.ChooseUsername(username)
