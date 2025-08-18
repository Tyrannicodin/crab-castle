extends Node2D


@export var damage = 50

@export var speed = 500.0
@export var max_velocity = 1.5
@export var pierce = 0
@export var stun_lock = 0.1
@export var knockback = 0
@export var gravity: bool = true
enum MovementType {Parabolic, Drop}
@export var movement_type: MovementType

var time = 0
var enemy_position: Vector2 = Vector2.ZERO
var origin: Vector2 = Vector2.ZERO
var downward_accel = 0
@onready var remaining_pierce = pierce
var disabled = false

func y_pos(ex: float, ey: float, x: float):
	var inverse_speed = (1.0 / speed)
	if gravity:
		return inverse_speed * x * x - inverse_speed * x * ex + x * ey / ex
	else:
		return x * ey / ex
	
func y_pos_dx(ex: float, ey: float, x: float):
	var inverse_speed = (1.0 / speed)
	if gravity:
		return 2 * inverse_speed * x - inverse_speed * ex + ey / ex
	else:
		return ey / ex
	
func aim(spawnpoint: Vector2, enemy: Enemy):
	origin = spawnpoint
	enemy_position = Vector2(enemy.global_position.x, enemy.global_position.y)

func _process(delta: float) -> void:
	time += delta
	
	if movement_type == MovementType.Parabolic:
		self.global_position.x = origin.x + time * speed
		self.global_position.y = y_pos(enemy_position.x - origin.x, enemy_position.y - origin.y, time * speed) + origin.y
		self.rotation = atan(y_pos_dx(enemy_position.x - origin.x, enemy_position.y - origin.y, time * speed))
	
	if movement_type == MovementType.Drop:
		self.global_position.y += downward_accel * delta
		downward_accel += 1000 * delta
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	if disabled:
		return
	var parent = area.get_parent()

	if parent is not Enemy:
		return

	var enemy: Enemy = parent

	if !enemy.is_alive():
		return

	if remaining_pierce == 0:
		self.queue_free()
		self.disable()
	else:
		remaining_pierce -= 1

	enemy.damage(damage)
	enemy.stun_lock(stun_lock)
	enemy.knockback(knockback)

func disable():
	self.visible = false
	disabled = true
