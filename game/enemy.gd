extends Node2D
class_name Enemy

@export var display_name: String
@export var speed: int
@export var max_health: int

@onready var health = max_health
var time = 0.0

func _process(delta: float) -> void:
	time += delta
	
	move(delta)
	display_hp()

func display_hp():
	$HealthBar.min_value = 0
	$HealthBar.max_value = health
	$HealthBar.value = health

func move(delta):
	self.position.x -= delta * speed
	self.position.y = 10 * sin(2 * time)
