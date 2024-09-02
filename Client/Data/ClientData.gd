extends Node

var current_class = "Apprentice"

#Tile data
var unique_tiles = {
	0 : 0,
	1 : 0.5,
}

var basic_loot_pools = {
	"none" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"lowlands_1" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"lowlands_2" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"midlands_1" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"midlands_2" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"highlands_1" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"highlands_2" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"godlands_1" : {
		"soulbound_loot" : [
			{
				"item" : 0,
				"chance" : 0.05,
				"threshold" : 0.5,
			},
		],
		"loot" : []
	},
	"ruler_1" : {
		"soulbound_loot" : [
			{
				"item" : 0,
				"chance" : 0.3,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"encounter_1" : {
		"soulbound_loot" : [
			{
				"item" : 0,
				"chance" : 0.5,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"encounter_2" : {
		"soulbound_loot" : [
			{
				"item" : 0,
				"chance" : 1,
				"threshold" : 0.1,
			},
		],
		"loot" : []
	},
}
var special_loot_pools = {
	"oranix" : {
		"override" : "ruler_1",
		"soulbound_loot" : [
			{
				"item" : 105,
				"chance" : 0.003,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"vajira" : {
		"override" : "ruler_1",
		"soulbound_loot" : [
			{
				"item" : 105,
				"chance" : 0.003,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"raa'sloth" : {
		"override" : "ruler_1",
		"soulbound_loot" : [
			{
				"item" : 105,
				"chance" : 0.003,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"vigil_guardian" : {
		"override" : "encounter_1",
		"soulbound_loot" : [
			{
				"item" : 105,
				"chance" : 0.003,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"atlas" : {
		"override" : "encounter_2",
		"soulbound_loot" : [
			{
				"item" : 105,
				"chance" : 0.003,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"salazar" : {
		"override" : "encounter_2",
		"soulbound_loot" : [
			{
				"item" : 105,
				"chance" : 0.003,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"salazar_awakened" : {
		"override" : "encounter_2",
		"soulbound_loot" : [
			{
				"item" : 105,
				"chance" : 0.003,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
}
var projectile_databank = {
	"RoyalSlash_strong_medium" : {
		"projectile" : "RoyalSlash",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : 20,
		"tile_range" : 7,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 9
	},
	"RoyalSlash_mid_fast" : {
		"projectile" : "RoyalSlash",
		"formula" : "0",
		"damage" : 80,
		"piercing" : false,
		"wait" : 0,
		"speed" : 30,
		"tile_range" : 7,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 9
	},
	"GiantRoyalSlash_strong_medium" : {
		"projectile" : "GiantRoyalSlash",
		"formula" : "0",
		"damage" : 200,
		"piercing" : false,
		"wait" : 0,
		"speed" : 25,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 9
	},
	"RoyalSlash_strong_fast_short" : {
		"projectile" : "RoyalSlash",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : 45,
		"tile_range" : 3,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 9
	},
	"GiantAbyssSpinner_strong_medium" : {
		"projectile" : "GiantAbyssSpinner",
		"formula" : "0",
		"damage" : 180,
		"piercing" : false,
		"wait" : 0,
		"speed" : 20,
		"tile_range" : 9,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 9
	},
	"GiantAbyssSpinner_strong_slow" : {
		"projectile" : "GiantAbyssSpinner",
		"formula" : "0",
		"damage" : 180,
		"piercing" : false,
		"wait" : 0,
		"speed" : 10,
		"tile_range" : 9,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 9
	},
	"GiantAbyssSpinner_mid_fast" : {
		"projectile" : "GiantAbyssSpinner",
		"formula" : "0",
		"damage" : 120,
		"piercing" : false,
		"wait" : 0,
		"speed" : 35,
		"tile_range" : 9,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 9
	},
	"AbyssSpinner_mid_fast" : {
		"projectile" : "AbyssSpinner",
		"formula" : "0",
		"damage" : 60,
		"piercing" : false,
		"wait" : 0,
		"speed" : 35,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 7
	},
	"AbyssSpinner_strong_medium" : {
		"projectile" : "AbyssSpinner",
		"formula" : "0",
		"damage" : 120,
		"piercing" : false,
		"wait" : 0,
		"speed" : 15,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 7
	},
	"GreenBlast_1" : {
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 4,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : 8
					},
	"None" : {
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 0,
						"piercing" : true,
						"wait" : 1000,
						"speed" : 0,
						"tile_range" : 0,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
	},
	"GiantIceSlash_mid_slow" : {
		"projectile" : "GiantIceSlash",
		"formula" : "0",
		"damage" : 120,
		"piercing" : false,
		"wait" : 0,
		"speed" : 10,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 9
	},
	"GiantIceSlash_strong_fast" : {
		"projectile" : "GiantIceSlash",
		"formula" : "0",
		"damage" : 180,
		"piercing" : false,
		"wait" : 0,
		"speed" : 30,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 9
	},
	"GiantIceSlash_strong_medium" : {
		"projectile" : "GiantIceSlash",
		"formula" : "0",
		"damage" : 180,
		"piercing" : false,
		"wait" : 0,
		"speed" : 15,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 9
	},
	"IceSlash_strong_fast" : {
		"projectile" : "IceSlash",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : 30,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 7
	},
	"IceSlash_strong_medium" : {
		"projectile" : "IceSlash",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : 15,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 7
	},
	"Ball_strong_slow" : {
		"projectile" : "Ball",
		"formula" : "0",
		"damage" : 80,
		"piercing" : false,
		"wait" : 0,
		"speed" : 10,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 7
	},
	"Ball_mid_fast" : {
		"projectile" : "Ball",
		"formula" : "0",
		"damage" : 50,
		"piercing" : false,
		"wait" : 0,
		"speed" : 30,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 7
	},
	"GiantBall_strong_slow" : {
		"projectile" : "GiantBall",
		"formula" : "0",
		"damage" : 200,
		"piercing" : true,
		"wait" : 0,
		"speed" : 10,
		"tile_range" : 7,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 8
	},
	"GiantBall_mid_fast" : {
		"projectile" : "GiantBall",
		"formula" : "0",
		"damage" : 140,
		"piercing" : true,
		"wait" : 0,
		"speed" : 40,
		"tile_range" : 7,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 8
	},
	"FlameArrow_strong_fast_short" : {
		"projectile" : "FlameArrow",
		"formula" : "0",
		"damage" : 100,
		"piercing" : true,
		"wait" : 0,
		"speed" : 50,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 7
	},
	"FlameBurst_strong_fast" : {
		"projectile" : "FlameBurst",
		"formula" : "0",
		"damage" : 80,
		"piercing" : false,
		"wait" : 0,
		"speed" : 50,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 7
	},
	"FlameBurst_strong_slow" : {
		"projectile" : "FlameBurst",
		"formula" : "0",
		"damage" : 80,
		"piercing" : false,
		"wait" : 0,
		"speed" : 20,
		"tile_range" : 9,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 7
	},
	"FlameBurst_medium_fast" : {
		"projectile" : "FlameBurst",
		"formula" : "0",
		"damage" : 60,
		"piercing" : false,
		"wait" : 0,
		"speed" : 50,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 7
	},
	"FlameBurst_weak_fast" : {
		"projectile" : "FlameBurst",
		"formula" : "0",
		"damage" : 40,
		"piercing" : false,
		"wait" : 0,
		"speed" : 50,
		"tile_range" : 9,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 7
	},
	"GiantFlameArrow_strong_medium" : {
		"projectile" : "GiantFlameArrow",
		"formula" : "0",
		"damage" : 160,
		"piercing" : true,
		"wait" : 0,
		"speed" : 30,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 9
	},
	"GiantFlameArrow_strong_fast" : {
		"projectile" : "GiantFlameArrow",
		"formula" : "0",
		"damage" : 160,
		"piercing" : true,
		"wait" : 0,
		"speed" : 50,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 9
	},
	"FlameArrow_strong_fast" : {
		"projectile" : "FlameArrow",
		"formula" : "0",
		"damage" : 100,
		"piercing" : true,
		"wait" : 0,
		"speed" : 60,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 7
	},
	"FlameArrow_mid_fast" : {
		"projectile" : "FlameArrow",
		"formula" : "0",
		"damage" : 80,
		"piercing" : true,
		"wait" : 0,
		"speed" : 50,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 7
	},
	"FlameBlast_strong_slow" : {
		"projectile" : "FlameBlast",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : 15,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 7
	},
	"FlameBlast_strong_fast" : {
		"projectile" : "FlameBlast",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : 50,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 7
	},
	"GiantFlameBlast_strong_fast" : {
		"projectile" : "GiantFlameBlast",
		"formula" : "0",
		"damage" : 140,
		"piercing" : false,
		"wait" : 0,
		"speed" : 40,
		"tile_range" : 40,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 9
	},
	"GiantFlameBlast_strong_medium" : {
		"projectile" : "GiantFlameBlast",
		"formula" : "0",
		"damage" : 140,
		"piercing" : false,
		"wait" : 0,
		"speed" : 30,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 9
	},
	"Slash_1" : {
		"projectile" : "Slash",
		"formula" : "0",
		"damage" : 2,
		"piercing" : false,
		"wait" : 3,
		"speed" : 10,
		"tile_range" : 3,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 8
	},
	"GiantBlast_slow" : {
		"projectile" : "GiantBlast",
		"formula" : "0",
		"damage" : 150,
		"piercing" : true,
		"wait" : 0,
		"speed" : 8,
		"tile_range" : 20,
		"targeter" : "nearest",
		"direction" : Vector2.ZERO,
		"size" : 9
	},
	"GiantBlast_medium" : {
		"inherit" : "GiantBlast_slow",
		"speed" : 20,
	},
	"GiantBlast_fast" : {
		"inherit" : "GiantBlast_slow",
		"speed" : 40,
	},
	"SmallBlast_strong_fast" : {
		"projectile" : "SmallBlast",
		"formula" : "0",
		"damage" : 80,
		"piercing" : false,
		"wait" : 0.1,
		"speed" : 60,
		"tile_range" : 15,
		"targeter" : "nearest",
		"direction" : DegreesToVector(-45),
		"size" : 7
	},
	"Blast_strong_fast" : {
		"projectile" : "Blast",
		"formula" : "0",
		"damage" : 120,
		"piercing" : false,
		"wait" : 0.1,
		"speed" : 50,
		"tile_range" : 15,
		"targeter" : "nearest",
		"direction" : DegreesToVector(-5),
		"size" : 7
	},
	"VigilBlastSmall_1" : {
		"projectile" : "VigilBlastSmall",
		"formula" : "0",
		"damage" : 45,
		"piercing" : false,
		"wait" : 0,
		"speed" : 25,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : Vector2.ZERO,
		"size" : 7
	},
	"VigilBlastSmall_strong_fast" : {
		"projectile" : "VigilBlastSmall",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : 60,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : Vector2.ZERO,
		"size" : 7
	},
	"VigilBlastSmall_slow" : {
		"inherit" : "VigilBlastSmall_1",
		"speed" : 15,
	},
	"VigilBlast_strong_fast" : {
		"projectile" : "VigilBlast",
		"formula" : "0",
		"damage" : 190,
		"piercing" : true,
		"wait" : 0,
		"speed" : 60,
		"tile_range" : 15,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 7
	},
	"Wave_strong_fast" : {
		"projectile" : "Wave",
		"formula" : "0",
		"damage" : 120,
		"piercing" : true,
		"wait" : 0,
		"speed" : 70,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : 7
	},
	"Wave_mid_fast" : {
		"inherit" : "Wave_strong_fast",
		"damage" : 70,
	},
	"Wave_weak_fast" : {
		"inherit" : "Wave_strong_fast",
		"damage" : 30,
	},
	"Wave_strong_slow" : {
		"inherit" : "Wave_strong_fast",
		"damage" : 120,
		"speed" : 30,
	},
	"Wave_mid_slow" : {
		"inherit" : "Wave_strong_fast",
		"damage" : 70,
		"speed" : 30,
		"tile_range" : 12,
	},
	"Wave_weak_slow" : {
		"inherit" : "Wave_strong_fast",
		"damage" : 30,
		"speed" : 30,
	},
	"NeonArrow_mid_slow" : {
		"projectile" : "NeonArrow",
		"formula" : "0",
		"damage" : 40,
		"piercing" : true,
		"wait" : 0,
		"speed" : 20,
		"tile_range" : 10,
		"direction" : DegreesToVector(0),
		"size" : 5
	},
	"NeonArrow_mid_fast" : {
		"projectile" : "NeonArrow",
		"formula" : "0",
		"damage" : 70,
		"piercing" : true,
		"wait" : 0,
		"speed" : 70,
		"tile_range" : 10,
		"direction" : DegreesToVector(0),
		"size" : 5
	},
	"NeonStar_strong_fast" : {
		"projectile" : "NeonStar",
		"formula" : "0",
		"damage" : 100,
		"piercing" : true,
		"wait" : 0,
		"speed" : 70,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : DegreesToVector(30),
		"size" : 5
	},
	"NeonStar_mid_fast" : {
		"projectile" : "NeonStar",
		"formula" : "0",
		"damage" : 70,
		"piercing" : true,
		"wait" : 0,
		"speed" : 70,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : DegreesToVector(30),
		"size" : 5
	},
	"NeonStar_weak_fast" : {
		"projectile" : "NeonStar",
		"formula" : "0",
		"damage" : 50,
		"piercing" : true,
		"wait" : 0,
		"speed" : 70,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : DegreesToVector(30),
		"size" : 5
	},
	"GoldDart_strong_fast" : {
		"projectile" : "GoldDart",
		"formula" : "0",
		"damage" : 250,
		"piercing" : true,
		"wait" : 0,
		"speed" : 20,
		"tile_range" : 15,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : 9
	},
	"Dart_strong_fast" : {
		"projectile" : "Dart",
		"formula" : "0",
		"damage" : 160,
		"piercing" : true,
		"wait" : 0,
		"speed" : 60,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : 6
	},
	"Dart_mid_fast" : {
		"projectile" : "Dart",
		"formula" : "0",
		"damage" : 80,
		"piercing" : true,
		"wait" : 0,
		"speed" : 60,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : 6
	},
	"Ring_strong_slow" : {
		"projectile" : "Ring",
		"formula" : "0",
		"damage" : 250,
		"piercing" : false,
		"wait" : 0,
		"speed" : 30,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : 8
	},
	"Star_strong_slow" : {
		"projectile" : "Star",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : 20,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : 7
	},
	"Star_strong_medium" : {
		"projectile" : "Star",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : 30,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : 7
	},
	"Spinner_strong_medium" : {
		"projectile" : "Spinner",
		"formula" : "0",
		"damage" : 140,
		"piercing" : true,
		"wait" : 0,
		"speed" : 40,
		"tile_range" : 10,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : 7
	},
	"GiantSpinner_strong_medium" : {
		"projectile" : "GiantSpinner",
		"formula" : "0",
		"damage" : 300,
		"piercing" : true,
		"wait" : 0,
		"speed" : 40,
		"tile_range" : 10,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : 9
	},
	"Fire1_strong_fast" : {
		"projectile" : "Fire1",
		"formula" : "0",
		"damage" : 50,
		"piercing" : false,
		"wait" : 0,
		"speed" : 60,
		"tile_range" : 7,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : 7
	},
	"Fire2_strong_fast" : {
		"projectile" : "Fire2",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : 60,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : 7
	},
	"Fire3_strong_fast" : {
		"projectile" : "Fire3",
		"formula" : "0",
		"damage" : 160,
		"piercing" : false,
		"wait" : 0,
		"speed" : 60,
		"tile_range" : 9,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : 7
	},
	"Stack_strong_medium" : {
		"projectile" : "Stack",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : 40,
		"tile_range" : 9,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : 7
	},
}

func _ready():
	#Achievements
	for achievement in achievements:
		var data = achievements[achievement]
		if data.which == "enemies_killed" and data.has("enemies"):
			enemies_tracked += data.enemies
	
	
	#Loot pools
	
	var high_chance = 0.15
	var decent_chance = 0.1
	var low_chance = 0.05
	var rare_chance = 0.01
	
	for item_id in items.keys():
		var item = items[item_id]
		if item.type == "Consumable":
			continue
		if item.tier == "0":
			basic_loot_pools["lowlands_1"].loot.append({
				"item" : item_id,
				"chance" : low_chance,
			})
			basic_loot_pools["lowlands_2"].loot.append({
				"item" : item_id,
				"chance" : high_chance,
			})
		if item.tier == "1":
			basic_loot_pools["midlands_1"].loot.append({
				"item" : item_id,
				"chance" : low_chance,
			})
			basic_loot_pools["midlands_2"].loot.append({
				"item" : item_id,
				"chance" : high_chance,
			})
			basic_loot_pools["highlands_1"].loot.append({
				"item" : item_id,
				"chance" : low_chance,
			})
			basic_loot_pools["highlands_2"].loot.append({
				"item" : item_id,
				"chance" : high_chance,
			})
		if item.tier == "2":
			basic_loot_pools["highlands_1"].soulbound_loot.append({
				"item" : item_id,
				"chance" : rare_chance,
				"threshold" : 0.2,
			})
			basic_loot_pools["highlands_2"].soulbound_loot.append({
				"item" : item_id,
				"chance" : decent_chance,
				"threshold" : 0.2,
			})
			basic_loot_pools["godlands_1"].soulbound_loot.append({
				"item" : item_id,
				"chance" : decent_chance,
				"threshold" : 0.2,
			})
		if item.tier == "3":
			basic_loot_pools["godlands_1"].soulbound_loot.append({
				"item" : item_id,
				"chance" : rare_chance,
				"threshold" : 0.5,
			})
			basic_loot_pools["ruler_1"].soulbound_loot.append({
				"item" : item_id,
				"chance" : low_chance,
				"threshold" : 0.05,
			})
			basic_loot_pools["encounter_1"].soulbound_loot.append({
				"item" : item_id,
				"chance" : low_chance,
				"threshold" : 0.05,
			})
			basic_loot_pools["encounter_2"].soulbound_loot.append({
				"item" : item_id,
				"chance" : decent_chance,
				"threshold" : 0.05,
			})
		if item.tier == "4":
			basic_loot_pools["encounter_1"].soulbound_loot.append({
				"item" : item_id,
				"chance" : rare_chance,
				"threshold" : 0.05,
			})
			basic_loot_pools["encounter_2"].soulbound_loot.append({
				"item" : item_id,
				"chance" : low_chance,
				"threshold" : 0.05,
			})
	
	for enemy_name in special_loot_pools.keys():
		var pool = special_loot_pools[enemy_name]
		pool.soulbound_loot += basic_loot_pools[pool.override].soulbound_loot
		pool.loot += basic_loot_pools[pool.override].loot

var databank_configured = false
func ConfigureProjectileDatabank():
	databank_configured = true
	for projectile_type in projectile_databank.keys():
		var projectile = projectile_databank[projectile_type]
		
		if projectile.has("inherit"):
			projectile.merge(projectile_databank[projectile.inherit])

func MakeProjectile(projectile_type, degrees, wait, targeter = null):
	if not databank_configured:
		ConfigureProjectileDatabank()
	
	var angle = DegreesToVector(degrees)
	var projectile_data = projectile_databank[projectile_type].duplicate()
	
	projectile_data.direction = angle
	projectile_data.wait = wait
	if targeter:
		projectile_data.targeter = targeter
	elif projectile_data.has("targeter"):
		projectile_data.erase("targeter")
	
	return projectile_data

func CreateSpiral(arm_count, projectile_type, delay, mix_in = null, chance = 0.2, steps = 32.0):
	randomize()
	var attack_pattern = []
	
	for step in steps:
		if mix_in and randf() < chance:
			var projectile = MakeProjectile(mix_in, randi() % 360, 0)
			attack_pattern.append(projectile)
		for arm in range(arm_count):
			var wait = delay if (arm+1 == arm_count) else 0
			var projectile = MakeProjectile(projectile_type, (360.0/steps)*(step+arm*(steps/arm_count)), wait)
			attack_pattern.append(projectile)
	
	return attack_pattern

var rulers = {
	"oranix" : {
		"scale" : 1.2,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(0,54), Vector2(90,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
			"Death" : [4],
		},
		
		"health" : 25000,
		"defense" : 10,
		"exp" : 2000,
		"behavior" : 0,
		"speed" : 10,
		"dungeon" : {
			"rate" : 0,
			"name" : "orc_vigil"
		},
		"loot_pool" : special_loot_pools["oranix"],
		"phases" : [
			{
				"duration" : 12,
				"behavior" : 1,
				"speed" : 5,
				"on_spawn" : true,
				"health" : [99.9999999,100],
				"attack_pattern" : [
					MakeProjectile("Wave_mid_slow", (45.0/2)+(360.0/8.0)*1, 0),
					MakeProjectile("Wave_mid_slow", (45.0/2)+(360.0/8.0)*2, 0),
					MakeProjectile("Wave_mid_slow", (45.0/2)+(360.0/8.0)*3, 0),
					MakeProjectile("Wave_mid_slow", (45.0/2)+(360.0/8.0)*4, 0),
					MakeProjectile("Wave_mid_slow", (45.0/2)+(360.0/8.0)*5, 0),
					MakeProjectile("Wave_mid_slow", (45.0/2)+(360.0/8.0)*6, 0),
					MakeProjectile("Wave_mid_slow", (45.0/2)+(360.0/8.0)*7, 0),
					MakeProjectile("Wave_mid_slow", (45.0/2)+(360.0/8.0)*8, 2),
				]
			},
			{
				"duration" : 7,
				"behavior" : 1,
				"speed" : 5,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 6,
						"wait" : 0,
					},
					{
						"speech" : "I stand guard over the last remanants of the greaet orc kingdom...",
						"wait" : 3,
					},
					{
						"speech" : "As a vessel of Salazar I will not fall!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : 4,
				"health" : [25,100],
				"behavior" : 1,
				"attack_pattern" : [
					MakeProjectile("GoldDart_strong_fast", (360.0/8.0)*1, 0, "nearest"),
					MakeProjectile("GoldDart_strong_fast", (360.0/8.0)*2, 0, "nearest"),
					MakeProjectile("GoldDart_strong_fast", (360.0/8.0)*3, 0, "nearest"),
					MakeProjectile("GoldDart_strong_fast", (360.0/8.0)*4, 0, "nearest"),
					MakeProjectile("GoldDart_strong_fast", (360.0/8.0)*5, 0, "nearest"),
					MakeProjectile("GoldDart_strong_fast", (360.0/8.0)*6, 0, "nearest"),
					MakeProjectile("GoldDart_strong_fast", (360.0/8.0)*8, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", 30, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", 20, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", 10, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", 0, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", -10, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", -20, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", -30, 2, "nearest"),
				]
			},
			{
				"duration" : 6,
				"health" : [25,100],
				"behavior" : 1,
				"attack_pattern" : [
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(30),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-30),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(120),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(240),
						"size" : 7
					},
					MakeProjectile("Wave_mid_slow", 300, 2, "nearest"),
					MakeProjectile("Wave_mid_slow", 180, 2, "nearest"),
					MakeProjectile("Wave_mid_slow", 60, 2, "nearest"),
				]
			},
			{
				"duration" : 6,
				"health" : [25,100],
				"behavior" : 2,
				"attack_pattern" : [
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 150,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : 7
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : 7
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 150,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : 7
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : 7
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(5),
						"size" : 7
					},
				]
			},
			{
				"duration" : 12,
				"health" : [0,25],
				"on_spawn" : true,
				"behavior" : 2,
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 70,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : 7
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 200,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 50,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 7
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 200,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 50,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 200,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 50,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 7
					},
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 60,
						"tile_range" : 14,
						"targeter" : "nearest",
						"direction" : DegreesToVector(120),
						"size" : 7
					},
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 60,
						"tile_range" : 14,
						"targeter" : "nearest",
						"direction" : DegreesToVector(180),
						"size" : 7
					},
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 60,
						"tile_range" : 14,
						"targeter" : "nearest",
						"direction" : DegreesToVector(240),
						"size" : 7
					},
				]
			}
		]
	},
	"vajira" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(0,72), Vector2(90,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
			"Death" : [4],
		},
		
		"health" : 30000,
		"defense" : 10,
		"exp" : 2000,
		"behavior" : 0,
		"speed" : 10,
		"dungeon" : {
			"rate" : 0,
			"name" : "frozen_fortress"
		},
		"loot_pool" : special_loot_pools["vajira"],
		"phases" : [
			{
				"duration" : 12,
				"behavior" : 1,
				"speed" : 5,
				"on_spawn" : true,
				"health" : [99.9999999,100],
				"attack_pattern" : [
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*1, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*2, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*3, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*4, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*5, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*6, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*7, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*8, 2),
				]
			},
			{
				"duration" : 7,
				"behavior" : 1,
				"speed" : 5,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 6,
						"wait" : 0,
					},
					{
						"speech" : "I have been entrusted to rule over this island as a vessel...",
						"wait" : 3,
					},
					{
						"speech" : "Challenge me if you dare!",
						"wait" : 3,
					},
					MakeProjectile("GiantBall_strong_slow", (360.0/8.0)*1, 0),
					MakeProjectile("GiantBall_strong_slow", (360.0/8.0)*2, 0),
					MakeProjectile("GiantBall_strong_slow", (360.0/8.0)*3, 0),
					MakeProjectile("GiantBall_strong_slow", (360.0/8.0)*4, 0),
					MakeProjectile("GiantBall_strong_slow", (360.0/8.0)*5, 0),
					MakeProjectile("GiantBall_strong_slow", (360.0/8.0)*6, 0),
					MakeProjectile("GiantBall_strong_slow", (360.0/8.0)*7, 0),
					MakeProjectile("GiantBall_strong_slow", (360.0/8.0)*8, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*1, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*2, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*3, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*4, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*5, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*6, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*7, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*8, 2),
				]
			},
			{
				"duration" : 6,
				"behavior" : 2,
				"speed" : 20,
				"health" : [25,100],
				"attack_pattern" : [
					MakeProjectile("GiantIceSlash_strong_medium", 0, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_medium", 20, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_medium", -20, 0.5, "nearest"),
					
					MakeProjectile("IceSlash_strong_fast", 0, 0, "nearest"),
					MakeProjectile("IceSlash_strong_fast", 20, 0, "nearest"),
					MakeProjectile("IceSlash_strong_fast", -20, 0.5, "nearest"),
					
					MakeProjectile("Ball_strong_slow", 36+((360.0/5)*1), 0),
					MakeProjectile("Ball_strong_slow", 36+((360.0/5)*2), 0),
					MakeProjectile("Ball_strong_slow", 36+((360.0/5)*3), 0),
					MakeProjectile("Ball_strong_slow", 36+((360.0/5)*4), 0),
					MakeProjectile("Ball_strong_slow", 36+((360.0/5)*5), 0.2),
					MakeProjectile("Ball_mid_fast", 0+((360.0/5)*1), 0),
					MakeProjectile("Ball_mid_fast", 0+((360.0/5)*2), 0),
					MakeProjectile("Ball_mid_fast", 0+((360.0/5)*3), 0),
					MakeProjectile("Ball_mid_fast", 0+((360.0/5)*4), 0),
					MakeProjectile("Ball_mid_fast", 0+((360.0/5)*5), 0.2),
				]
			},
			{
				"duration" : 6,
				"behavior" : 0,
				"speed" : 10,
				"health" : [25,100],
				"attack_pattern" : CreateSpiral(3, "Ball_strong_slow", 0.4, "IceSlash_strong_medium", 0.3)
			},
			{
				"duration" : 6,
				"behavior" : 1,
				"speed" : 10,
				"health" : [25,100],
				"attack_pattern" : [
					MakeProjectile("GiantIceSlash_mid_slow", 60+((360.0/3.0)*1), 0),
					MakeProjectile("GiantIceSlash_mid_slow", 60+((360.0/3.0)*2), 0),
					MakeProjectile("GiantIceSlash_mid_slow", 60+((360.0/3.0)*3), 0.5),
					
					MakeProjectile("IceSlash_strong_medium", 0, 0.2, "nearest"),
					MakeProjectile("IceSlash_strong_medium", 10, 0, "nearest"),
					MakeProjectile("IceSlash_strong_medium", -10, 0.2, "nearest"),
					MakeProjectile("IceSlash_strong_medium", -20, 0, "nearest"),
					MakeProjectile("IceSlash_strong_medium", 20, 0.2, "nearest"),
					
					MakeProjectile("Ball_mid_fast", (360.0/8.0)*1, 0),
					MakeProjectile("Ball_mid_fast", (360.0/8.0)*2, 0),
					MakeProjectile("Ball_mid_fast", (360.0/8.0)*3, 0),
					MakeProjectile("Ball_mid_fast", (360.0/8.0)*4, 0),
					MakeProjectile("Ball_mid_fast", (360.0/8.0)*5, 0),
					MakeProjectile("Ball_mid_fast", (360.0/8.0)*6, 0),
					MakeProjectile("Ball_mid_fast", (360.0/8.0)*7, 0),
					MakeProjectile("Ball_mid_fast", (360.0/8.0)*8, 0.5),
					
					MakeProjectile("GiantIceSlash_mid_slow", 0+((360.0/3.0)*1), 0),
					MakeProjectile("GiantIceSlash_mid_slow", 0+((360.0/3.0)*2), 0),
					MakeProjectile("GiantIceSlash_mid_slow", 0+((360.0/3.0)*3), 0.5),
				]
			},
			{
				"duration" : 6,
				"behavior" : 2,
				"speed" : 5,
				"health" : [0,25],
				"attack_pattern" : [
					MakeProjectile("GiantBall_mid_fast", 60+((360.0/3.0)*1), 0),
					MakeProjectile("GiantBall_mid_fast", 60+((360.0/3.0)*2), 0),
					MakeProjectile("GiantBall_mid_fast", 60+((360.0/3.0)*3), 0.5),
					
					MakeProjectile("IceSlash_strong_fast", 0, 0.2, "nearest"),
					MakeProjectile("IceSlash_strong_fast", 10, 0, "nearest"),
					MakeProjectile("IceSlash_strong_fast", -10, 0.2, "nearest"),
					MakeProjectile("IceSlash_strong_fast", -20, 0, "nearest"),
					MakeProjectile("IceSlash_strong_fast", 20, 0.2, "nearest"),
					
					MakeProjectile("GiantIceSlash_strong_fast", 0, 0.2, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", 10, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", -10, 0.2, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", -20, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", 20, 0.2, "nearest"),
					
					MakeProjectile("Ball_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("Ball_mid_fast", 10, 0, "nearest"),
					MakeProjectile("Ball_mid_fast", -10, 0.2, "nearest"),
					MakeProjectile("Ball_mid_fast", -20, 0, "nearest"),
					MakeProjectile("Ball_mid_fast", 20, 0.2, "nearest"),
					
					MakeProjectile("GiantBall_strong_slow", 0+((360.0/3.0)*1), 0),
					MakeProjectile("GiantBall_strong_slow", 0+((360.0/3.0)*2), 0),
					MakeProjectile("GiantBall_strong_slow", 0+((360.0/3.0)*3), 0.5),
				]
			},
		]
	},
	"raa'sloth" : {
		"scale" : 1.3,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(0,90), Vector2(90,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
			"Death" : [4],
		},
		
		"health" : 25000,
		"defense" : 20,
		"exp" : 2000,
		"behavior" : 1,
		"speed" : 4,
		"dungeon" : {
			"rate" : 0,
			"name" : "ruined_pyramids"
		},
		"loot_pool" : special_loot_pools["raa'sloth"],
		"phases" : [
			{
				"duration" : 12,
				"behavior" : 1,
				"speed" : 5,
				"on_spawn" : true,
				"health" : [99.9999999,100],
				"attack_pattern" : [
					MakeProjectile("AbyssSpinner_mid_fast", (45.0/2)+(360.0/8.0)*1, 0),
					MakeProjectile("RoyalSlash_mid_fast", (45.0/2)+(360.0/8.0)*2, 0),
					MakeProjectile("AbyssSpinner_mid_fast", (45.0/2)+(360.0/8.0)*3, 0),
					MakeProjectile("RoyalSlash_mid_fast", (45.0/2)+(360.0/8.0)*4, 0),
					MakeProjectile("AbyssSpinner_mid_fast", (45.0/2)+(360.0/8.0)*5, 0),
					MakeProjectile("RoyalSlash_mid_fast", (45.0/2)+(360.0/8.0)*6, 0),
					MakeProjectile("AbyssSpinner_mid_fast", (45.0/2)+(360.0/8.0)*7, 0),
					MakeProjectile("RoyalSlash_mid_fast", (45.0/2)+(360.0/8.0)*8, 2),
				]
			},
			{
				"duration" : 5,
				"behavior" : 1,
				"speed" : 5,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 0,
					},
					{
						"speech" : "The abyss holds powers greater then you know...",
						"wait" : 3,
					},
					{
						"speech" : "Salazar will not fall to the likes of you!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : 7,
				"behavior" : 1,
				"speed" : 5,
				"health" : [25,100],
				"attack_pattern" : [
					MakeProjectile("RoyalSlash_strong_fast_short", (360.0/8.0)*1, 0, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", (360.0/8.0)*2, 0, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", (360.0/8.0)*3, 0, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", (360.0/8.0)*4, 0, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", (360.0/8.0)*5, 0, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", (360.0/8.0)*6, 0, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", (360.0/8.0)*7, 0, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", (360.0/8.0)*8, 0, "nearest"),
					
					MakeProjectile("GiantAbyssSpinner_mid_fast", 0, 0.2, "nearest"),
					
					MakeProjectile("GiantAbyssSpinner_mid_fast", 45, 0, "nearest"),
					MakeProjectile("GiantAbyssSpinner_mid_fast", -45, 0.2, "nearest"),
					
					MakeProjectile("RoyalSlash_mid_fast", 0, 0, "nearest"),
					MakeProjectile("RoyalSlash_mid_fast", -10, 0, "nearest"),
					MakeProjectile("RoyalSlash_mid_fast", 10, 0, "nearest"),
					MakeProjectile("RoyalSlash_mid_fast", -20, 0, "nearest"),
					MakeProjectile("RoyalSlash_mid_fast", 20, 0.5, "nearest"),
				]
			},
			{
				"duration" : 6,
				"behavior" : 0,
				"speed" : 5,
				"health" : [25,100],
				"attack_pattern" : CreateSpiral(2, "AbyssSpinner_mid_fast", 0.2, "GiantRoyalSlash_strong_medium", 1)
			},
			{
				"duration" : 6,
				"behavior" : 2,
				"speed" : 10,
				"health" : [25,100],
				"attack_pattern" : [
					MakeProjectile("AbyssSpinner_mid_fast", 36+((360.0/5.0)*1), 0),
					MakeProjectile("AbyssSpinner_mid_fast", 36+((360.0/5.0)*2), 0),
					MakeProjectile("AbyssSpinner_mid_fast", 36+((360.0/5.0)*3), 0),
					MakeProjectile("AbyssSpinner_mid_fast", 36+((360.0/5.0)*4), 0),
					MakeProjectile("AbyssSpinner_mid_fast", 36+((360.0/5.0)*5), 0),
					
					MakeProjectile("GiantRoyalSlash_strong_medium", 0, 0.2, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", 0, 0.2, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", 0, 0.2, "nearest"),
					MakeProjectile("GiantRoyalSlash_strong_medium", 0, 0.2, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", 0, 0.2, "nearest"),
					
					MakeProjectile("AbyssSpinner_mid_fast", ((360.0/5.0)*1), 0),
					MakeProjectile("AbyssSpinner_mid_fast", ((360.0/5.0)*2), 0),
					MakeProjectile("AbyssSpinner_mid_fast", ((360.0/5.0)*3), 0),
					MakeProjectile("AbyssSpinner_mid_fast", ((360.0/5.0)*4), 0),
					MakeProjectile("AbyssSpinner_mid_fast", ((360.0/5.0)*5), 0),
					
					MakeProjectile("RoyalSlash_strong_fast_short", 0, 0.2, "nearest"),
					MakeProjectile("GiantRoyalSlash_strong_medium", 0, 0.2, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", 0, 0.2, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", 0, 0.2, "nearest"),
					MakeProjectile("GiantRoyalSlash_strong_medium", 0, 0.2, "nearest"),
				]
			},
			{
				"duration" : 60,
				"behavior" : 1,
				"speed" : 5,
				"health" : [0,25],
				"attack_pattern" : CreateSpiral(1, "RoyalSlash_mid_fast", 0.1, "GiantAbyssSpinner_strong_medium", 0.3) + [
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*1), 0),
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*2), 0),
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*3), 0),
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*4), 0),
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*5), 0),
					
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*1), 0),
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*2), 0),
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*3), 0),
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*4), 0),
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*5), 1),
					
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*1), 0),
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*2), 0),
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*3), 0),
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*4), 0),
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*5), 0),
					
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*1), 0),
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*2), 0),
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*3), 0),
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*4), 0),
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*5), 1),
				]
			},
		]
	},
	"salazar" : {
		"scale" : 1.3,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(0,90), Vector2(90,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
			"Death" : [4],
		},
		
		"health" : 40000,
		"defense" : 50,
		"exp" : 10000,
		"behavior" : 0,
		"speed" : 10,
		"dungeon" : {
			"rate" : 1,
			"name" : "the_abyss"
		},
		"loot_pool" : special_loot_pools["salazar"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "salazar_left_wing",
						"summon_position" : Vector2(-19,-1),
						"wait" : 0,
					},
					{
						"summon" : "salazar_right_wing",
						"summon_position" : Vector2(20,-1),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : OS.get_system_time_secs(),
				"health" : [99.99,100],
				"attack_pattern" : [
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 0,
						"piercing" : true,
						"wait" : OS.get_system_time_secs(),
						"speed" : 20,
						"tile_range" : 0,
						"targeter" : "nearest",
						"direction" : Vector2(0,1),
						"size" : 9
					},
				]
			},
			{
				"duration" : 5,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,99.99],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 6,
						"wait" : 0,
					},
					{
						"speech" : "So all my vessels have fallen...",
						"wait" : 3,
					},
					{
						"speech" : "You are not to be underestimated. The abyss awaits you!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : 5,
				"health" : [75,99.99],
				"attack_pattern" : [
					MakeProjectile("Dart_strong_fast", -40, 0, "nearest"),
					MakeProjectile("Dart_strong_fast", -30, 0, "nearest"),
					MakeProjectile("Dart_strong_fast", -20, 0, "nearest"),
					MakeProjectile("Dart_strong_fast", -10, 0, "nearest"),
					MakeProjectile("Dart_strong_fast", 0, 0, "nearest"),
					MakeProjectile("Dart_strong_fast", 40, 0, "nearest"),
					MakeProjectile("Dart_strong_fast", 30, 0, "nearest"),
					MakeProjectile("Dart_strong_fast", 20, 0, "nearest"),
					MakeProjectile("Dart_strong_fast", 10, 2, "nearest"),
				]
			},
			{
				"duration" : 5,
				"health" : [75,99.99],
				"attack_pattern" : CreateSpiral(4, "Star_strong_slow", 0.2)
			},
			{
				"duration" : 7,
				"health" : [25,75],
				"attack_pattern" : [
					MakeProjectile("Spinner_strong_medium", (360.0/8.0)*1, 0.1),
					MakeProjectile("Spinner_strong_medium", (360.0/8.0)*2, 0.1),
					MakeProjectile("Spinner_strong_medium", (360.0/8.0)*3, 0.1),
					MakeProjectile("Spinner_strong_medium", (360.0/8.0)*4, 0.1),
					MakeProjectile("Spinner_strong_medium", (360.0/8.0)*5, 0.1),
					MakeProjectile("Spinner_strong_medium", (360.0/8.0)*6, 0.1),
					MakeProjectile("Spinner_strong_medium", (360.0/8.0)*7, 0.1),
					MakeProjectile("Spinner_strong_medium", (360.0/8.0)*8, 1),
					MakeProjectile("GiantSpinner_strong_medium", 0, 0.1, "nearest"),
					MakeProjectile("Spinner_strong_medium", 0, 0.1, "nearest"),
					MakeProjectile("Spinner_strong_medium", 0, 0.1, "nearest"),
					MakeProjectile("Spinner_strong_medium", 0, 0.1, "nearest"),
					MakeProjectile("Spinner_strong_medium", 0, 0.8, "nearest"),
					
					MakeProjectile("GiantSpinner_strong_medium", (360.0/5.0)*1, 0),
					MakeProjectile("GiantSpinner_strong_medium", (360.0/5.0)*2, 0),
					MakeProjectile("GiantSpinner_strong_medium", (360.0/5.0)*3, 0),
					MakeProjectile("GiantSpinner_strong_medium", (360.0/5.0)*4, 0),
					MakeProjectile("GiantSpinner_strong_medium", (360.0/5.0)*5, 0.8),
				]
			},
			{
				"duration" : 5,
				"health" : [25,75],
				"attack_pattern" : [
					MakeProjectile("Fire1_strong_fast", 0, 0.1, "nearest"),
					MakeProjectile("Fire2_strong_fast", -25, 0.1, "nearest"),
					MakeProjectile("Fire3_strong_fast", 15, 0.1, "nearest"),
					MakeProjectile("Fire2_strong_fast", -5, 0.1, "nearest"),
					MakeProjectile("Fire1_strong_fast", 25, 0.1, "nearest"),
					MakeProjectile("Fire1_strong_fast", 1, 0.1, "nearest"),
					MakeProjectile("Fire2_strong_fast", 10, 0.1, "nearest"),
					MakeProjectile("Fire3_strong_fast", -15, 0.1, "nearest"),
					
					MakeProjectile("GoldDart_strong_fast", (360.0/5.0)*1, 0),
					MakeProjectile("GoldDart_strong_fast", (360.0/5.0)*2, 0),
					MakeProjectile("GoldDart_strong_fast", (360.0/5.0)*3, 0),
					MakeProjectile("GoldDart_strong_fast", (360.0/5.0)*4, 0),
					MakeProjectile("GoldDart_strong_fast", (360.0/5.0)*5, 1),
				]
			},
			{
				"duration" : 5,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,25],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 6,
						"wait" : 0,
					},
					{
						"speech" : "PUNY MORTALS...!",
						"wait" : 3,
					},
					{
						"speech" : "FEAR THE ABYSS!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : 25,
				"health" : [0,25],
				"attack_pattern" : CreateSpiral(3, "Star_strong_medium", 0.2) + [
					MakeProjectile("Dart_mid_fast", (360.0/8)*1, 0, "nearest"),
					MakeProjectile("Dart_mid_fast", (360.0/8)*2, 0, "nearest"),
					MakeProjectile("Dart_mid_fast", (360.0/8)*3, 0, "nearest"),
					MakeProjectile("Dart_mid_fast", (360.0/8)*4, 0, "nearest"),
					MakeProjectile("Dart_mid_fast", (360.0/8)*5, 0, "nearest"),
					MakeProjectile("Dart_mid_fast", (360.0/8)*6, 0, "nearest"),
					MakeProjectile("Dart_mid_fast", (360.0/8)*7, 0, "nearest"),
					MakeProjectile("Dart_mid_fast", (360.0/8)*8, 1, "nearest"),
					MakeProjectile("GoldDart_strong_fast", -5, 0.1, "nearest"),
					MakeProjectile("GoldDart_strong_fast", 0, 0.1, "nearest"),
					MakeProjectile("GoldDart_strong_fast", 5, 0.1, "nearest"),
					MakeProjectile("Dart_strong_fast", -40, 0, "nearest"),
					MakeProjectile("Dart_strong_fast", -30, 0, "nearest"),
					MakeProjectile("Dart_strong_fast", -20, 0, "nearest"),
					MakeProjectile("Dart_strong_fast", -10, 0, "nearest"),
					MakeProjectile("Dart_strong_fast", 0, 0, "nearest"),
					MakeProjectile("Dart_strong_fast", 40, 0, "nearest"),
					MakeProjectile("Dart_strong_fast", 30, 0, "nearest"),
					MakeProjectile("Dart_strong_fast", 20, 0, "nearest"),
					MakeProjectile("Dart_strong_fast", 10, 0.2, "nearest"),
					MakeProjectile("Dart_strong_fast", 0, 0.2, "nearest"),
					MakeProjectile("Dart_strong_fast", 0, 0.2, "nearest"),
					MakeProjectile("Dart_strong_fast", 0, 0.2, "nearest"),
					MakeProjectile("Dart_strong_fast", 0, 0.2, "nearest"),
					MakeProjectile("Dart_strong_fast", 0, 0.2, "nearest"),
				]
			},
		]
	},
	"salazar_left_wing" : {
		"scale" : 1.3,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(0,90), Vector2(90,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
			"Death" : [4],
		},
		
		"health" : 5000,
		"defense" : 5,
		"exp" : 3000,
		"behavior" : 0,
		"speed" : 0,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 4,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("Wave_mid_slow", (360.0/8.0)*1, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", (360.0/8.0)*2, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", (360.0/8.0)*3, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", (360.0/8.0)*4, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", (360.0/8.0)*5, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", (360.0/8.0)*6, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", (360.0/8.0)*7, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", (360.0/8.0)*8, 1, "nearest"),
					MakeProjectile("Stack_strong_medium", 20, 0, "nearest"),
					MakeProjectile("Stack_strong_medium", 10, 0, "nearest"),
					MakeProjectile("Stack_strong_medium", 0, 0, "nearest"),
					MakeProjectile("Stack_strong_medium", 10, 0, "nearest"),
					MakeProjectile("Stack_strong_medium", 20, 1, "nearest"),
				]
			},
		]
	},
	"salazar_right_wing" : {
		"scale" : 1.3,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(0,90), Vector2(90,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
			"Death" : [4],
		},
		
		"health" : 5000,
		"defense" : 5,
		"exp" : 3000,
		"behavior" : 0,
		"speed" : 0,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 4,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("Wave_mid_slow", (360.0/8.0)*1, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", (360.0/8.0)*2, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", (360.0/8.0)*3, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", (360.0/8.0)*4, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", (360.0/8.0)*5, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", (360.0/8.0)*6, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", (360.0/8.0)*7, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", (360.0/8.0)*8, 1, "nearest"),
					MakeProjectile("Stack_strong_medium", 20, 0, "nearest"),
					MakeProjectile("Stack_strong_medium", 10, 0, "nearest"),
					MakeProjectile("Stack_strong_medium", 0, 0, "nearest"),
					MakeProjectile("Stack_strong_medium", 10, 0, "nearest"),
					MakeProjectile("Stack_strong_medium", 20, 1, "nearest"),
				]
			},
		]
	},
}
var tutorial_enemies = {
	"tutorial_crab" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 7,
		"rect" : Rect2(Vector2(0,0), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [0,1],
		},
		
		"health" : 20,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" : {
			"soulbound_loot" : [],
			"loot" : [
				{
					"item" : 400,
					"chance" : 1,
				},
			]
		},
		"phases" : [
			{
				"duration" : 4,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("None", 0, 1000, "nearest"),
				]
			},
		]
	},
	"tutorial_troll_warrior" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(0,20), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 70,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 2,
		"speed" : 5,
		"loot_pool" :  basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 5,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("Slash_1", 0, 0.5),
					MakeProjectile("Slash_1", 90, 0.5),
					MakeProjectile("Slash_1", 180, 0.5),
					MakeProjectile("Slash_1", 270, 0.5),
				]
			}
		]
	},
	"tutorial_troll_king" : {
		"scale" : 1.1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(0,0), Vector2(72,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 300,
		"defense" : 2,
		"exp" : 30,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" :  {
			"soulbound_loot" : [
				{
					"item" : 0,
					"chance" : 1,
					"threshold" : 0.2,
				},
			],
			"loot" : []
		},
		"phases" : [
			{
				"duration" : 4,
				"health" : [75,100],
				"attack_pattern" : [
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 5,
						"piercing" : false,
						"wait" : 1,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					}
				]
			},
			{
				"duration" : 4,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,75],
				"attack_pattern" : [
					{
						"summon" : "troll_warrior",
						"summon_position" : Vector2(0,0),
						"wait" : 6,
					},
				]
			},
			{
				"duration" : 4,
				"health" : [0,75],
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(1,0),
						"size" : 4
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 1,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(-1,0),
						"size" : 4
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(0,1),
						"size" : 4
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 2,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(0,-1),
						"size" : 4
					},
				]
			}
		]
	},
}
var realm_enemies = {
	"crab" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 7,
		"rect" : Rect2(Vector2(0,0), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [0,1],
		},
		
		"health" : 50,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("Slash_1", 0, 1, "nearest"),
				]
			}
		]
	},
	"slime" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 5,
		"rect" : Rect2(Vector2(20,0), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [0,1],
		},
		
		"health" : 50,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("GreenBlast_1", 10, 0, "nearest"),
					MakeProjectile("GreenBlast_1", -10, 3, "nearest"),
				]
			}
		]
	},
	"nature_druid" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(140,10), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 300,
		"defense" : 3,
		"exp" : 43,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" :  basic_loot_pools["lowlands_2"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "nature_sprite_stationary",
						"summon_position" : Vector2(10,5),
						"wait" : 0,
					},
					{
						"summon" : "nature_sprite_stationary",
						"summon_position" : Vector2(0,-5),
						"wait" : 0,
					},
					{
						"summon" : "nature_sprite_stationary",
						"summon_position" : Vector2(-10,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 3,
				"health" : [50,100],
				"attack_pattern" : [
					{
						"projectile" : "Nature2",
						"formula" : "sin(x)",
						"damage" : 7,
						"piercing" : false,
						"wait" : 2,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					MakeProjectile("GreenBlast_1", (360.0/8)*1, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*2, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*3, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*4, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*5, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*6, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*7, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*8, 0, "nearest"),
				]
			},
			{
				"duration" : 1,
				"max_uses" : 1,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"summon" : "nature_sprite",
						"summon_position" : Vector2(10,5),
						"wait" : 0,
					},
					{
						"summon" : "nature_sprite",
						"summon_position" : Vector2(0,-5),
						"wait" : 0,
					},
					{
						"summon" : "nature_sprite",
						"summon_position" : Vector2(-10,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 2,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"projectile" : "Nature2",
						"formula" : "sin(x)",
						"damage" : 7,
						"piercing" : false,
						"wait" : 1,
						"speed" : 30,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 7
					}
				]
			},
		]
	},
	"nature_sprite_stationary" : {
		"scale" : 0.8,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(120,10), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [0,1],
		},
		
		"health" : 40,
		"defense" : 0,
		"exp" : 10,
		"behavior" : 1,
		"speed" : 6,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Nature1",
						"formula" : "0",
						"damage" : 3,
						"piercing" : false,
						"wait" : 3,
						"speed" : 30,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					}
				]
			}
		]
	},
	"nature_sprite" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(120,10), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [0,1],
		},
		
		"variations" : ["nature_sprite_stationary"],
		"health" : 10,
		"defense" : 0,
		"exp" : 10,
		"behavior" : 2,
		"speed" : 35,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Nature1",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 1,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					}
				]
			}
		]
	},
	"goblin_warrior" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(0,10), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 60,
		"defense" : 3,
		"exp" : 10,
		"behavior" : 2,
		"speed" : 15,
		"loot_pool" :  basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "IronSlash",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 5,
						"speed" : 10,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					}
				]
			}
		]
	},
	"goblin_archer" : {
		"scale" : 0.8,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(40,10), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 30,
		"defense" : 0,
		"exp" : 10,
		"behavior" : 2,
		"speed" : 5,
		"loot_pool" :  basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 12,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "SteelArrow",
						"formula" : "0",
						"damage" : 4,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					},
					{
						"projectile" : "SteelArrow",
						"formula" : "0",
						"damage" : 4,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 6
					},
					{
						"projectile" : "SteelArrow",
						"formula" : "0",
						"damage" : 4,
						"piercing" : true,
						"wait" : 6,
						"speed" : 20,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 6
					}
				]
			}
		]
	},
	"goblin_cannon" : {
		"scale" : 1.2,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(80,10), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 20,
		"defense" : 1000,
		"exp" : 45,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" :  basic_loot_pools["lowlands_2"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "goblin_warrior",
						"summon_position" : Vector2(10,0),
						"wait" : 0,
					},
					{
						"summon" : "goblin_archer",
						"summon_position" : Vector2(0,-10),
						"wait" : 0,
					},
					{
						"summon" : "goblin_archer",
						"summon_position" : Vector2(0,10),
						"wait" : 0,
					},
					{
						"summon" : "goblin_warrior",
						"summon_position" : Vector2(-10,0),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 7,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "CannonBall",
						"formula" : "0",
						"damage" : 30,
						"piercing" : true,
						"wait" : 7,
						"speed" : 12,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 5
					}
				]
			},
		]
	},
	"blue_slime" : {
		"scale" : 1.5,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(80,20), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [0,1],
		},
		
		"health" : 700,
		"defense" : 1,
		"exp" : 45,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["midlands_1"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "slime",
						"summon_position" : Vector2(10,0),
						"wait" : 0,
					},
					{
						"summon" : "slime",
						"summon_position" : Vector2(0,-10),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 70,
						"tile_range" : 7,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 4
					},
					{
						"projectile" : "Water1",
						"formula" : "0",
						"damage" : 5,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 70,
						"tile_range" : 7,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 3
					},
					{
						"projectile" : "Water1",
						"formula" : "0",
						"damage" : 5,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 70,
						"tile_range" : 7,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 3
					}
				]
			}
		]
	},
	"cyclops_underling" : {
		"scale" : 1.2,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(100,20), Vector2(30,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2],
		},
		
		"health" : 50,
		"defense" : 0,
		"exp" : 13,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 3,
						"speed" : 20,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 4
					},
				]
			}
		]
	},
	"cyclops_leader" : {
		"scale" : 1.2,
		"res" : 18,
		"height" : 15,
		"rect" : Rect2(Vector2(144,0), Vector2(36,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [],
		},
		
		"health" : 300,
		"defense" : 5,
		"exp" : 89,
		"behavior" : 1,
		"speed" : 6,
		"loot_pool" : basic_loot_pools["midlands_2"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "cyclops_underling",
						"summon_position" : Vector2(10,0),
						"wait" : 0,
					},
					{
						"summon" : "cyclops_underling",
						"summon_position" : Vector2(0,-10),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 15,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 4
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 2,
						"speed" : 40,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 4
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 7,
						"direction" : Vector2(0,1),
						"size" : 7
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 7,
						"direction" : Vector2(0.866,0.5),
						"size" : 7
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 7,
						"direction" : Vector2(0.866,-0.5),
						"size" : 7
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 7,
						"direction" : Vector2(0,-1),
						"size" : 7
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 7,
						"direction" : Vector2(-0.866,-0.5),
						"size" : 7
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 7,
						"direction" : Vector2(-0.866,0.5),
						"size" : 7
					},
				]
			}
		]
	},
	"imp_warrior" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(130,20), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 200,
		"defense" : 5,
		"exp" : 35,
		"behavior" : 2,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["midlands_1"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "imp_archer",
						"summon_position" : Vector2(10,0),
						"wait" : 0,
					},
					{
						"summon" : "imp_mage",
						"summon_position" : Vector2(0,-10),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 70,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					},
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 25,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 50,
						"tile_range" : 4,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					},
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 2,
						"speed" : 35,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					},
				]
			}
		]
	},
	"imp_archer" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(200,20), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 100,
		"defense" : 0,
		"exp" : 35,
		"behavior" : 2,
		"speed" : 8,
		"loot_pool" : basic_loot_pools["midlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Dart",
						"formula" : "0",
						"damage" : 30,
						"piercing" : true,
						"wait" : 0,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 4
					},
					{
						"projectile" : "Dart",
						"formula" : "0",
						"damage" : 30,
						"piercing" : true,
						"wait" : 0,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 4
					},
					{
						"projectile" : "Dart",
						"formula" : "0",
						"damage" : 30,
						"piercing" : true,
						"wait" : 6,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 4
					},
				]
			}
		]
	},
	"imp_mage" : {
		"scale" : 0.8,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(170,20), Vector2(30,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2],
		},
		
		"health" : 100,
		"defense" : 0,
		"exp" : 35,
		"behavior" : 2,
		"speed" : 7,
		"loot_pool" : basic_loot_pools["midlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "BlueBlast",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : 4
					},
					{
						"projectile" : "BlueBlast",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 1,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : 4
					},
				]
			}
		]
	},
	"fire_druid" : {
		"scale" : 0.9,
		"res" : 18,
		"height" : 8,
		"rect" : Rect2(Vector2(180,0), Vector2(54,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2],
		},
		
		"health" : 200,
		"defense" : 0,
		"exp" : 43,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" :  basic_loot_pools["midlands_2"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 12,
						"piercing" : false,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(5),
						"size" : 7
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 12,
						"piercing" : false,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-5),
						"size" : 7
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 12,
						"piercing" : false,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : 7
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 12,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 24,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(5),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 24,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-5),
						"size" : 7
					},
					{
						"projectile" : "Fire3",
						"formula" : "0",
						"damage" : 32,
						"piercing" : false,
						"wait" : 6,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
				]
			}
		]
	},
	"troll_warrior" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(0,20), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 100,
		"defense" : 1,
		"exp" : 6,
		"behavior" : 2,
		"speed" : 20,
		"loot_pool" :  basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 10,
						"tile_range" : 3,
						"direction" : Vector2(0,1),
						"size" : 4
					},
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 10,
						"tile_range" : 3,
						"direction" : Vector2(1,0),
						"size" : 4
					},
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 10,
						"tile_range" : 3,
						"direction" : Vector2(0,-1),
						"size" : 4
					},
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 10,
						"tile_range" : 3,
						"direction" : Vector2(-1,0),
						"size" : 4
					}
				]
			}
		]
	},
	"troll_brute" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(40,20), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 200,
		"defense" : 5,
		"exp" : 12,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" :  basic_loot_pools["midlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 5
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 1,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 5
					}
				]
			}
		]
	},
	"troll_king" : {
		"scale" : 1.1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(0,0), Vector2(72,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 300,
		"defense" : 5,
		"exp" : 64,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" :  basic_loot_pools["midlands_2"],
		"phases" : [
			{
				"duration" : 6,
				"health" : [50,100],
				"attack_pattern" : [
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 50,
						"piercing" : true,
						"wait" : 0,
						"speed" : 5,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 6
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 5
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 5,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 5
					}
				]
			},
			{
				"duration" : 4,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "troll_warrior",
						"summon_position" : Vector2(-10,0),
						"wait" : 0.2,
					},
					{
						"summon" : "troll_warrior",
						"summon_position" : Vector2(10,0),
						"wait" : 0.2,
					},
					{
						"summon" : "troll_brute",
						"summon_position" : Vector2(0,-10),
						"wait" : 0.2,
					},
					{
						"summon" : "troll_brute",
						"summon_position" : Vector2(0,10),
						"wait" : 4,
					},
				]
			},
			{
				"duration" : 4,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(1,0),
						"size" : 20
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 1,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(-1,0),
						"size" : 20
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(0,1),
						"size" : 20
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 2,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(0,-1),
						"size" : 20
					},
				]
			}
		]
	},
	"rat_warrior" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(0,30), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 100,
		"defense" : 6,
		"exp" : 24,
		"behavior" : 2,
		"speed" : 40,
		"loot_pool" :  basic_loot_pools["highlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "IronSlash",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : 7
					},
					{
						"projectile" : "IronSlash",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 2.5,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : 7
					},
				]
			}
		]
	},
	"rat_mage" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(40,30), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 250,
		"defense" : 0,
		"exp" : 24,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["highlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "BrownBlast",
						"formula" : "0",
						"damage" : 25,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : 5
					},
					{
						"projectile" : "BrownBlast",
						"formula" : "0",
						"damage" : 25,
						"piercing" : false,
						"wait" : 2,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : 5
					},
					{
						"projectile" : "BrownBlast",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 2,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 5
					},
				]
			}
		]
	},
	"rat_king" : {
		"scale" : 1.2,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(60,30), Vector2(30,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [0,2],
		},
		
		"health" : 600,
		"defense" : 4,
		"exp" : 200,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["highlands_2"],
		"phases" : [
			{
				"duration" : 1,
				"health" : [0,100],
				"on_spawn" : true,
				"max_uses" : 1,
				"attack_pattern" : [
					{
						"summon" : "rat_warrior",
						"summon_position" : Vector2(-10,0),
						"wait" : 0.1,
					},
					{
						"summon" : "rat_mage",
						"summon_position" : Vector2(0,10),
						"wait" : 0.1,
					},
					{
						"summon" : "rat_mage",
						"summon_position" : Vector2(0,-10),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 5,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "GoldSlash",
						"formula" : "0",
						"damage" : 35,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : 7
					},
					{
						"projectile" : "GoldSlash",
						"formula" : "0",
						"damage" : 35,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "GoldSlash",
						"formula" : "0",
						"damage" : 35,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : 7
					},
				]
			},
			{
				"duration" : 5,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "GoldSlash",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : 7
					},
					{
						"projectile" : "GoldSlash",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 2.5,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : 7
					},
				]
			}
		]
	},
	"viking_king" : {
		"scale" : 1.2,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(72,0), Vector2(72,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 1200,
		"defense" : 12,
		"exp" : 340,
		"behavior" : 2,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["highlands_2"],
		"phases" : [
			{
				"duration" : 2,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "viking_warrior",
						"summon_position" : Vector2(-10,-5),
						"wait" : 0.1,
					},
					{
						"summon" : "viking_warrior",
						"summon_position" : Vector2(10,-5),
						"wait" : 0.1,
					},
					{
						"summon" : "viking_warrior",
						"summon_position" : Vector2(0,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 5,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(0,1),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(0.707,0.707),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(1,0),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(0.707,-0.707),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(0,-1),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(-0.707,-0.707),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(-1,0),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 2,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(-0.707,0.707),
						"size" : 7
					},
					{
						"projectile" : "Spinner",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-17),
						"size" : 7
					},
					{
						"projectile" : "Spinner",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(17),
						"size" : 7
					},
					{
						"projectile" : "Dart",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 5
					},
					{
						"projectile" : "Dart",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(35),
						"size" : 5
					},
					{
						"projectile" : "Dart",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-35),
						"size" : 5
					},
				]
			},
		]
	},
	"viking_warrior" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(90,30), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [0,2],
		},
		
		"health" : 180,
		"defense" : 0,
		"exp" : 140,
		"behavior" : 2,
		"speed" : 20,
		"loot_pool" : basic_loot_pools["highlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 20,
						"tile_range" : 2,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 4
					},
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 20,
						"tile_range" : 2,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 4
					},
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 3,
						"speed" : 20,
						"tile_range" : 2,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 4
					},
				]
			}
		]
	},
	"yellow_slime" : {
		"scale" : 1.6,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(130,30), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 1000,
		"defense" : 0,
		"exp" : 150,
		"behavior" : 1,
		"speed" : 20,
		"loot_pool" : basic_loot_pools["highlands_2"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [50,100],
				"attack_pattern" : [
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 7
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 6
					},
					{
						"projectile" : "Fire3",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 7
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 6
					},
				]
			},
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "blue_slime",
						"summon_position" : Vector2(10,10),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0.25,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 7
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.25,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 6
					},
					{
						"projectile" : "Fire3",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0.25,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0.25,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 7
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.25,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 6
					},
				]
			},
		]
	},
	"shadow_druid" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(150,30), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 300,
		"defense" : 22,
		"exp" : 200,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" :  basic_loot_pools["highlands_2"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "skeletal_warrior",
						"summon_position" : Vector2(10,5),
						"wait" : 0,
					},
					{
						"summon" : "skeletal_archer",
						"summon_position" : Vector2(0,-5),
						"wait" : 0,
					},
					{
						"summon" : "skeletal_archer",
						"summon_position" : Vector2(-10,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"summon" : "skeletal_warrior",
						"summon_position" : Vector2(10,5),
						"wait" : 0,
					},
					{
						"summon" : "skeletal_archer",
						"summon_position" : Vector2(0,-5),
						"wait" : 0,
					},
					{
						"summon" : "skeletal_archer",
						"summon_position" : Vector2(-10,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 4,
				"health" : [50,100],
				"attack_pattern" : [
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 70,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(35),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 3,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-35),
						"size" : 7
					},
				]
			},
			{
				"duration" : 3,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(35),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 1,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-35),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-35),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(35),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 1,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
				]
			},
		]
	},
	"skeletal_warrior" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(170,30), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 180,
		"defense" : 22,
		"exp" : 35,
		"behavior" : 2,
		"speed" : 20,
		"loot_pool" : basic_loot_pools["highlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "RexiumSlash",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 30,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.8,
						"speed" : 35,
						"tile_range" : 4,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					},
				]
			}
		]
	},
	"skeletal_archer" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(210,30), Vector2(30,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1,2],
		},
		
		"health" : 90,
		"defense" : 10,
		"exp" : 35,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["highlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "RexiumArrow",
						"formula" : "0",
						"damage" : 20,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 45,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					},
					{
						"projectile" : "RexiumArrow",
						"formula" : "0",
						"damage" : 20,
						"piercing" : true,
						"wait" : 4,
						"speed" : 35,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					},
				]
			}
		]
	},
	"cacodemon" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(0,18), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 1200,
		"defense" : 12,
		"exp" : 200,
		"behavior" : 2,
		"speed" : 20,
		"loot_pool" : basic_loot_pools["godlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 9,
						"targeter" : "nearest",
						"direction" : Vector2(0,1),
						"size" : 7
					},
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 9,
						"targeter" : "nearest",
						"direction" : Vector2(0.866,0.5),
						"size" : 7
					},
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 9,
						"targeter" : "nearest",
						"direction" : Vector2(0.866,-0.5),
						"size" : 7
					},
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 9,
						"targeter" : "nearest",
						"direction" : Vector2(0,-1),
						"size" : 7
					},
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 9,
						"targeter" : "nearest",
						"direction" : Vector2(-0.866,-0.5),
						"size" : 7
					},
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 9,
						"targeter" : "nearest",
						"direction" : Vector2(-0.866,0.5),
						"size" : 7
					},
					{
						"projectile" : "RexiumSlash",
						"formula" : "0",
						"damage" : 70,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 40,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "RexiumSlash",
						"formula" : "0",
						"damage" : 70,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 50,
						"tile_range" : 4,
						"targeter" : "nearest",
						"direction" : DegreesToVector(7),
						"size" : 7
					},
					{
						"projectile" : "RexiumSlash",
						"formula" : "0",
						"damage" : 70,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 60,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : 7
					},
					{
						"projectile" : "RexiumSlash",
						"formula" : "0",
						"damage" : 70,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 50,
						"tile_range" : 4,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-7),
						"size" : 7
					},
					{
						"projectile" : "RexiumSlash",
						"formula" : "0",
						"damage" : 70,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 60,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : 7
					},
				]
			},
		]
	},
	"basalisk" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(216,18), Vector2(54,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2],
		},
		
		"health" : 1000,
		"defense" : 18,
		"exp" : 250,
		"behavior" : 2,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["godlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "MithrilSlash",
						"formula" : "0",
						"damage" : 65,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 65,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : 7
					},
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 65,
						"piercing" : true,
						"wait" : 1.4,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : 7
					},
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "MithrilSlash",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : 7
					},
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : 7
					},
					{
						"projectile" : "MithrilSlash",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : 7
					},
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 1.4,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : 7
					},
				]
			},
		]
	},
	"phoenix" : {
		"scale" : 1,
		"res" : 18,
		"height" : 15,
		"rect" : Rect2(Vector2(126,18), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 800,
		"defense" : 15,
		"exp" : 180,
		"behavior" : 2,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["godlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(40),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(60),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(40),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-40),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-60),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-40),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : 7
					},
				]
			},
		]
	},
	"ice_druid" : {
		"scale" : 1,
		"res" : 18,
		"height" : 8,
		"rect" : Rect2(Vector2(90,18), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 90,
		"defense" : 10,
		"exp" : 55,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "RedBlast",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 45,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 45,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 6
					},
					{
						"projectile" : "BlueBlast",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 4,
						"speed" : 45,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 6
					},
				]
			}
		]
	},
	"archmage" : {
		"scale" : 1,
		"res" : 18,
		"height" : 8,
		"rect" : Rect2(Vector2(36,18), Vector2(54,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2],
		},
		
		"health" : 700,
		"defense" : 15,
		"exp" : 225,
		"behavior" : 1,
		"speed" : 7,
		"loot_pool" : basic_loot_pools["godlands_1"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "ice_druid",
						"summon_position" : Vector2(10,5),
						"wait" : 0,
					},
					{
						"summon" : "ice_druid",
						"summon_position" : Vector2(0,-5),
						"wait" : 0,
					},
					{
						"summon" : "ice_druid",
						"summon_position" : Vector2(-10,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "BlueBlast",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(60),
						"size" : 5
					},
					{
						"projectile" : "RedBlast",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(180),
						"size" : 5
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 1.5,
						"speed" : 70,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(300),
						"size" : 5
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 120,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 120,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(120),
						"size" : 7
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 120,
						"piercing" : false,
						"wait" : 1.5,
						"speed" : 70,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(240),
						"size" : 7
					},
				]
			},
		]
	},
}
var orc_vigil_enemies = {
	"vigil_guardian" : {
		"scale" : 1.5,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(126,54), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 20000,
		"defense" : 20,
		"exp" : 6000,
		"behavior" : 0,
		"speed" : 15,
		"dungeon" : {
			"rate" : 1,
			"name" : "orc_vigil_sanctum"
		},
		"loot_pool" : special_loot_pools["vigil_guardian"],
		"phases" : [
			{
				"duration" : 16,
				"health" : [0,100],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 16,
						"wait" : 12,
					},
					{
						"speech" : "So Oranix has fallen? The creator will be angry...",
						"wait" : 2,
					},
					{
						"speech" : "No matter. Those who enter the vigil shall not return. Die usurper!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : 12,
				"health" : [90,100],
				"behavior" : 1,
				"speed" : 15,
				"attack_pattern" : [
					MakeProjectile("GiantBlast_fast", 15, 0, "nearest"),
					MakeProjectile("GiantBlast_fast", -15, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", (360.0/8.0)*1, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", (360.0/8.0)*2, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", (360.0/8.0)*3, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", (360.0/8.0)*4, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", (360.0/8.0)*5, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", (360.0/8.0)*6, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", (360.0/8.0)*7, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", (360.0/8.0)*8, 2, "nearest"),
				]
			},
			{
				"duration" : 4,
				"health" : [50,90],
				"behavior" : 2,
				"speed" : 20,
				"attack_pattern" : [
					MakeProjectile("GiantBlast_medium", (360.0/3.0)*1, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", (360.0/3.0)*2, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", (360.0/3.0)*3, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", ((360.0/6.0)*1)+30, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", ((360.0/6.0)*2)+30, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", ((360.0/6.0)*3)+30, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", ((360.0/6.0)*4)+30, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", ((360.0/6.0)*5)+30, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", ((360.0/6.0)*6)+30, 1, "nearest"),
				]
			},
			{
				"duration" : 4,
				"health" : [50,90],
				"behavior" : 0,
				"speed" : 20,
				"attack_pattern" : [
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*1), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*2), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*3), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*4), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*5), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*6), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*7), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*8), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*9), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*10), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*11), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*12), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*13), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*14), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*15), 0.5, "nearest"),
				]
			},
			{
				"duration" : 4,
				"health" : [20,50],
				"behavior" : 0,
				"on_spawn" : true,
				"max_uses" : 1,
				"speed" : 10,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 0,
					},
					{
						"speech" : "I have stood guard of this vigil for a millenium...",
						"wait" : 2,
					},
					{
						"speech" : "I will not fall to you lowly bottomfeeders!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : 4,
				"health" : [20,50],
				"behavior" : 2,
				"speed" : 10,
				"attack_pattern" : [
					MakeProjectile("GiantBlast_medium", 0, 0.2),
					MakeProjectile("NeonStar_strong_fast", 30, 0, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 30, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", 30, 0.2),
					MakeProjectile("GiantBlast_medium", 60, 0.2),
					MakeProjectile("GiantBlast_medium", 90, 0.2),
					MakeProjectile("NeonStar_strong_fast", 120, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", 120, 0.2),
					MakeProjectile("GiantBlast_medium", 150, 0.2),
					MakeProjectile("GiantBlast_medium", 180, 0.2),
					MakeProjectile("NeonStar_strong_fast", 0, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", 210, 0.2),
					MakeProjectile("GiantBlast_medium", 240, 0.2),
					MakeProjectile("GiantBlast_medium", 270, 0.2),
					MakeProjectile("NeonStar_strong_fast", 90, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", 300, 0.2),
					MakeProjectile("Wave_mid_fast", 30, 0, "nearest"),
					MakeProjectile("Wave_mid_fast", 20, 0, "nearest"),
					MakeProjectile("Wave_mid_fast", 10, 0, "nearest"),
					MakeProjectile("Wave_mid_fast", 0, 0, "nearest"),
					MakeProjectile("Wave_mid_fast", -30, 0, "nearest"),
					MakeProjectile("Wave_mid_fast", -20, 0, "nearest"),
					MakeProjectile("Wave_mid_fast", -10, 0, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 330, 0, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 270, 0, "nearest"),
				]
			},
		]
	},
	"orc_monolith" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(90,54), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 2000,
		"defense" : 1,
		"exp" : 2000,
		"behavior" : 0,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 16,
				"health" : [0,100],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 16,
						"wait" : 17,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("NeonArrow_mid_slow", 0, 0),
					MakeProjectile("NeonArrow_mid_slow", 90, 0),
					MakeProjectile("NeonArrow_mid_slow", 180, 0),
					MakeProjectile("NeonArrow_mid_slow", 270, 1),
				]
			}
		]
	},
	"atlas" : {
		"scale" : 1,
		"res" : 38,
		"height" : 20,
		"rect" : Rect2(Vector2(0,0), Vector2(114,38)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1,2],
		},
		
		"health" : 40000,
		"defense" : 10,
		"exp" : 10000,
		"behavior" : 0,
		"speed" : 15,
		"loot_pool" : special_loot_pools["atlas"],
		"phases" : [
			{
				"duration" : 18,
				"health" : [0,100],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 18,
						"wait" : 12,
					},
					{
						"speech" : "This vigil is the only remnant of the old orc empire...",
						"wait" : 2,
					},
					{
						"speech" : "Do you really think it's treasures would lie undefended?",
						"wait" : 2,
					},
					{
						"speech" : "Prepare yourselves!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : 4,
				"max_uses" : 1,
				"behavior" : 0,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"speech" : "Bare witness to the power of orc magicks!",
						"wait" : 1,
					},
					{
						"summon" : "vigil_construct",
						"summon_position" : Vector2(20,5),
						"wait" : 0,
					},
					{
						"summon" : "vigil_construct",
						"summon_position" : Vector2(-20,-5),
						"wait" : 5,
					},
				]
			},
			{
				"duration" : 6,
				"health" : [75,100],
				"behavior" : 1,
				"attack_pattern" : [
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*1, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*2, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*3, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*4, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*5, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*6, 2),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*7, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*8, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*9, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*10, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*11, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*12, 2),
				]
			},
			{
				"duration" : 8,
				"health" : [75,100],
				"behavior" : 2,
				"speed" : 15,
				"attack_pattern" : [
					MakeProjectile("GiantBlast_fast", -25, 0.1, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 180, 0, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", -45, 0.1, "nearest"),
					MakeProjectile("Blast_strong_fast", -5, 0.1, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 220, 0, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", 0, 0.1, "nearest"),
					MakeProjectile("GiantBlast_fast", 25, 0.1, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 160, 0, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", 30, 0.1, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 200, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", -10, 0.1, "nearest"),
				]
			},
			{
				"duration" : 8,
				"health" : [25,75],
				"behavior" : 2,
				"speed" : 5,
				"attack_pattern" : [
					MakeProjectile("VigilBlast_strong_fast", 0, 0, "nearest"),
					MakeProjectile("VigilBlast_strong_fast", 90, 0, "nearest"),
					MakeProjectile("VigilBlast_strong_fast", 180, 0, "nearest"),
					MakeProjectile("VigilBlast_strong_fast", 270, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+0, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+90, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+180, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+270, 0, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 0, 0.2, "nearest"),
				]
			},
			{
				"duration" : 8,
				"health" : [0,25],
				"behavior" : 2,
				"speed" : 10,
				"attack_pattern" : [
					MakeProjectile("VigilBlast_strong_fast", 0, 0, "nearest"),
					MakeProjectile("VigilBlast_strong_fast", 90, 0, "nearest"),
					MakeProjectile("VigilBlast_strong_fast", 180, 0, "nearest"),
					MakeProjectile("VigilBlast_strong_fast", 270, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+0, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+90, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+180, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+270, 0, "nearest"),
					
					MakeProjectile("GiantBlast_fast", -25, 0.1, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 180, 0, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", -45, 0.1, "nearest"),
					MakeProjectile("Blast_strong_fast", -5, 0.1, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 220, 0, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", 0, 0.1, "nearest"),
					MakeProjectile("GiantBlast_fast", 25, 0.1, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 160, 0, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", 30, 0.1, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 200, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", -10, 0.1, "nearest"),
				]
			},
		]
	},
	"vigil_construct" : {
		"scale" : 0.8,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(126,54), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 2000,
		"defense" : 1,
		"exp" : 1000,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 1,
				"health" : [0,100],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 6,
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"behavior" : 2,
				"speed" : 30,
				"attack_pattern" : [
					MakeProjectile("VigilBlastSmall_strong_fast", (360.0/8.0)*1, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", (360.0/8.0)*2, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", (360.0/8.0)*3, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", (360.0/8.0)*4, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", (360.0/8.0)*5, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", (360.0/8.0)*6, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", (360.0/8.0)*7, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", (360.0/8.0)*8, 2, "nearest"),
				]
			},
		]
	},
}
var frozen_fortress_enemies = {
	"frozen_monolith" : {
		"scale" : 1.3,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(90,72), Vector2(18,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [],
		},
		
		"health" : 2000,
		"defense" : 1,
		"exp" : 2000,
		"behavior" : 0,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 16,
				"health" : [0,100],
				"on_spawn" : true,
				"attack_pattern" : [
					MakeProjectile("None", 0, 1000, "nearest"),
				]
			},
		]
	},
}
var the_abyss_enemies = {
	"salazar_awakened" : {
		"scale" : 1,
		"res" : 38,
		"height" : 20,
		"rect" : Rect2(Vector2(114,0), Vector2(114,38)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2],
		},
		
		"health" : 1000,
		"defense" : 30,
		"exp" : 12000,
		"behavior" : 0,
		"speed" : 15,
		"loot_pool" : special_loot_pools["salazar_awakened"],
		"phases" : [
			{
				"duration" : 1,
				"health" : [0,100],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 17,
						"wait" : 12,
					},
					{
						"speech" : "Now your in MY domain...",
						"wait" : 4,
					},
					{
						"speech" : "I will die before letting you take this kingdom!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : 8,
				"health" : [75,100],
				"max_uses" : 1,
				"on_spawn" : true,
				"behavior" : 1,
				"speed" : 15,
				"attack_pattern" : [
					{
						"speech" : "Feel the inferno!",
						"wait" : 1,
					},
				] + CreateSpiral(2, "FlameBlast_strong_slow", 0.3, "GiantFlameArrow_strong_fast", 0.3)
			},
			{
				"duration" : 8,
				"health" : [25,75],
				"max_uses" : 1,
				"on_spawn" : true,
				"behavior" : 1,
				"speed" : 15,
				"attack_pattern" : [
					{
						"speech" : "Feel the inferno!",
						"wait" : 1,
					},
				] + CreateSpiral(2, "FlameBlast_strong_slow", 0.2, "GiantFlameArrow_strong_fast", 0.5)
			},
			{
				"duration" : 8,
				"health" : [0,25],
				"max_uses" : 1,
				"on_spawn" : true,
				"behavior" : 1,
				"speed" : 15,
				"attack_pattern" : [
					{
						"speech" : "Feel the inferno!",
						"wait" : 1,
					},
				] + CreateSpiral(3, "FlameBlast_strong_slow", 0.3, "GiantFlameArrow_strong_fast", 0.6, 16)
			},
			{
				"duration" : 8,
				"health" : [75,100],
				"behavior" : 1,
				"speed" : 15,
				"attack_pattern" : [
					MakeProjectile("GiantFlameBlast_strong_medium", (360.0/4.0)*1, 0),
					MakeProjectile("GiantFlameBlast_strong_medium", (360.0/4.0)*2, 0),
					MakeProjectile("GiantFlameBlast_strong_medium", (360.0/4.0)*3, 0),
					MakeProjectile("GiantFlameBlast_strong_medium", (360.0/4.0)*4, 0.5),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*1, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*2, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*3, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*4, 0.2),
					MakeProjectile("GiantFlameBlast_strong_medium", 45+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameBlast_strong_medium", 45+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameBlast_strong_medium", 45+((360.0/4.0)*3), 0),
					MakeProjectile("GiantFlameBlast_strong_medium", 45+((360.0/4.0)*4), 0.5),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*1, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*2, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*3, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*4, 0.2),
				]
			},
			{
				"duration" : 6,
				"health" : [75,100],
				"behavior" : 1,
				"speed" : 15,
				"attack_pattern" : [
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*1, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*2, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*3, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*4, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*5, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*6, 0.6),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*1, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*2, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*3, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*4, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*5, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*6, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*7, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*8, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*9, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*10, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*11, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*12, 0.6),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*7, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*8, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*9, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*10, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*11, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*12, 0.1),
				]
			},
			{
				"duration" : 6,
				"health" : [75,100],
				"behavior" : 0,
				"speed" : 15,
				"attack_pattern" : CreateSpiral(3, "FlameBurst_strong_slow", 0.3, "FlameBurst_strong_fast", 0.3, 16)
			},
			{
				"duration" : 10,
				"health" : [25,75],
				"behavior" : 1,
				"speed" : 15,
				"attack_pattern" : [
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*1, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*3, 1),
					MakeProjectile("GiantFlameArrow_strong_fast", 0+((360.0/4.0)*1), 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", 10+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -10+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", 10+((360.0/4.0)*3), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -10+((360.0/4.0)*3), 0.1),
					
					MakeProjectile("GiantFlameArrow_strong_fast", 20+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -20+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", 20+((360.0/4.0)*3), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -20+((360.0/4.0)*3), 0.1),
					
					MakeProjectile("GiantFlameArrow_strong_fast", 30+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -30+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", 30+((360.0/4.0)*3), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -30+((360.0/4.0)*3), 0.1),
					
					MakeProjectile("GiantFlameArrow_strong_fast", 40+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -40+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", 40+((360.0/4.0)*3), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -40+((360.0/4.0)*3), 2),
					
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*2, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*4, 1),
					MakeProjectile("GiantFlameArrow_strong_fast", 0+((360.0/4.0)*2), 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", 10+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -10+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", 10+((360.0/4.0)*4), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -10+((360.0/4.0)*4), 0.1),
					
					MakeProjectile("GiantFlameArrow_strong_fast", 20+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -20+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", 20+((360.0/4.0)*4), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -20+((360.0/4.0)*4), 0.1),
					
					MakeProjectile("GiantFlameArrow_strong_fast", 30+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -30+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", 30+((360.0/4.0)*4), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -30+((360.0/4.0)*4), 0.1),
					
					MakeProjectile("GiantFlameArrow_strong_fast", 40+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -40+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", 40+((360.0/4.0)*4), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -40+((360.0/4.0)*4), 2),
				]
			},
			{
				"duration" : 8,
				"health" : [25,75],
				"behavior" : 2,
				"speed" : 25,
				"attack_pattern" : [
					MakeProjectile("FlameBlast_strong_fast", 0, 0, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", 10, 0, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", -10, 0.3, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", 0, 0, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", 10, 0, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", -10, 0.3, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", 0, 0, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", 10, 0, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", -10, 0.3, "nearest"),
					
					MakeProjectile("GiantFlameBlast_strong_medium", (360.0/4.0)*1, 0, "nearest"),
					MakeProjectile("GiantFlameBlast_strong_medium", (360.0/4.0)*2, 0, "nearest"),
					MakeProjectile("GiantFlameBlast_strong_medium", (360.0/4.0)*3, 0, "nearest"),
					MakeProjectile("GiantFlameBlast_strong_medium", (360.0/4.0)*4, 0.5, "nearest"),
					MakeProjectile("GiantFlameBlast_strong_fast", 45+(360.0/4.0)*1, 0, "nearest"),
					MakeProjectile("GiantFlameBlast_strong_fast", 45+(360.0/4.0)*2, 0, "nearest"),
					MakeProjectile("GiantFlameBlast_strong_fast", 45+(360.0/4.0)*3, 0, "nearest"),
					MakeProjectile("GiantFlameBlast_strong_fast", 45+(360.0/4.0)*4, 0.2, "nearest"),
				]
			},
			{
				"duration" : 6,
				"health" : [25,75],
				"behavior" : 0,
				"speed" : 15,
				"attack_pattern" : CreateSpiral(1, "GiantFlameBlast_strong_medium", 0.1, "FlameArrow_mid_fast", 0.8, 16)
			},
			{
				"duration" : 6,
				"health" : [0,25],
				"on_spawn" : true,
				"max_uses" : 1,
				"behavior" : 0,
				"speed" : 15,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 3,
					},
					{
						"speech" : "I will destroy this very abyss if I have to!",
						"wait" : 4,
					},
				]
			},
			{
				"duration" : 20,
				"health" : [0,25],
				"behavior" : 2,
				"speed" : 5,
				"attack_pattern" : [
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*1, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*2, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*3, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*4, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*5, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*6, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*7, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*8, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*9, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*10, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*11, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*12, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*13, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*14, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*15, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*16, 0.1),
					
					MakeProjectile("GiantFlameBlast_strong_medium", 0+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameBlast_strong_medium", 0+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameBlast_strong_medium", 0+((360.0/4.0)*3), 0),
					MakeProjectile("GiantFlameBlast_strong_medium", 0+((360.0/4.0)*4), 0.1),
					MakeProjectile("GiantFlameBlast_strong_medium", 45+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameBlast_strong_medium", 45+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameBlast_strong_medium", 45+((360.0/4.0)*3), 0),
					MakeProjectile("GiantFlameBlast_strong_medium", 45+((360.0/4.0)*4), 1),
					
					MakeProjectile("GiantFlameArrow_strong_medium", 0, 0.1, "nearest"),
					MakeProjectile("GiantFlameArrow_strong_medium", 10, 0, "nearest"),
					MakeProjectile("GiantFlameArrow_strong_medium", -10, 0.1, "nearest"),
					
					MakeProjectile("GiantFlameArrow_strong_medium", 20, 0, "nearest"),
					MakeProjectile("GiantFlameArrow_strong_medium", -20, 0.1, "nearest"),
					
					MakeProjectile("GiantFlameArrow_strong_medium", 30, 0, "nearest"),
					MakeProjectile("GiantFlameArrow_strong_medium", -30, 0.1, "nearest"),
					
					MakeProjectile("GiantFlameArrow_strong_medium", 40, 0, "nearest"),
					MakeProjectile("GiantFlameArrow_strong_medium", -40, 1, "nearest"),
				]
			},
		]
	},
}
onready var enemies = CompileEnemies()
func CompileEnemies():
	var res = {}
	res.merge(rulers)
	res.merge(tutorial_enemies)
	res.merge(realm_enemies)
	res.merge(orc_vigil_enemies)
	res.merge(frozen_fortress_enemies)
	res.merge(the_abyss_enemies)
	return res

