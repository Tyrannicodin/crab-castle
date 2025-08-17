extends Node2D

@export var damage = 50

@export var speed = 500.0
@export var velocity = 1.5
@export var gravity = 2.0
@export var pierce = 0

var time = 0
var enemy_position: Vector2 = Vector2.ZERO
var origin: Vector2 = Vector2.ZERO
@onready var remaining_pierce = pierce
var disabled = false

func y_pos(ex: float, ey: float, x: float):
	var d = ey / ex
	var inverse_speed = (1.0 / speed)
	return inverse_speed * x * x - inverse_speed * x * ex + d * x - ex * d + ey
	
func y_pos_dx(ex: float, ey: float, x: float):
	var d = ey / ex
	var inverse_speed = (1.0 / speed)
	return 2 * inverse_speed * x - inverse_speed * ex + d
	
func aim(spawnpoint: Vector2, enemy: Enemy):
	origin = spawnpoint
	enemy_position = Vector2(enemy.global_position.x - enemy.speed * speed / 100.0, enemy.global_position.y)
	var velocity = y_pos_dx(enemy_position.x, enemy_position.y, 0)
	
			
func _process(delta: float) -> void:
	time += delta
				
	self.global_position.x = origin.x + time * speed
	self.global_position.y = y_pos(enemy_position.x, enemy_position.y, time * speed) + origin.y

func _on_area_2d_area_entered(area: Area2D) -> void:
	if disabled:
		return
	var parent = area.get_parent()

	if parent is not Enemy:
		return
	
	if remaining_pierce == 0:
		print("Pierce cap reached")
		self.queue_free()
		self.disable()
	else:
		remaining_pierce -= 1
	
	var enemy: Enemy = parent

	enemy.damage(damage)

func disable():
	self.visible = false
	disabled = true
