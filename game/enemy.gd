extends Node2D
class_name Enemy

@export var display_name: String
@export var speed: int
@export var max_health: int

signal on_death(e: Enemy)

@onready var health = max_health
var time = 0.0
var game: Game
var downward_accel = 0

func _process(delta: float) -> void:
	time += delta
	
	move(delta)
	display_hp()
	
	if not is_alive():
		self.global_position.y  += downward_accel
		downward_accel += 10

func is_alive() -> bool:
	return self.health > 0

func display_hp():
	$HealthBar.min_value = 0
	$HealthBar.max_value = max_health
	$HealthBar.value = health

func move(delta):
	self.position.x -= delta * speed
	self.position.y = 10 * sin(2 * time)

func damage(value: int):
	self.health -= value
	if self.health <= 0:
		self.on_death.emit(self)
		self.death_animation()

func death_animation():
	self.scale.y = -1