var dungeons = {
	"island" : {},
	"orc_vigil" : {
		"type" : "encounter",
		"room_size" : 100,
		"spawnpoint" : Vector2(10,10)*8,
		"tile_translation" : {
			5 : "vigil_guardian",
			6 : "orc_monolith",
		}
	},
	"orc_vigil_sanctum" : {
		"type" : "encounter",
		"room_size" : 100,
		"spawnpoint" : Vector2(10,10)*8,
		"tile_translation" : {
			5 : "atlas",
		}
	},
	"the_abyss" : {
		"type" : "encounter",
		"room_size" : 100,
		"spawnpoint" : Vector2(10,10)*8,
		"tile_translation" : {
			7 : "salazar_awakened",
		}
	},
	"frozen_fortress" : {
		"type" : "procedural",
		"basic_rooms" : ["Spawn"],
		"rooms_until_boss" : 1,
		"room_size" : 26,
		"tile_translation" : {
			6 : "frozen_monolith",
		}
	},
	"test_dungeon" : {
		"type" : "procedural",
		"basic_rooms" : ["Room1", "Room2"],
		"rooms_until_boss" : 5,
		"room_size" : 20,
		"tile_translation" : {
			5 : "crab",
		}
	},
}

var items = {
	0 : {
		"name": "Ascension Stone",
		"description" : "A precious gemstone, what will it awaken in you?",
		"tier" : "4",
		"type" : "Consumable",
		"use" : "ascend",
		"slot" : "na",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,13)],
	},
	100 : {
		"name": "Short Sword",
		"description" : "A simple yet effective weapon.",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "0",
		
		"rof" : 100,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [15,25],
				"projectile" : "IronSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : 50,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,0)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(105.0, 51.0, 10.0),
			"weaponNew" : RgbToColor(174.0, 172.0, 156.0)
		},
		"textures" : {}
	},
	101 : {
		"name": "Gold Sword",
		"description" : "A sword that is equally as effective as it is flashy",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "1",
		
		"rof" : 100,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [25,35],
				"projectile" : "GoldSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : 50,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,0)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(161.0, 87.0, 8.0),
			"weaponNew" : RgbToColor(231.0, 211.0, 61.0)
		},
		"textures" : {}
	},
	102 : {
		"name": "Platinum Sword",
		"description" : "A razor sharp blade made from a precious metal",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "2",
		
		"rof" : 100,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [40,55],
				"projectile" : "PlatinumSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : 50,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,0)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(161.0, 87.0, 8.0),
			"weaponNew" : RgbToColor(231.0, 211.0, 61.0)
		},
		"textures" : {}
	},
	103 : {
		"name": "Mithril Sword",
		"description" : "A sword made from an impossibly light and durable blue metal",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "3",
		
		"rof" : 100,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [65,90],
				"projectile" : "MithrilSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : 50,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,0)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(74.0, 33.0, 4.0),
			"weaponNew" : RgbToColor(25.0, 182.0, 182.0)
		},
		"textures" : {}
	},
	104 : {
		"name": "Rexium Sword",
		"description" : "A sword capable of slicing worlds",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "4",
		
		"rof" : 100,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [80,110],
				"projectile" : "RexiumSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : 50,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,0)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(231.0, 211.0, 61.0),
			"weaponNew" : RgbToColor(134.0, 2.0, 141.0)
		},
		"textures" : {}
	},
	105 : {
		"name": "Warlords Vigil",
		"description" : "An axe unbeknownst to mankind",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "UT",
		
		"rof" : 150,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [80,110],
				"projectile" : "Dart",
				"formula" : "0",
				"piercing" : false,
				"speed" : 50,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(0),
			},
			{
				"damage" : [80,110],
				"projectile" : "Dart",
				"formula" : "0",
				"piercing" : false,
				"speed" : 50,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(25),
			},
			{
				"damage" : [80,110],
				"projectile" : "Dart",
				"formula" : "0",
				"piercing" : false,
				"speed" : 50,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(-25),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(7,0)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(231.0, 211.0, 61.0),
			"weaponNew" : RgbToColor(134.0, 2.0, 141.0)
		},
		"textures" : {}
	},
	133 : {
		"name": "Wand of Fire",
		"description" : "A wooden wand with a fire spell",
		"type" : "Staff",
		"slot" : "weapon",
		"tier" : "0",
		
		"rof" : 150,
		"stats" : {
		
		},
		"projectiles" : [
			{
				"damage" : [10,15],
				"projectile" : "Fire1",
				"formula" : "0",
				"piercing" : false,
				"speed" : 100,
				"tile_range" : 7,
				"size" : 3,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(9,3)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(105.0, 51.0, 10.0)
		},
		"textures" : {
		}
	},
	134 : {
		"name": "Staff of Fire",
		"description" : "A  with a fire spell",
		"type" : "Staff",
		"slot" : "weapon",
		"tier" : "2",
		
		"rof" : 150,
		"stats" : {
		
		},
		
		"projectiles" : [
			{
				"damage" : [25,30],
				"projectile" : "Fire2",
				"formula" : "0",
				"piercing" : false,
				"speed" : 100,
				"tile_range" : 7,
				"size" : 3,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(10,3)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(232.0, 210.0, 65.0)
		},
		"textures" : {
		}
	},
	135 : {
		"name": "Sceptre of Fire",
		"description" : "A powerful sceptre with a fire spell",
		"type" : "Staff",
		"slot" : "weapon",
		"tier" : "4",
		
		"rof" : 150,
		"stats" : {
					
		},
		
		"projectiles" : [
			{
				"damage" : [50,60],
				"projectile" : "Fire3",
				"formula" : "0",
				"piercing" : false,
				"speed" : 100,
				"tile_range" : 7,
				"size" : 3,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(11,3)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(232.0, 210.0, 65.0)
		},
		"textures" : {
		}
	},
	500 : {
		"name": "Iron Platebody",
		"description" : "A beginner warriors only protection from death",
		"type" : "Armor",
		"slot" : "armor",
		"tier" : "0",
		
		"stats" : {
			"defense" : 6
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,4)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(157.0, 153.0, 135.0),
			"bodyLightNew" : RgbToColor(174.0, 172.0, 156.0),
			"bandNew" : RgbToColor(0.0, 0.0, 0.0),
		},
		"textures" : {
			
		}
	},
	501 : {
		"name": "Gold Platebody",
		"description" : "A regal platebody for a strong warrior",
		"type" : "Armor",
		"slot" : "armor",
		"tier" : "1",
		
		"stats" : {
			"defense" : 8
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,4)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(207.0, 189.0, 56.0),
			"bodyLightNew" : RgbToColor(231.0, 211.0, 61.0),
			"bandNew" : RgbToColor(0.0, 0.0, 0.0),
		},
		"textures" : {
			
		}
	},
	502 : {
		"name": "Platinum Platebody",
		"description" : "A premium armor made from a premium metal",
		"type" : "Armor",
		"slot" : "armor",
		"tier" : "2",
		
		"stats" : {
			"defense" : 12
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,4)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(204.0, 203.0, 197.0),
			"bodyLightNew" : RgbToColor(209.0, 208.0, 205.0),
			"bandNew" : RgbToColor(0.0, 0.0, 0.0),
		},
		"textures" : {
			
		}
	},
	503 : {
		"name": "Mithril Platebody",
		"description" : "An armor capable of deflecting fearsome blows",
		"type" : "Armor",
		"slot" : "armor",
		"tier" : "3",
		
		"stats" : {
			"defense" : 16
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,4)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(23.0, 163.0, 163.0),
			"bodyLightNew" : RgbToColor(25.0, 182.0, 182.0),
			"bandNew" : RgbToColor(0.0, 0.0, 0.0),
		},
		"textures" : {
			
		}
	},
	504 : {
		"name": "Rexium Platebody",
		"description" : "A magic alloy forms the strongest armor imaginable",
		"type" : "Armor",
		"slot" : "armor",
		"tier" : "4",
		
		"stats" : {
			"defense" : 20
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,4)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(108.0, 2.0, 113.0),
			"bodyLightNew" : RgbToColor(134.0, 2.0, 141.0),
			"bandNew" : RgbToColor(0.0, 0.0, 0.0),
		},
		"textures" : {
			
		}
	},
	533 : {
		"name": "Worn robe",
		"description" : "A flimsy robe",
		"type" : "Robe",
		"slot" : "armor",
		"tier" : "0",
		
		"stats" : {
			"defense" : 1,
			"attack" : 1
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,5)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(105, 51.0, 10.0),
			"bodyLightNew" : RgbToColor(123.0, 72.0, 17.0),
			"bandNew" : RgbToColor(83.0, 39.0, 6.0),
		},
		"textures" : {
			
		}
	},
	534 : {
		"name": "Leather robe",
		"description" : "a fine leather robe",
		"type" : "Robe",
		"slot" : "armor",
		"tier" : "1",
		
		"stats" : {
			"defense" : 2,
			"attack" : 2
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,5)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(161.0, 87.0, 8.0),
			"bodyLightNew" : RgbToColor(184.0, 99.0, 8.0),
			"bandNew" : RgbToColor(190.0, 168.0, 48.0),
		},
		"textures" : {
			
		}
	},
	535 : {
		"name": "Magic robe",
		"description" : "a wizard's robe imbued with a magic spell",
		"type" : "Robe",
		"slot" : "armor",
		"tier" : "2",
		
		"stats" : {
			"defense" : 3,
			"attack" : 4
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,5)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(23.0, 163.0, 163.0),
			"bodyLightNew" : RgbToColor(25.0, 182.0, 182.0),
			"bandNew" : RgbToColor(225.0, 222.0, 213.0),
		},
		"textures" : {
			
		}
	},
	536 : {
		"name": "Dragonhide robe",
		"description" : "a powerful robe made from the skin of a dragon",
		"type" : "Robe",
		"slot" : "armor",
		"tier" : "3",
		
		"stats" : {
			"defense" : 5,
			"attack" : 7
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,5)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(160.0, 18.0, 0.0),
			"bodyLightNew" : RgbToColor(25.0, 182.0, 182.0),
			"bandNew" : RgbToColor(188.0, 21.0, 0.0),
		},
		"textures" : {
			
		}
	},
	537 : {
		"name": "Master's robe",
		"description" : "a robe made for master wizards and magicians",
		"type" : "Robe",
		"slot" : "armor",
		"tier" : "4",
		
		"stats" : {
			"defense" : 6,
			"attack" : 10
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,5)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(0.0, 106.0, 138.0),
			"bodyLightNew" : RgbToColor(0.0, 125.0, 163.0),
			"bandNew" : RgbToColor(231.0, 211.0, 61.0),
		},
		"textures" : {
			
		}
	},
	566 : {
		"name": "Worn tunic",
		"description" : "An old tunic not worth its weight in fabric",
		"type" : "Hide",
		"slot" : "armor",
		"tier" : "0",
		
		"stats" : {
			"speed" : 2,
			"defense" : 1 
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,6)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(105, 51.0, 10.0),
			"bodyLightNew" : RgbToColor(123.0, 72.0, 17.0),
			"bandNew" : RgbToColor(83.0, 39.0, 6.0),
		},
		"textures" : {
			
		}
	},
	567 : {
		"name": "Leather tunic",
		"description" : "A simple leather tunic",
		"type" : "Hide",
		"slot" : "armor",
		"tier" : "1",
		
		"stats" : {
			"speed" : 3,
			"defense" : 3 
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,6)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(161, 87.0, 8.0),
			"bodyLightNew" : RgbToColor(184.0, 99.0, 8.0),
			"bandNew" : RgbToColor(207.0, 189.0, 56.0),
		},
		"textures" : {
			
		}
	},
	568 : {
		"name": "Magic tunic",
		"description" : "A tunic imbued with magical properties",
		"type" : "Hide",
		"slot" : "armor",
		"tier" : "2",
		
		"stats" : {
			"speed" : 4,
			"defense" : 5
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,6)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(23.0, 163.0, 163.0),
			"bodyLightNew" : RgbToColor(25.0, 182.0, 182.0),
			"bandNew" : RgbToColor(225.0, 222.0, 213.0),
		},
		"textures" : {
			
		}
	},
	569 : {
		"name": "Dragonhide tunic",
		"description" : "A powerful tunic made from the hide of a powerful dragon",
		"type" : "Hide",
		"slot" : "armor",
		"tier" : "3",
		
		"stats" : {
			"speed" : 5,
			"defense" : 7
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,6)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(114.0, 12.0, 0.0),
			"bodyLightNew" : RgbToColor(160.0, 18.0, 0.0),
			"bandNew" : RgbToColor(213.0, 213.0, 148.0),
		},
		"textures" : {
			
		}
	},
	570 : {
		"name": "Master's tunic",
		"description" : "A tunic made for a master archer",
		"type" : "Hide",
		"slot" : "armor",
		"tier" : "4",
		
		"stats" : {
			"speed" : 6,
			"defense" : 10
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,6)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(231.0, 211.0, 61.0),
			"bodyLightNew" : RgbToColor(2.0, 131.0, 116.0),
			"bandNew" : RgbToColor(2.0, 131.0, 116.0),
		},
		"textures" : {
			
		}
	},
	400 : {
		"name": "Iron Helmet",
		"description" : "A basic helmet that has seen many battles.",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 6,
		"buffs" : {
			"armored" : { "duration" : 4, "range" : 5},
		},
		"stats" : {
			"defense" : 5,
			"vitality" : 5,
		},
		"tier" : "0",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,8)],
		"colors" : {
			"helmetMediumNew" : RgbToColor(157.0, 153.0, 135.0),
			"helmetLightNew" : RgbToColor(174.0, 172.0, 156.0),
			"helmetDarkNew" : RgbToColor(157.0, 153.0, 135.0),
		},
		"textures" : {
			
		}
	},
	401 : {
		"name": "Gold Helmet",
		"description" : "A sturdy gold helmet",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 6,
		"buffs" : {
			"armored" : { "duration" : 5, "range" : 5},
		},
		"stats" : {
			"defense" : 7,
			"vitality" : 7,
		},
		"tier" : "1",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,8)],
		"colors" : {
			"helmetLightNew" : RgbToColor(231.0, 211.0, 61.0),
			"helmetMediumNew" : RgbToColor(207.0, 189.0, 56.0),
			"helmetDarkNew" : RgbToColor(190.0, 168.0, 48.0),
		},
		"textures" : {
			
		}
	},
	402 : {
		"name": "Platinum Helmet",
		"description" : "A durable helmet made out of a premium platinum alloy",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 6,
		"buffs" : {
			"armored" : { "duration" : 6, "range" : 5},
		},
		"stats" : {
			"defense" : 9,
			"vitality" : 9,
		},
		"tier" : "2",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,8)],
		"colors" : {
			"helmetLightNew" : RgbToColor(209.0, 208.0, 205.0),
			"helmetMediumNew" : RgbToColor(204.0, 203.0, 197.0),
			"helmetDarkNew" : RgbToColor(195.0, 195.0, 195.0),
		},
		"textures" : {
			
		}
	},
	403 : {
		"name": "Mithril Helmet",
		"description" : "A perfectly crafted helmet made from a magic ore",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 6,
		"buffs" : {
			"armored" : { "duration" : 6.5, "range" : 5},
		},
		"stats" : {
			"defense" : 10,
			"vitality" : 10,
		},
		"tier" : "3",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,8)],
		"colors" : {
			"helmetLightNew" : RgbToColor(25.0, 182.0, 182.0),
			"helmetMediumNew" : RgbToColor(23.0, 163.0, 163.0),
			"helmetDarkNew" : RgbToColor(20.0, 140.0, 140.0),
		},
		"textures" : {
			
		}
	},
	404 : {
		"name": "Rexium Helmet",
		"description" : "You wont find a helmet stronger than this",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 6,
		"buffs" : {
			"armored" : { "duration" : 8, "range" : 5},
		},
		"stats" : {
			"defense" : 15,
			"vitality" : 15,
		},
		"tier" : "4",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,8)],
		"colors" : {
			"helmetLightNew" : RgbToColor(134.0, 2.0, 141.0),
			"helmetMediumNew" : RgbToColor(108.0, 2.0, 113.0),
			"helmetDarkNew" : RgbToColor(90.0, 16.0, 82.0),
		},
		"textures" : {
			
		}
	},
	433 : {
		"name": "Worn hat",
		"description" : "A miserable hat hardly fit for casting spells",
		"type" : "Hat",
		"slot" : "helmet",
		
		"cooldown" : 4,
		"buffs" : {
			"healing" : { "duration" : 1.5, "range" : 3},
		},
		"stats" : {
			"attack" : 3,
		},
		"tier" : "0",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,9)],
		"colors" : {
			"helmetLightNew" : RgbToColor(92.0, 97.0, 158.0),
			"helmetMediumNew" : RgbToColor(79.0, 77.0, 144.0),
			"helmetDarkNew" : RgbToColor(62.0, 60.0, 124.0),
		},
		"textures" : {
			
		}
	},
	434 : {
		"name": "Wizard's hat",
		"description" : "A slightly magical hat fit for casting spells",
		"type" : "Hat",
		"slot" : "helmet",
		
		"cooldown" : 4,
		"buffs" : {
			"healing" : { "duration" : 2, "range" : 3},
		},
		"stats" : {
			"attack" : 5,
			"defense" : 1
		},
		"tier" : "1",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,9)],
		"colors" : {
			"helmetLightNew" : RgbToColor(58.0, 66.0, 168.0),
			"helmetMediumNew" : RgbToColor(54.0, 51.0, 148.0),
			"helmetDarkNew" : RgbToColor(54.0, 51.0, 148.0),
		},
		"textures" : {
			
		}
	},
	435 : {
		"name": "Eagle-feather hat",
		"description" : "A hat made for a strong druid",
		"type" : "Hat",
		"slot" : "helmet",
		
		"cooldown" : 4,
		"buffs" : {
			"healing" : { "duration" : 2.5, "range" : 3},
		},
		"stats" : {
			"attack" : 7,
			"defense" : 2
		},
		"tier" : "2",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,9)],
		"colors" : {
			"helmetLightNew" : RgbToColor(243.0, 184.0, 73.0),     #note, these colours do not match the sprite 1 to 1 and should be changed
			"helmetMediumNew" : RgbToColor(225.0, 164.0, 51.0),
			"helmetDarkNew" : RgbToColor(210.0, 146.0, 24.0),
		},
		"textures" : {
			
		}
	},
	436 : {
		"name": "Dragonhide hat",
		"description" : "A wizard hat made from a strong dragonhide",
		"type" : "Hat",
		"slot" : "helmet",
		
		"cooldown" : 4,
		"buffs" : {
			"healing" : { "duration" : 3, "range" : 3},
		},
		"stats" : {
			"attack" : 9,
			"defense" : 2
		},
		"tier" : "3",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,9)],
		"colors" : {
			"helmetLightNew" : RgbToColor(247.0, 83.0, 24.0),     #note, these colours do not match the sprite 1 to 1 and should be changed
			"helmetMediumNew" : RgbToColor(202.0, 61.0, 10.0),
			"helmetDarkNew" : RgbToColor(175.0, 51.0, 7.0),
		},
		"textures" : {
			
		}
	},
	437 : {
		"name": "Master's hat",
		"description" : "A hat only the greatest wizards are worthy to wear",
		"type" : "Hat",
		"slot" : "helmet",
		
		"cooldown" : 4,
		"buffs" : {
			"healing" : { "duration" : 3.5, "range" : 3},
		},
		"stats" : {
			"attack" : 12,
			"defense" : 3
		},
		"tier" : "4",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,9)],
		"colors" : {
			"helmetLightNew" : RgbToColor(70.0, 160.0, 100.0),     #note, these colours do not match the sprite 1 to 1 and should be changed
			"helmetMediumNew" : RgbToColor(54.0, 148.0, 85.0),
			"helmetDarkNew" : RgbToColor(46.0, 136.0, 71.0),
		},
		"textures" : {
			
		}
	},
	466 : {
		"name": "Worn cap",
		"description" : "A second hand cap used by beginner archers",
		"type" : "Cap",
		"slot" : "helmet",
		
		"cooldown" : 7,
		"buffs" : {
			"berserk" : { "duration" : 2, "range" : 4},
		},
		"stats" : {
			"dexterity" : 3,
		},
		"tier" : "0",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,10)],
		"colors" : {
			"helmetLightNew" : RgbToColor(125.0, 90.0, 35.0),     #note, these colours do not match the sprite 1 to 1 and should be changed
			"helmetMediumNew" : RgbToColor(120.0, 70.0, 25.0),
			"helmetDarkNew" : RgbToColor(105.0, 58.0, 15.0),
		},
		"textures" : {
			
		}
	},
	467 : {
		"name": "Leather cap",
		"description" : "A fine cap made from leather",
		"type" : "Cap",
		"slot" : "helmet",
		
		"cooldown" : 7,
		"buffs" : {
			"berserk" : { "duration" : 2.5, "range" : 4},
		},
		"stats" : {
			"dexterity" : 4,
			"defense" : 1
		},
		"tier" : "1",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,10)],
		"colors" : {
			"helmetLightNew" : RgbToColor(210.0, 130, 50.0),     #note, these colours do not match the sprite 1 to 1 and should be changed
			"helmetMediumNew" : RgbToColor(200.0, 115.0, 45.0),
			"helmetDarkNew" : RgbToColor(184.0, 108.0, 37.0),
		},
		"textures" : {
			
		}
	},
	468 : {
		"name": "Eagle-feather cap",
		"description" : "An excellent cap made from the feathers of an eagle",
		"type" : "Cap",
		"slot" : "helmet",
		
		"cooldown" : 7,
		"buffs" : {
			"berserk" : { "duration" : 3, "range" : 4},
		},
		"stats" : {
			"dexterity" : 6,
			"defense" : 2
		},
		"tier" : "2",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,10)],
		"colors" : {
			"helmetLightNew" : RgbToColor(230.0, 165, 50.0),     #note, these colours do not match the sprite 1 to 1 and should be changed
			"helmetMediumNew" : RgbToColor(215.0, 155.0, 45.0),
			"helmetDarkNew" : RgbToColor(207.0, 149.0, 41.0),
		},
		"textures" : {
			
		}
	},
	469 : {
		"name": "Dragonhide cap",
		"description" : "An elite cap made from the hide of a powerful dragon",
		"type" : "Cap",
		"slot" : "helmet",
		
		"cooldown" : 7,
		"buffs" : {
			"berserk" : { "duration" : 3.5, "range" : 4},
		},
		"stats" : {
			"dexterity" : 7,
			"defense" : 3
		},
		"tier" : "3",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,10)],
		"colors" : {
			"helmetLightNew" : RgbToColor(200.0, 65, 35.0),     #note, these colours do not match the sprite 1 to 1 and should be changed
			"helmetMediumNew" : RgbToColor(190.0, 55.0, 27.0),
			"helmetDarkNew" : RgbToColor(181.0, 48.0, 22.0),
		},
		"textures" : {
			
		}
	},
	470 : {
		"name": "Master's cap",
		"description" : "A one of a kind cap passed down from master archers",
		"type" : "Cap",
		"slot" : "helmet",
		
		"cooldown" : 7,
		"buffs" : {
			"berserk" : { "duration" : 4, "range" : 4},
		},
		"stats" : {
			"dexterity" : 9,
			"defense" : 4
		},
		"tier" : "4",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,10)],
		"colors" : {
			"helmetLightNew" : RgbToColor(45.0, 165, 28.0),     #note, these colours do not match the sprite 1 to 1 and should be changed
			"helmetMediumNew" : RgbToColor(35.0, 155.0, 15.0),
			"helmetDarkNew" : RgbToColor(27.0, 145.0, 9.0),
		},
		"textures" : {
			
		}
	},
}

