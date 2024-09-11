extends CanvasLayer

var mobile_versions = {
	"To walk around, you can use [WASD] controls." : "To walk around, you can drag on the left side of the screen in the direction you want to go.",
	"To attack, simply click where you want to shoot with your left mouse button. Try to slay some crabs!" : "To attack, you can drag on the right side of the screen in the direction you want to shoot. Try to slay some crabs!",
	"Press [SPACE] to use your helmet." : "Press to helmet button in the bottom right to use your helmet.",
	"Press [R] to return the safety of the port, and head up to the docks to start your adventure." : "Press the home button in the bottom right to return the safety of the port, and head up to the docks to start your adventure.",
}

var subject_data = {
	"Intro" : {
		"text" : ["Hello adventurer, welcome to the kingdom!", "My name is Kingsly, and I will be showing you the ropes of fighting.", "First of course, you must choose a name."],
		"animation" : "ChooseName",
	},
	"Controls" : {
		"text" : ["Great, next let me teach you about the basics.", "To walk around, you can use [WASD] controls.", "To attack, simply click where you want to shoot with your left mouse button. Try to slay some enemies!"],
	},
	"Backpack" : {
		"text" : ["Good job! If you press the backpack icon in the top right, you can see your inventory and equipment.", "You can drag gear from slot to slot, to equip/put it into your inventory.", "Go ahead and run over to the chest and try to equip a helmet."],
		"animation" : "Backpack",
	},
	"Ability" : {
		"text" : ["Now that you have equipped a helmet, you can use it to get buffs.", "Helmets can have many different effects, but usually the metal helms boost armor...", "The archer caps boost your damage...", "And mage hats boost healing speed.", "Press [SPACE] to use your helmet."],
		"animation" : "Ability",
	},
	"Quest" : {
		"text" : ["Good job, I think you're ready to take on this island's ruler!", "By killing your quest monster, you get bonus EXP...", "Follow your quest to the center of the map and defeat the troll king!"],
		"animation" : "Quest",
	},  
	"Stats" : {
		"text" : ["Wow! You got an ascension stone, consuming it by double clicking gives you two things...", "First, it brings you closer to ascending, and when ascended you can evolve your class through quests.", "Second, it lets you increase your stats. To ascend might take a while...", "But you can level up your stats right now. Go ahead and consume it!"],
	},
	"Ascend" : {
		"text" : ["Good! Now you are one step closer to ascending...", "Go ahead and open up your stats, and press the plus to increase it by one!"],
		"animation" : "Stats",
	},
	"Final" : {
		"text" : ["Good job, this Kingdom will forever be grateful for your efforts.", "You have now unlocked achievements, ascension, and the port.", "Press [R] to return the safety of the port, and head up to the docks to start your adventure."],
		"animation" : "Final",
	},
}
var subject = null
var speech_index = null

var last_start = 0
var last_click = 0
func _input(event):
	if self.visible and (event is InputEventMouseButton or event is InputEventScreenTouch):
		var spamming = OS.get_system_time_msecs() - last_click < 500
		var misclick = OS.get_system_time_msecs() - last_start < 1000
		
		if not spamming and not misclick:
			last_click = OS.get_system_time_msecs()
			Talk()

func StartSubject(_subject):
	if not _subject:
		return
	
	self.visible = true
	subject = _subject
	speech_index = 0
	last_start = OS.get_system_time_msecs()
	Talk()

func Talk():
	#Finished
	if subject_data[subject].text.size() == speech_index:
		if subject_data[subject].has("animation"):
			GameUI.get_node("TutorialAnimations").play(subject_data[subject].animation)
		self.visible = false
		speech_index = 0
		return
	#Otherwise
	else:
		var sentence = subject_data[subject].text[speech_index]
		speech_index += 1
		if str(OS.get_model_name()) != 'GenericDevice' and mobile_versions.has(sentence):
			sentence = mobile_versions[sentence]
		
		$Animations.play("Talk")
		$PanelContainer/MarginContainer/Label.text = sentence
