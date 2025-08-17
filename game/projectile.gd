extends Node2D

@export var damage = 50

@export var speed = 10
@export var gravity = 2.0

var time = 0
var enemy_position: Vector2 = Vector2.ZERO
var origin: Vector2 = Vector2.ZERO

func y_pos(p: Vector2, e: Vector2, x: float):
	var d = (p.y - e.y) / (p.x - e.x)
	
	# f''(x) = gravitational constant
	var y_scale = (gravity / 2.0) * (1.0 / speed)
	
	return y_scale * x * x - y_scale * x * p.x - y_scale * x * e.x + d * x + y_scale * p.x * e.x - e.x * d + e.y
	
func aim(spawnpoint: Vector2, enemy: Enemy):
	enemy_position = enemy.global_position
	origin = spawnpoint

func _process(delta: float) -> void:
	time += delta
		
	self.global_position.x = time * speed + origin.x
	self.global_position.y = y_pos(origin, enemy_position, time * speed)
