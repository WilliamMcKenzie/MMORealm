extends Node2D

onready var CharacterSpriteEle = $Button/Character
onready var LevelEle = $Button/ResizeContainer/Level
onready var WeaponEle = $Button/ItemsResizeContainer/Weapon
onready var AbilityEle = $Button/ItemsResizeContainer/Ability
onready var ArmorEle = $Button/ItemsResizeContainer/Armor
onready var RingEle = $Button/ItemsResizeContainer/Ring
onready var containerButton = $Button

var character
var characterPath = ["characters/characters_8x8.png", 13, 26, 0]
var level = 20
var _class = "Piker"
var weaponPath = ["items/items_8x8.png", 26, 26, 60]
var abilityPath = ["items/items_8x8.png", 26, 26, 83]
var armorPath = ["items/items_8x8.png", 26, 26, 113]
var ringPath = ["items/items_8x8.png", 26, 26, 0]

func AssignParameters(_character):
	character = _character
	characterPath = character.path
	level = character.level
	_class = character.class
	weaponPath = character.gear.weapon.path
	abilityPath = character.gear.ability.path
	armorPath = character.gear.armor.path
	ringPath = character.gear.ring.path
	
func _ready():
	LevelEle.text = _class + " - Level " + str(level)
	setSpriteData(CharacterSpriteEle, characterPath)
	setSpriteData(WeaponEle, weaponPath)
	setSpriteData(AbilityEle, abilityPath)
	setSpriteData(ArmorEle, armorPath)
	setSpriteData(RingEle, ringPath)
	containerButton.connect("pressed", self, "enterGame")
	
func setSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0]) 
	sprite.texture = spriteTexture
	sprite.hframes = path[1]
	sprite.vframes = path[2]
	sprite.frame = path[3]

func enterGame():
	get_parent().get_parent().enterGame(character)
