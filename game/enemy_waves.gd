extends Node

var Seagull = load("res://assets/resources/enemies/seagull.tres")

var waves = [
	# Wave 1
	func(): return [
		[Seagull]
	],
	# Wave 2
	func(): return [
		[Seagull, Seagull, Seagull],
		[Seagull, Seagull, Seagull],
	],
]
