extends Node

static var Seagull = preload("res://assets/resources/enemies/seagull.tres")
static var Fish = preload("res://assets/resources/enemies/fish.tres")
static var Shark = preload("res://assets/resources/enemies/shark.tres")
static var Octopus = preload("res://assets/resources/enemies/octopus.tres")


static var waves = [
	# Wave 1
	func(): return {
		"water_level": 0,	
		"enemies": [
			[Seagull]
		]
	},
	# Wave 2
	func(): return {
		"water_level": 1,
		"enemies": [
			[Seagull, Seagull, Seagull],
			[Seagull, Seagull, Seagull, Seagull, Seagull],
		]
	},
	# Wave 3
	func() : return {
		"water_level": 2,
		"enemies": [
			[Octopus],
			range(4).map(func(_i): return Seagull),
		]
	},
	# Wave 4
	func() : return {
		"water_level": 3,
		"enemies": [
			[Seagull, Seagull, Seagull, Seagull],
			[Octopus, Octopus, Octopus, Seagull],
		]
	},
	# Wave 5
	func() : return {
		"water_level": 4,
		"enemies": [
			[Seagull, Seagull, Seagull, Seagull],
			[Fish, Octopus, Octopus, Seagull, Seagull],
			[Shark]
		]
	}
]
