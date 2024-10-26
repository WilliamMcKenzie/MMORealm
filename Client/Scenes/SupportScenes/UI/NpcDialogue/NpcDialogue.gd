extends CanvasLayer

var mobile_versions = {
	"Use [WASD] to move." : "Drag on the left side of the screen to move.",
	"Click to attack. Take down those crabs!" : "Drag on the right side of the screen to attack. Take down those crabs!",
	"Press [SPACE] to use your helmet." : "Tap the helmet icon in the bottom right to use your helmet.",
	"Tap [R] to return to the port and head to the docks for your adventure." : "Tap the home button to return to the port and head to the docks for your adventure."
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
		"text" : ["Nice work! Tap the backpack icon to check your gear.", "Drag items to equip them.", "Run to the chest and equip a helmet!"],
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
		"text" : ["Hey there! The arena is a place to endlessly battle monsters...", "It starts easy, and gets harder the more waves you clear.", "Each wave also nets you gold! Don't worry about dying, if you die it will just send you to the port."],
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
	
	"Tutorial" : {
		"text" : ["I am the tutorial master...", "Anything you would like to know?"],
		"question" : ["Classes/Ascension", "Gameplay", "Death"],
		"character_rect" : Vector2(0,0),
	},
	"Death" : {
		"text" : ["When you die in game you will lose your character permanently...", "Each character can be revived for gold, but only once.", "I recommend storing valuable items in your home for when you die. You can enter the house portal to my left."],
		"character_rect" : Vector2(0,0),
	},
	"Gameplay" : {
		"text" : ["You can sail on boats to different kingdoms, which have been overtaken by monsters...", "By defeating them you can get items and level up!", "Each kingdom has a ruler at the center of the map which you need to defeat.", "If you are a beginner, I recommend following your quests around...", "They are the dark arrows pointing where you should go. Good luck!"],
		"character_rect" : Vector2(0,0),
	},
	"Classes/Ascension" : {
		"text" : ["Ascension allows you to increase your stats even further beyond level 20...", "To ascend, you need to consume ascension stones.", "Each tier of class has a max ascension limit:", "Tier 1 (apprentice) has a cap of 5 stones...", "Tier 2 has a cap of 50...", "And tier 3 has a cap of 75.", "Think about these classes like a tree...","You start with the apprentice (tier 1), then you can evolve into another class (tier 2), then that class can evolve into another class (tier 3)...", "You get the idea. To evolve you have to do certain quests like killing 3000 enemies...","you can find hints underneath each of the 3 evolutions in the classes page.", "To see the classes page click on the helmet button in the top right."],
		"character_rect" : Vector2(0,0),
	},
	
	"Limitbreak" : {
		"text" : ["Whats that? You want to get more powerful?", "Well I suppose I could give you a trial...", "What do you say?"],
		#"question" : ["I'm Ready!", "Not Yet", "Tell Me More"],
		"character_rect" : Vector2(40,0),
	},
	"NotMaxed" : {
		"text" : ["Whats that? You think your ready?", "Bahaha! Come back when you are fully ascended lowly bottomfeeder."],
		"character_rect" : Vector2(40,0),
	}
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
