@icon("res://assets/enemies/seagull.png")
extends Resource
class_name Enemy

@export var display_name: String = ""

@export_category("display")
@export var sprite: Texture2D
@export var scale: float = 1

@export_category("stats")
@export var max_health: int = 500
@export var speed: int = 60
@export var acceleration: int = 30
@export var value: int = 1
