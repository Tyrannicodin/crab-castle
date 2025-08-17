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
var stun_lock_time_remaining = 0
var backwards_velocity = 0
var acceleration = 30

func _process(delta: float) -> void:	
	move(delta)
	display_hp()
	
	if not is_alive():
		self.global_position.y += downward_accel
		downward_accel += 50 * delta

func is_alive() -> bool:
	return self.health > 0

func display_hp():
	$HealthBar.min_value = 0
	$HealthBar.max_value = max_health
	$HealthBar.value = health

func move(delta):
	backwards_velocity -= acceleration * delta
	if backwards_velocity < 0:
		backwards_velocity = 0
	self.position.x += backwards_velocity
	if stun_lock_time_remaining >= 0:
		stun_lock_time_remaining -= delta
		return
	self.position.x -= delta * speed
	if is_alive():
		time += delta
		self.position.y = 10 * sin(2 * time)

func damage(value: int):
	self.health -= value
	if self.health <= 0:
		self.on_death.emit(self)
		self.death_animation()

func stun_lock(time: float):
	stun_lock_time_remaining = time

func knockback(power: int):
	backwards_velocity = power

func death_animation():
	self.scale.y = -1
	$HealthBar.visible = false
