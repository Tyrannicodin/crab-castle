extends Node

var Seagull = load("res://assets/resources/enemies/seagull.tres")
var Fish = load("res://assets/resources/enemies/fish.tres")

var waves = [
	# Wave 1
	func(): return {
		"water_level": 1,	
		"enemies": [
			[Seagull]
		]
	},
	# Wave 2
	func(): return {
		"water_level": 1,
		"enemies": [
			[Seagull, Seagull, Seagull],
			[Seagull, Seagull, Seagull],
		]
	},
	# Wave 3
	func() : return {
		"water_level": 2,
		"enemies": [
			[Fish],
			range(4).map(func(_i): return Seagull),
		]
	}
]