var buildings = {
	"storage" : {
		"name" : "Storage Chest",
		"type" : "object",
		"catagory" : "storage",
		"description" : "For storing up to 8 items.",
		
		"craftable" : true,
		"materials" : [0,0,1],
		"max" : 20,
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(50,40)],
	},
	"grass" : {
		"name" : "Grass Tile",
		"type" : "tile",
		"description" : "Don't forget to water.",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["tiles/tileset.png", 26, 26, Vector2(0,60)],
		"tile" : 2,
	},
	"stone" : {
		"name" : "Stone Tile",
		"type" : "tile",
		"description" : "Hard as rock.",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["tiles/tileset.png", 26, 26, Vector2(70,60)],
		"tile" : 3,
	},
	"stone_wall" : {
		"name" : "Stone Wall",
		"type" : "tile",
		"description" : "Fortress strength in every block.",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["tiles/tileset.png", 26, 26, Vector2(130,70)],
		"tile" : 4,
	},
	"wooden_planks" : {
		"name" : "Wooden Planks",
		"type" : "tile",
		"description" : "Straight from the docks.",
		
		"craftable" : true,
		"materials" : [0,0,0],
		"max" : 20,
		"path" : ["tiles/tileset.png", 26, 26, Vector2(140,60)],
		"tile" : 5,
	},
	"wooden_wall" : {
		"name" : "Wooden Wall",
		"type" : "tile",
		"description" : "Carved with care, built to last.",
		
		"craftable" : true,
		"materials" : [0,0,0],
		"max" : 20,
		"path" : ["tiles/tileset.png", 26, 26, Vector2(140,60)],
		"tile" : 6,
	},
	"apprentice_statue" : {
		"name" : "Apprentice Statue",
		"type" : "object",
		"catagory" : "statue",
		"description" : "Gives nearby players a health boost (2m).",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(60,40)],
	},
	"noble_statue" : {
		"name" : "Noble Statue",
		"type" : "object",
		"catagory" : "statue",
		"description" : "Gives nearby players a defense boost (2m).",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(70,40)],
		"achievement" : "Trial By Fire",
	},
	"nomad_statue" : {
		"name" : "Nomad Statue",
		"type" : "object",
		"catagory" : "statue",
		"description" : "Gives nearby players a fire rate boost (2m).",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(80,40)],
		"achievement" : "Trial By Fire",
	},
	"scholar_statue" : {
		"name" : "Scholar Statue",
		"type" : "object",
		"catagory" : "statue",
		"description" : "Gives nearby players a health regen boost (2m).",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(90,40)],
		"achievement" : "Trial By Fire",
	},
}

