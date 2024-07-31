extends CanvasLayer

var subject_data = {
	"Intro" : {
		"text" : ["Hello adventurer, welcome to the kingdom!", "My name is Kingsly, and I will be showing you the ropes of fighting.", "First of course, you must choose a name."],
		"animation" : "ChooseName",
	},
	"Backpack" : {
		"text" : ["If you press the backpack icon in the top right, you can see your inventory and equipment.", "You can drag gear from slot to slot, to equip/put it into your inventory.", "Go ahead and run over to a bag, try to loot some gear."],
		"animation" : "Backpack",
	},
	"Ability" : {
		"text" : ["Now that you have equipped a helmet, you can use it to get buffs.", "Helmets can have many different effects, but usually the metal helms boost armor...", "The archer caps boost your damage...", "And mage hats boost healing speed.", "Press [SPACE] on computer, or the helmet button on mobile to use your helmet."],
		"animation" : "Ability",
	},
	"Stats" : {
		"text" : ["Wow! You got an ascension stone, consuming it [DOUBLE CLICK] gives you two things.", "First, it brings you closer to ascending, and when ascended you can evolve your class through quests.", "Second, it lets you increase your stats. To ascend might take a while...", "But you can level up your stats right now. Go ahead and see!"],
		"animation" : "Stats",
	},
	"Final" : {
		"text" : ["Good job, this Kingdom will forever be grateful for your efforts.", "You have now unlocked achievements, ascension, and the port.", "Press [R] on computer, or the home button on mobile to return the safety of the port and start your adventure."],
		"animation" : "Final",
	},
}
var next_subject = ""
var subject = null
var speech_index = null

var last_click = 0
func _input(event):
	if self.visible and (event is InputEventMouseButton or event is InputEventScreenTouch):
		var spamming = OS.get_system_time_msecs() - last_click < 500
		
		if not spamming:
			last_click = OS.get_system_time_msecs()
			Talk()
			speech_index += 1

func StartSubject(_subject):
	yield(get_tree().create_timer(3), "timeout")
	if not _subject:
		return
	
	next_subject = null
	var is_next = false
	for subject in subject_data.keys():
		if is_next:
			next_subject = subject
			break
		if subject == _subject:
			is_next = true
	
	self.visible = true
	subject = _subject
	speech_index = 0
	Talk()
	speech_index += 1

func Talk():
	#Finished
	if subject_data[subject].text.size() == speech_index:
		if subject_data[subject].has("animation"):
			GameUI.get_node("TutorialAnimations").play(subject_data[subject].animation)
		self.visible = false
		StartSubject(next_subject)
		speech_index = 0
		return
	#Otherwise
	else:
		var sentence = subject_data[subject].text[speech_index]
		$Animations.play("Talk")
		$PanelContainer/MarginContainer/Label.text = sentence
