extends Node2D

@export var damage = 50

@export var speed = 100.0
@export var gravity = 2.0

var time = 0
var enemy_position: Vector2i = Vector2.ZERO
var origin: Vector2i = Vector2.ZERO

func y_pos(px: float, py: float, ex: float, ey: float, x: float):
	var d = (py - ey) / (px - ex)
	
	# f''(x) = gravitational constant
	var y_scale = (gravity / 2.0) * (1.0 / speed)
	
	return y_scale * x * x - y_scale * x * px - y_scale * x * ex + d * x + y_scale * px * ex - ex * d + ey
	
func aim(room: Room, enemy: Enemy):
	enemy_position = enemy.global_position
	origin = room.to_global(room.position)

func _process(delta: float) -> void:
	time += delta
		
	self.global_position.x = time * speed
	self.global_position.y = y_pos(origin_x, origin_y, enemy_position_x, enemy_position_y, time * speed)
