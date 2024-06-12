extends Node2D

onready var CharacterSpriteEle = $Button/Character
onready var LevelEle = $Button/ResizeContainer/Level
onready var WeaponEle = $Button/ItemsResizeContainer/Weapon
onready var AbilityEle = $Button/ItemsResizeContainer/Helm
onready var ArmorEle = $Button/ItemsResizeContainer/Armor
onready var containerButton = $Button

var character
var character_index

var characterPath = ["characters/characters_8x8.png", 13, 26, Vector2(0,0)]
var level = 1
var _class = "Apprentice"
var weaponPath = ["items/items_8x8.png", 26, 26, Vector2(0,9)]
var abilityPath = ["items/items_8x8.png", 26, 26, Vector2(0,9)]
var armorPath = ["items/items_8x8.png", 26, 26, Vector2(0,9)]

func AssignParameters(_character):
	var gear = _character.gear
	character = _character
	
	characterPath = character.path
	level = character.level
	_class = character.class
	
	if gear.has("weapon"):
		weaponPath = character.gear.weapon.path
	if gear.has("helmet"):
		abilityPath = character.gear.helm.path
	if gear.has("armor"):
		armorPath = character.gear.armor.path
	
func _ready():
	LevelEle.text = _class + " - Level " + str(level)
	SetSpriteData(CharacterSpriteEle, characterPath)
	SetSpriteData(WeaponEle, weaponPath)
	SetSpriteData(ArmorEle, armorPath)
	containerButton.connect("pressed", self, "EnterGame")
	
func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0]) 
	print(path[0])
	sprite.texture = spriteTexture
	sprite.hframes = path[1]
	sprite.vframes = path[2]
	sprite.frame_coords = path[3]

func EnterGame():
	get_parent().get_parent().EnterGame(character_index, character)
