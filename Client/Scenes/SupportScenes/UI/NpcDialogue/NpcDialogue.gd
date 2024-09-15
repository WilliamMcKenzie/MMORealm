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
		"character_rect" : Vector2(0,0),
	},
	"Controls" : {
		"text" : ["Great, next let me teach you about the basics.", "To walk around, you can use [WASD] controls.", "To attack, simply click where you want to shoot with your left mouse button. Try to slay some enemies!"],
		"character_rect" : Vector2(0,0),
	},
	"Backpack" : {
		"text" : ["Good job! If you press the backpack icon in the top right, you can see your inventory and equipment.", "You can drag gear from slot to slot, to equip/put it into your inventory.", "Go ahead and run over to the chest and try to equip a helmet."],
		"animation" : "Backpack",
		"character_rect" : Vector2(0,0),
	},
	"Ability" : {
		"text" : ["Now that you have equipped a helmet, you can use it to get buffs.", "Helmets can have many different effects, but usually the metal helms boost armor...", "The archer caps boost your damage...", "And mage hats boost healing speed.", "Press [SPACE] to use your helmet."],
		"animation" : "Ability",
		"character_rect" : Vector2(0,0),
	},
	"Quest" : {
		"text" : ["Good job, I think you're ready to take on this island's ruler!", "By killing your quest monster, you get bonus EXP...", "Follow your quest to the center of the map and defeat the troll king!"],
		"animation" : "Quest",
		"character_rect" : Vector2(0,0),
	},  
	"Stats" : {
		"text" : ["Wow! You got an ascension stone, consuming it by double clicking gives you two things...", "First, it brings you closer to ascending, and when ascended you can evolve your class through quests.", "Second, it lets you increase your stats. To ascend might take a while...", "But you can level up your stats right now. Go ahead and consume it!"],
		"character_rect" : Vector2(0,0),
	},
	"Ascend" : {
		"text" : ["Good! Now you are one step closer to ascending...", "Go ahead and open up your stats, and press the plus to increase it by one!"],
		"animation" : "Stats",
		"character_rect" : Vector2(0,0),
	},
	"Final" : {
		"text" : ["Good job, this Kingdom will forever be grateful for your efforts.", "You have now unlocked achievements, ascension, and the port.", "Press [R] to return the safety of the port, and head up to the docks to start your adventure."],
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
