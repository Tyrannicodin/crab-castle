@icon("res://assets/enemies/seagull.png")
extends Resource
class_name Enemy

@export var display_name: String = ""

@export_category("display")
@export var sprite: Texture2D
@export var scale: Vector2 = Vector2.ONE

@export_category("stats")
@export var underwater: bool = false
@export var max_health: int = 500
@export var speed: int = 60
@export var value: int = 1
@export var knockback_resist: float = 0.
