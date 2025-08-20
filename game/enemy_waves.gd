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
			[Seagull, Seagull],
			[Seagull, Seagull, Seagull, Seagull],
		]
	},
	# Wave 3
	func() : return {
		"water_level": 2,
		"enemies": [
			[Octopus],
			[Octopus, Seagull, Seagull],
		]
	},
	# Wave 4
	func() : return {
		"water_level": 3,
		"enemies": [
			[Seagull, Seagull, Seagull, Seagull],
			[Octopus, Octopus, Octopus, Octopus],
		]
	},
	# Wave 5
	func() : return {
		"water_level": 4,
		"enemies": [
			[Octopus, Octopus, Octopus, Octopus],
			[Octopus, Octopus, Octopus, Seagull, Seagull],
			[Shark]
		]
	},
	# Wave 6
	func() : return {
		"water_level": 2,
		"enemies": [
			[Fish],
			[Fish, Fish, Fish, Fish, Fish, Fish, Fish, Fish, Fish],
			[Fish, Fish, Fish, Fish, Fish, Shark]
		]
	}
]