var projectiles = {
	"Slash" : {
		"rect" : Rect2(0,0,10,10),
		"rotation" : 90,
		"spin" : false,
	},
	"Wave" : {
		"rect" : Rect2(10,0,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Ball" : {
		"rect" : Rect2(20,0,10,10),
		"rotation" : 90,
		"spin" : false,
	},
	"GiantBall" : {
		"rect" : Rect2(20,0,10,10),
		"rotation" : 90,
		"spin" : false,
		"scale" : 1.5
	},
	"Stack" : {
		"rect" : Rect2(30,0,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"CannonBall" : {
		"rect" : Rect2(40,0,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Ring" : {
		"rect" : Rect2(50,0,10,10),
		"rotation" : 90,
		"spin" : false,
		"scale" : 1.3,
	},
	"Dart" : {
		"rect" : Rect2(60,0,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"GoldDart" : {
		"rect" : Rect2(150,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.4,
	},
	"VigilBlast" : {
		"rect" : Rect2(160,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.2,
	},
	"VigilBlastSmall" : {
		"rect" : Rect2(170,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"NeonStar" : {
		"rect" : Rect2(180,0,10,10),
		"rotation" : 45,
		"spin" : true,
		"scale" : 1,
	},
	"NeonArrow" : {
		"rect" : Rect2(190,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"Spinner" : {
		"rect" : Rect2(70,0,10,10),
		"rotation" : 45,
		"spin" : true,
	},
	"GiantSpinner" : {
		"rect" : Rect2(70,0,10,10),
		"rotation" : 45,
		"spin" : true,
		"scale" : 1.4,
	},
	"Star" : {
		"rect" : Rect2(80,0,10,10),
		"rotation" : 45,
		"spin" : true,
	},
	"Blast" : {
		"rect" : Rect2(90,0,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"GiantBlast" : {
		"rect" : Rect2(90,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.6,
	},
	"SmallBlast" : {
		"rect" : Rect2(100,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"GreenBlast" : {
		"rect" : Rect2(110,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"BrownBlast" : {
		"rect" : Rect2(120,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"BlueBlast" : {
		"rect" : Rect2(130,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"RedBlast" : {
		"rect" : Rect2(140,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"IronSlash" : {
		"rect" : Rect2(0,10,10,10),
		"rotation" : 90,
		"spin" : false,
	},
	"GoldSlash" : {
		"rect" : Rect2(10,10,10,10),
		"rotation" : 90,
		"spin" : false,
	},
	"PlatinumSlash" : {
		"rect" : Rect2(20,10,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"MithrilSlash" : {
		"rect" : Rect2(30,10,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"RexiumSlash" : {
		"rect" : Rect2(40,10,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"SteelArrow" : {
		"rect" : Rect2(0,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"GoldenArrow" : {
		"rect" : Rect2(10,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"CobaltArrow" : {
		"rect" : Rect2(20,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"BloodArrow" : {
		"rect" : Rect2(30,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.9,
	},
	"RexiumArrow" : {
		"rect" : Rect2(40,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"Nature1" : {
		"rect" : Rect2(0,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Water1" : {
		"rect" : Rect2(10,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Fire1" : {
		"rect" : Rect2(20,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Nature2" : {
		"rect" : Rect2(30,30,10,10),
		"rotation" : 90,
		"spin" : true,
	},
	"Water2" : {
		"rect" : Rect2(40,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Fire2" : {
		"rect" : Rect2(50,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Nature3" : {
		"rect" : Rect2(60,30,10,10),
		"rotation" : 90,
		"spin" : true,
	},
	"Water3" : {
		"rect" : Rect2(70,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Fire3" : {
		"rect" : Rect2(80,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Void1" : {
		"rect" : Rect2(90,30,10,10),
		"rotation" : 90,
		"spin" : true,
	},
	"FlameBurst" : {
		"rect" : Rect2(200,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"FlameArrow" : {
		"rect" : Rect2(210,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"GiantFlameArrow" : {
		"rect" : Rect2(210,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.5,
	},
	"FlameBlast" : {
		"rect" : Rect2(220,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"GiantFlameBlast" : {
		"rect" : Rect2(220,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.5,
	},
	"IceSlash" : {
		"rect" : Rect2(230,0,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"GiantIceSlash" : {
		"rect" : Rect2(230,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.5,
	},
	"AbyssSpinner" : {
		"rect" : Rect2(240,0,10,10),
		"rotation" : 45,
		"spin" : true,
		"scale" : 1,
	},
	"GiantAbyssSpinner" : {
		"rect" : Rect2(240,0,10,10),
		"rotation" : 45,
		"spin" : true,
		"scale" : 1.6,
	},
	"RoyalSlash" : {
		"rect" : Rect2(250,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"GiantRoyalSlash" : {
		"rect" : Rect2(250,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.4,
	},
}

var achievement_catagories = {
	"Classes" : { 
		"achievements" : ["Job Hopper", "Westerly Winds", "Starlight, Starbright", "Brave Story", "True Warrior"], 
		"icon" : Vector2(0,0)
	},
	"Combat" : {
		"achievements" : ["Back From The Dead", "Sharpest Shooter", "Druidic Slayer", "On The Rocks", "History Of Beasts", "Fear To Fortitude", "Dragon Slayer"], 
		"icon" : Vector2(10,0)
	},
	"Misc" : { 
		"achievements" : ["Mr. Worldwide","6 Feet Under I","6 Feet Under II","6 Feet Under III"], 
		"icon" : Vector2(20,0)
	},
}

var achievements = {
	"6 Feet Under I" : {
		"which" : "deaths",
		"amount" : 5,
		"icon" : Vector2(0,30),
		"description" : "Die 5 times.",
		"gold" : 200,
	},
	"6 Feet Under II" : {
		"which" : "deaths",
		"amount" : 25,
		"icon" : Vector2(0,30),
		"description" : "Die 25 times.",
		"gold" : 400,
	},
	"6 Feet Under III" : {
		"which" : "deaths",
		"amount" : 125,
		"icon" : Vector2(0,30),
		"description" : "Die 125 times.",
		"gold" : 800,
	},
	"Mr. Worldwide" : {
		"which" : "tiles_covered",
		"amount" : 1000000,
		"icon" : Vector2(10,30),
		"description" : "Travel 1000000 tiles.",
		"gold" : 400,
	},
	"Back From The Dead" : {
		"which" : "enemies_killed",
		"amount" : 1000,
		"enemies" : ["cacodemon", "basalisk", "phoenix", "archmage"],
		"icon" : Vector2(20,20),
		"description" : "Kill 100 skeletons.",
		"gold" : 200,
	},
	"Sharpest Shooter" : {
		"which" : "projectiles_landed",
		"amount" : 1000000,
		"icon" : Vector2(60,20),
		"description" : "Kill 1000 druids.",
		"gold" : 300,
	},
	"Druidic Slayer" : {
		"which" : "enemies_killed",
		"amount" : 1000,
		"enemies" : ["ice_druid", "nature_druid", "fire_druid", "shadow_druid"],
		"icon" : Vector2(10,20),
		"description" : "Kill 1000 druids.",
		"gold" : 300,
	},
	"On The Rocks" : {
		"which" : "enemies_killed",
		"amount" : 1000,
		"enemies" : ["rock_golem"],
		"icon" : Vector2(40,20),
		"description" : "Kill 1000 rock enemies.",
		"gold" : 400,
	},
	"History Of Beasts" : {
		"which" : "enemies_killed",
		"amount" : 1000,
		"enemies" : ["cacodemon", "basalisk", "phoenix", "archmage"],
		"icon" : Vector2(0,20),
		"description" : "Kill 10000 gods.",
		"gold" : 400,
	},
	"Fear To Fortitude" : {
		"which" : "damage_taken",
		"amount" : 1000000,
		"icon" : Vector2(30,20),
		"description" : "Take 1000000 points of damage.",
		"gold" : 600,
	},
	"Dragon Slayer" : {
		"which" : "enemies_killed",
		"amount" : 100,
		"enemies" : ["awakened_salazar"],
		"icon" : Vector2(50, 20),
		"description" : "Kill salazar in the abyss 100 times.",
		"gold" : 800,
	},
	"Job Hopper" : {
		"which" : "classes_unlocked",
		"amount" : 3,
		"classes" : ["Noble","Scholar","Nomad"],
		"icon" : Vector2(0,0),
		"description" : "Unlock the 3 base classes.",
		"gold" : 400,
	},
	"Westerly Winds" : {
		"which" : "classes_unlocked",
		"amount" : 3,
		"classes" : ["Sentinel","Ranger","Scout"],
		"icon" : Vector2(10,10),
		"description" : "Unlock the 3 Nomad secondary classes.",
		"gold" : 800,
	},
	"Starlight, Starbright" : {
		"which" : "classes_unlocked",
		"amount" : 3,
		"classes" : ["Druid","Magician","Warlock"],
		"icon" : Vector2(0,10),
		"description" : "Unlock the 3 Scholar secondary classes.",
		"gold" : 800,
	},
	"Brave Story" : {
		"which" : "classes_unlocked",
		"amount" : 3,
		"classes" : ["Knight","Paladin","Marauder"],
		"icon" : Vector2(2,10),
		"description" : "Unlock the 3 Noble secondary classes.",
		"gold" : 800,
	},
	"True Warrior" : {
		"which" : "classes_unlocked",
		"amount" : 9,
		"classes" : ["Knight","Paladin","Marauder"]+["Druid","Magician","Warlock"]+["Sentinel","Ranger","Scout"],
		"icon" : Vector2(30,10),
		"description" : "Unlock all 9 secondary classes.",
		"gold" : 1600,
	},
	"Unlock Nomad" : {
		"which" : "bow_projectiles",
		"amount" : 10,
		"icon" : Vector2(0,10),
		"description" : "Become one with the arrow.",
		"gold" : 0,
	},
	"Unlock Noble" : {
		"which" : "sword_projectiles",
		"amount" : 10,
		"icon" : Vector2(0,10),
		"description" : "Become one with the blade.",
		"gold" : 0,
	},
	"Unlock Scholar" : {
		"which" : "staff_projectiles",
		"amount" : 10,
		"icon" : Vector2(0,10),
		"description" : "Become one with the magic.",
		"gold" : 0,
	},
	"Unlock Knight" : {
		"which" : "damage_taken",
		"amount" : 20000,
		"icon" : Vector2(0,10),
		"description" : "Take some serious damage.",
		"gold" : 0,
	},
	"Unlock Paladin" : {
		"which" : "ability_used",
		"amount" : 1000,
		"icon" : Vector2(0,10),
		"description" : "Take some serious damage.",
		"gold" : 0,
	},
	"Unlock Marauder" : {
		"which" : "enemies_killed",
		"amount" : 5,
		"enemies" : ["awakened_salazar"],
		"icon" : Vector2(0,10),
		"description" : "Take some serious damage.",
		"gold" : 0,
	},
	"Unlock Ranger" : {
		"which" : "enemies_killed",
		"amount" : 20,
		"enemies" : ["oranix","vajira","raa'sloth","salazar"],
		"icon" : Vector2(0,10),
		"description" : "Take some serious damage.",
		"gold" : 0,
	},
	"Unlock Sentinel" : {
		"which" : "damage_taken",
		"amount" : 20000,
		"icon" : Vector2(0,10),
		"description" : "Take some serious damage.",
		"gold" : 0,
	},
	"Unlock Scout" : {
		"which" : "tiles_covered",
		"amount" : 100000,
		"icon" : Vector2(0,10),
		"description" : "Take some serious damage.",
		"gold" : 0,
	},
	"Unlock Magician" : {
		"which" : "ability_used",
		"amount" : 1000,
		"icon" : Vector2(0,10),
		"description" : "Take some serious damage.",
		"gold" : 0,
	},
	"Unlock Druid" : {
		"which" : "enemies_killed",
		"amount" : 200,
		"enemies" : ["rock_golem"],
		"icon" : Vector2(0,10),
		"description" : "Take some serious damage.",
		"gold" : 0,
	},
	"Unlock Warlock" : {
		"which" : "enemies_killed",
		"amount" : 15000,
		"icon" : Vector2(0,10),
		"description" : "Take some serious damage.",
		"gold" : 0,
	},
}
#The enemy kills we need to keep track of on the player
var enemies_tracked = []

var characters = {
	"Apprentice" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
			"Unlock Nomad" :  "Nomad",
			"Unlock Noble" : "Noble",
			"Unlock Scholar" : "Scholar",
		},
		"rect" : Rect2(0,0,80,40),
		"icon" : Vector2(0,210),
		"color" : Color(196.0/255, 184.0/255, 146.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
				},
				"textures" : {
				},
			}
		},
		"bonus_stats" : {
			"health" : 0,
			"attack" : 0,
			"defense" : 0,
			"speed" : 0,
			"dexterity" : 0,
			"vitality" : 0
		},
		"multipliers" : {
		},
		"description" : "The ultimate jack of all trades, the apprentice is a quick learner who can wield any weapon.",
		"ascension_stones" : 5,
	},
	"Noble" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
			"Unlock Knight" :  "Knight",
			"Unlock Paladin" : "Paladin",
			"Unlock Marauder" : "Marauder",
		},
		"rect" : Rect2(0,40,80,40),
		"icon" : Vector2(20,210),
		"color" : Color(252.0/255, 139.0/255, 14.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(95.0, 83.0, 83.0),
					"helmetLightNew" : RgbToColor(135.0, 117.0, 117.0),
					"helmetMediumNew" : RgbToColor(108.0, 99.0, 99.0),
				},
				"textures" : {
				},
			}
		},
		"bonus_stats" : {
			"health" : 200,
			"attack" : 10,
			"defense" : 20,
			"speed" : 10,
			"dexterity" : 10,
			"vitality" : 20
		},
		"multipliers" : {
			"Sword" : {"damage" : 1.2, "stats" : 1.2},
			"Armor" : {"stats" : 1.2},
			"Helmet" : {"stats" : 1.2},
		},
		"description" : "The Noble's strength and bravery dominate the battlefield.",
		"teaser" : "Discover by becoming one with the blade.",
		"ascension_stones" : 50,
	},
	"Nomad" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
			"Unlock Ranger" :  "Ranger",
			"Unlock Sentinel" : "Sentinel",
			"Unlock Scout" : "Scout",
		},
		"rect" : Rect2(80,80,80,40),
		"icon" : Vector2(10,210),
		"color" : Color(78.0/255, 166.0/255, 63.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(132.0, 100.0, 44.0),
					"helmetMediumNew" : RgbToColor(14.0, 157.0, 43.0),
					"helmetLightNew" : RgbToColor(25.0, 177.0, 55.0),
					"bandNew" : RgbToColor(47.0, 75.0, 29.0),
				},
				"textures" : {
				},
			}
		},
		"bonus_stats" : {
			"health" : 100,
			"attack" : 20,
			"defense" : 10,
			"speed" : 20,
			"dexterity" : 20,
			"vitality" : 10
		},
		"multipliers" : {
			"Bow" : {"rof" : 3, "stats" : 1.2},
			"Leather" : {"stats" : 1.2},
			"Cap" : {"stats" : 1.2},
		},
		"description" : "Swift and precise, the Nomad's arrows strike fear into distant foes.",
		"teaser" : "Discover by becoming one with the arrow.",
		"ascension_stones" : 50,
	},
	"Scholar" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
			"Unlock Magician" :  "Magician",
			"Unlock Druid" : "Druid",
			"Unlock Warlock" : "Warlock",
		},
		"rect" : Rect2(160,120,80,40),
		"icon" : Vector2(30,210),
		"color" : Color(62.0/255, 118.0/255, 255.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(36.0, 17.0, 131.0),
					"helmetMediumNew" : RgbToColor(94.0, 23.0, 150.0),
					"helmetLightNew" : RgbToColor(122.0, 39.0, 170.0),
				},
				"textures" : {
				},
			}
		},
		"bonus_stats" : {
			"health" : 100,
			"attack" : 30,
			"defense" :0,
			"speed" : 10,
			"dexterity" : 30,
			"vitality" : 10
		},
		"multipliers" : {
			"Staff" : {"damage" : 1.2, "stats" : 1.2},
			"Robe" : {"stats" : 1.2},
			"Hat" : {"stats" : 1.2},
		},
		"description" : "With powerful spells and vast intellect, the Scholar excels at long range.",
		"teaser" : "Discover by becoming one with magic.",
		"ascension_stones" : 50,
	},
	"Knight" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,160,80,40),
		"icon" : Vector2(110,210),
		"color" : Color(232.0/255, 105.0/255, 0.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(95.0, 83.0, 83.0),
					"helmetLightNew" : RgbToColor(135.0, 117.0, 117.0),
					"helmetMediumNew" : RgbToColor(108.0, 99.0, 99.0),
				},
				"textures" : {
					
				},
			}
		},
		"bonus_stats" : {
			"health" : 100,
			"attack" : 0,
			"defense" : 20,
			"speed" : -5,
			"dexterity" : 0,
			"vitality" : 10,
		},
		"multipliers" : {
			"Sword" : {"damage" : 1.4, "stats" : 1.4},
			"Armor" : {"stats" : 1.5},
			"Helmet" : {"stats" : 1.4},
		},
		"description" : "The Knight's high health and mighty armor make them an immovable force.",
		"teaser" : "Discover by enduring the trials of the battlefield.",
		"ascension_stones" : 50,
	},
	"Paladin" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,200,80,40),
		"icon" : Vector2(100,210),
		"color" : Color(252.0/255, 218.0/255, 14.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(95.0, 83.0, 83.0),
					"helmetLightNew" : RgbToColor(135.0, 117.0, 117.0),
					"helmetMediumNew" : RgbToColor(108.0, 99.0, 99.0),
				},
				"textures" : {
					
				},
			}
		},
		"bonus_stats" : {
			"health" : 150,
			"attack" : 0,
			"defense" : 10,
			"speed" : 0,
			"dexterity" : 0,
			"vitality" : 25,
		},
		"multipliers" : {
			"Sword" : {"damage" : 1.4, "stats" : 1.4},
			"Armor" : {"stats" : 1.4},
			"Helmet" : {"stats" : 1.4},
		},
		"description" : "The Paladin's high regen and health make them the ultimate tank.",
		"teaser" : "Discover by using your head.",
		"ascension_stones" : 50,
	},
	"Marauder" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,240,80,40),
		"icon" : Vector2(120,210),
		"color" : Color(252.0/255, 72.0/255, 14.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(85.0, 76.0, 73.0),
					"helmetLightNew" : RgbToColor(157.0, 153.0, 135.0),
					"helmetMediumNew" : RgbToColor(107.0, 95.0, 91.0),
				},
				"textures" : {
					
				},
			}
		},
		"bonus_stats" : {
			"health" : 50,
			"attack" : 30,
			"defense" : 5,
			"speed" : 0,
			"dexterity" : 10,
			"vitality" : 5,
		},
		"multipliers" : {
			"Sword" : {"damage" : 1.5, "stats" : 1.4},
			"Armor" : {"stats" : 1.4},
			"Helmet" : {"stats" : 1.4},
		},
		"description" : "The Marauder's sharp blade and swift blows make them a unstoppable force.",
		"teaser" : "Discover by truly conquering the abyss.",
		"ascension_stones" : 50,
	},
	"Ranger" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,280,80,40),
		"icon" : Vector2(60,210),
		"color" : Color(164.0/255, 166.0/255, 63.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(132.0, 100.0, 44.0),
					"helmetMediumNew" : RgbToColor(14.0, 157.0, 43.0),
					"helmetLightNew" : RgbToColor(25.0, 177.0, 55.0),
					"bandNew" : RgbToColor(47.0, 75.0, 29.0),
				},
				"textures" : {
					
				},
			}
		},
		"bonus_stats" : {
			"health" : 25,
			"attack" : 20,
			"defense" : 0,
			"speed" : 5,
			"dexterity" : 20,
			"vitality" : 0,
		},
		"multipliers" : {
			"Bow" : {"damage" : 1.5, "stats" : 1.4},
			"Hide" : {"stats" : 1.4},
			"Cap" : {"stats" : 1.4},
		},
		"description" : "The Ranger's extreme power and precision make them a feared marksman.",
		"teaser" : "Discover by hunting the biggest prey in the island.",
		"ascension_stones" : 50,
	},
	"Sentinel" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,320,80,40),
		"icon" : Vector2(70,210),
		"color" : Color(38.0/255, 186.0/255, 169.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					
				},
				"textures" : {
					
				},
			}
		},
		"bonus_stats" : {
			"health" : 100,
			"attack" : 10,
			"defense" : 20,
			"speed" : 10,
			"dexterity" : 10,
			"vitality" : 0,
		},
		"multipliers" : {
			"Bow" : {"damage" : 1.4, "stats" : 1.4},
			"Hide" : {"stats" : 1.4},
			"Cap" : {"stats" : 1.4},
		},
		"description" : "The Sentinel's thick hide make them a robust marksman.",
		"teaser" : "Discover by enduring the trials of the battlefield.",
		"ascension_stones" : 50,
	},
	"Scout" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,360,80,40),
		"icon" : Vector2(80,210),
		"color" : Color(41.0/255, 134.0/255, 74.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					
				},
				"textures" : {
					
				},
			}
		},
		"bonus_stats" : {
			"health" : 25,
			"attack" : 10,
			"defense" : 0,
			"speed" : 30,
			"dexterity" : 10,
			"vitality" : 0,
		},
		"multipliers" : {
			"Bow" : {"damage" : 1.4, "stats" : 1.4},
			"Hide" : {"stats" : 1.4},
			"Cap" : {"stats" : 1.4},
		},
		"description" : "The Sentinel's thick hide make them a robust marksman.",
		"teaser" : "Discover by venturing far and wide.",
		"ascension_stones" : 50,
	},
	"Magician" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,440,80,40),
		"icon" : Vector2(140,210),
		"color" : Color(62.0/255, 179.0/255, 221.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(36.0, 17.0, 131.0),
					"helmetMediumNew" : RgbToColor(94.0, 23.0, 150.0),
					"helmetLightNew" : RgbToColor(122.0, 39.0, 170.0),
				},
				"textures" : {
					
				},
			}
		},
		"bonus_stats" : {
			"health" : 100,
			"attack" : 5,
			"defense" : 0,
			"speed" : 25,
			"dexterity" : 5,
			"vitality" : 20,
		},
		"multipliers" : {
			"Staff" : {"damage" : 1.4, "stats" : 1.4},
			"Robe" : {"stats" : 1.4},
			"Hat" : {"stats" : 1.4},
		},
		"description" : "The Magician's quick thinking make for a cunning opponent.",
		"teaser" : "Discover by pulling too many rabbits out of your hat.",
		"ascension_stones" : 50,
	},
	"Druid" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,400,80,40),
		"icon" : Vector2(150,210),
		"color" : Color(62.0/255, 218.0/255, 221.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(36.0, 17.0, 131.0),
					"helmetMediumNew" : RgbToColor(94.0, 23.0, 150.0),
					"helmetLightNew" : RgbToColor(122.0, 39.0, 170.0),
				},
				"textures" : {
					
				},
			}
		},
		"bonus_stats" : {
			"health" : 200,
			"attack" : 0,
			"defense" : 10,
			"speed" : 0,
			"dexterity" : 0,
			"vitality" : 40,
		},
		"multipliers" : {
			"Staff" : {"damage" : 1.4, "stats" : 1.4},
			"Robe" : {"stats" : 1.4},
			"Hat" : {"stats" : 1.5},
		},
		"description" : "The Druid's extreme durability and regeneration can outlast anyone.",
		"teaser" : "Discover by being one with rock.",
		"ascension_stones" : 50,
	},
	"Warlock" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,480,80,40),
		"icon" : Vector2(160,210),
		"color" : Color(131.0/255, 62.0/255, 221.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
				},
				"textures" : {
					
				},
			}
		},
		"bonus_stats" : {
			"health" : 0,
			"attack" : 30,
			"defense" : 0,
			"speed" : 10,
			"dexterity" : 10,
			"vitality" : 0,
		},
		"multipliers" : {
			"Sword" : {"damage" : 1.2, "stats" : 1.2},
			"Staff" : {"damage" : 1.4, "stats" : 1.4},
			"Robe" : {"stats" : 1.4},
			"Hat" : {"stats" : 1.4},
		},
		"description" : "The Warlocks mastery of both sword and staff make them a feared mage.",
		"teaser" : "Discover by leaving no survivors.",
		"ascension_stones" : 50,
	},
}

func DegreesToVector(degrees):
	var radians = deg2rad(degrees)
	var vector = Vector2(cos(radians), sin(radians))
	return vector

func RgbToColor(r, g, b):
	r = r*1.0
	g = g*1.0
	b = b*1.0
	return Color(r/255, g/255, b/255)

func GetMultiplier(item):
	var _item = items[int(item)].duplicate(true)
	var result = {}
	
	for type in characters[current_class].multipliers.keys():
		var multipliers = characters[current_class].multipliers[type]
		if _item.type == type:
			for subject in multipliers.keys():
				result[subject] = multipliers[subject]
		
	return result

func GetItem(item, include_class_boost = false):
	if items.has(int(item)) and include_class_boost:
		var _item = items[int(item)].duplicate(true)
		for type in characters[current_class].multipliers.keys():
			var multipliers = characters[current_class].multipliers[type]
			if _item.type == type:
				for subject in multipliers.keys():
					if subject == "damage":
						var index = -1
						for projectile in _item.projectiles:
							index += 1
							_item.projectiles[index][subject][0] = floor(projectile.damage[0]*multipliers[subject])
							_item.projectiles[index][subject][1] = floor(projectile.damage[1]*multipliers[subject])
					elif subject == "stats":
						for stat in _item[subject]:
							_item[subject][stat] = floor(_item[subject][stat]*multipliers[subject])
					else:
						_item[subject] = floor(_item[subject]*multipliers[subject])
		
		return _item
	elif items.has(int(item)):
		return items[int(item)]
	else:
		return null

func GetBuilding(type):
	if buildings.has(type):
		return buildings[type]
	else:
		return null

func GetProjectile(projectile):
	if projectiles.has(projectile):
		return projectiles[projectile]
	else:
		return null

func GetCharacter(character):
	if characters.has(character):
		return characters[character]
	else:
		return null

func GetEnemy(enemy):
	if enemies.has(enemy):
		return enemies[enemy]
	else:
		return null
		
func GetAchievement(achievement):
	if achievements.has(achievement):
		return achievements[achievement]
	else:
		return null
