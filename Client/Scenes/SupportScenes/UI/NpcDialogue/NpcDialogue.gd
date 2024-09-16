extends CanvasLayer

var mobile_versions = {
	"To walk around, you can use [WASD] controls." : "Drag on the left side to move.",
	"To attack click where you want to shoot. Try to slay some crabs!" : "Drag on the right side to attack. Take down some crabs!",
	"Press [SPACE] to use your helmet." : "Tap the helmet icon in the bottom right to activate it.",
	"Press [R] to return the safety of the port, and head up to the docks to start your adventure." : "Tap the home icon to return to the port, then head to the docks to begin your journey."
}

var subject_data = {
	"Intro" : {
		"text" : ["Welcome to the kingdom, adventurer!", "I'm Kingsly, your guide to combat. First, pick a name!"],
		"animation" : "ChooseName",
		"character_rect" : Vector2(0,0),
	},
	"Controls" : {
		"text" : ["Let's start with the basics.", "Use [WASD] to move.", "Click to attack. Take down those crabs!"],
		"character_rect" : Vector2(0,0),
	},
	"Backpack" : {
		"text" : ["Nice work! Tap the backpack icon to check your gear.", "Drag items to equip them.", "Equip a helmet from the chest!"],
		"animation" : "Backpack",
		"character_rect" : Vector2(0,0),
	},
	"Ability" : {
		"text" : ["Helmets give you buffs.", "Metal helmets boost armor, archer caps boost damage, mage hats boost healing.", "Press [SPACE] to use your helmet."],
		"animation" : "Ability",
		"character_rect" : Vector2(0,0),
	},
	"Quest" : {
		"text" : ["You're ready for a challenge!", "Defeat the quest boss for bonus EXP.", "Find the troll king at the center of the map!"],
		"animation" : "Quest",
		"character_rect" : Vector2(0,0),
	},  
	"Stats" : {
		"text" : ["You found an ascension stone!", "Go loot it then double click to consume it."],
		"character_rect" : Vector2(0,0),
	},
	"Ascend" : {
		"text" : ["Go ahead and open up your stats, and press the plus to increase it by one!"],
		"animation" : "Stats",
		"character_rect" : Vector2(0,0),
	},
	"Final" : {
		"text" : ["Great job! You've unlocked achievements, ascension, and the port.", "Tap [R] to return to the port and head to the docks for your adventure."],
		"animation" : "Final",
		"character_rect" : Vector2(0,0),
	},
	
	"Arena" : {
		"text" : ["Hey there! The arena is a place to endlessly battle monsters...", "It starts easy, and gets harder the more waves you clear.", "Each wave also nets you gold! Don't worry about dying, if you die it will just send you to the nexus."],
		"question" : ["Daily Arena", "Monthly Arena"],
		"character_rect" : Vector2(20,0),
	},
	"ArenaToSoon" : {
		"text" : ["You've already done this arena recently...", "What, do you think I'm made of money?"],
		"character_rect" : Vector2(20,0),
	},
	"FinishedArena" : {
		"text" : ["Haha! You put on a good show out there.", "Here's your gold, I'll be seeing ya!"],
		"character_rect" : Vector2(20,0),
	},
}
var subject = null
var speech_index = null

var last_start = 0
var last_click = 0

func _ready():
	var i = 0
	$Questions/ExitButton.connect("pressed", self, "Exit")
	$Questions/ExitButton/TouchScreenButton.connect("pressed", self, "Exit")
	for question in $Questions/HBoxContainer.get_children():
		question.get_node("MarginContainer/Button").connect("pressed", self, "SelectOption", [i])
		i += 1

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
	$Character.texture.region.position = subject_data[subject].character_rect
	Talk()

func Questionaire(questions):
	speech_index += 1
	$Animations.play("Questions")
	var i = 0
	for question in $Questions/HBoxContainer.get_children():
		if len(questions) > i:
			question.get_node("MarginContainer/Button/Label").text = questions[i]
			question.visible = true
			i += 1
		else:
			question.visible = false

func Talk():
	if subject_data[subject].text.size() < speech_index:
		return
	#Finished
	elif subject_data[subject].text.size() == speech_index:
		if subject_data[subject].has("animation"):
			GameUI.get_node("TutorialAnimations").play(subject_data[subject].animation)
		if subject_data[subject].has("question"):
			Questionaire(subject_data[subject].question)
		else:
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
		$Text/PanelContainer/MarginContainer/Label.text = sentence

func Exit():
	self.visible = false
	speech_index = 0

func SelectOption(i):
	Server.DialogueResponse(subject_data[subject].question[i])
	self.visible = false
	speech_index = 0
