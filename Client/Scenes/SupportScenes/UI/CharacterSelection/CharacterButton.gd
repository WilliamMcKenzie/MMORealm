extends Control

onready var CharacterSpriteEle = $PanelContainer/MarginContainer/VBoxContainer/CharacterContainer/Character
onready var InfoEle = $PanelContainer/MarginContainer/VBoxContainer/Info
onready var PlayButton = $Play

var gear = {}
var character
var character_index

var characterPath = ["characters/characters_8x8.png", 13, 26, Vector2(0,0)]
var level = 1
var character_class = "Apprentice"

func AssignParameters(_character):
	character = _character
	
	characterPath = ClientData.GetCharacter(character.class).path
	level = character.level
	character_class = character.class
	
	for slot in character.gear.keys():
		if character.gear[slot] != null:
			gear[slot] = ClientData.GetItem(int(character.gear[slot].item))

func _ready():
	InfoEle.text = character_class + " - Level " + str(level)
	CharacterSpriteEle.SetCharacterClass(character_class)
	if character.gear.has("weapon") and character.gear.weapon != null: 
		CharacterSpriteEle.SetCharacterWeapon(ClientData.GetItem(character.gear.weapon.item).type)
	
	SetSpriteData(CharacterSpriteEle, characterPath)
	CharacterSpriteEle.ColorGear(gear)
	
	PlayButton.connect("pressed", self, "EnterGame")
	
func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0]) 
	sprite.texture = spriteTexture
	sprite.hframes = path[1]
	sprite.vframes = path[2]
	sprite.frame_coords = path[3]

func EnterGame():
	get_parent().get_parent().EnterGame(character_index, character)
