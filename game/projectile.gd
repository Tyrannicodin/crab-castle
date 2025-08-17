extends Node2D

@export var damage = 50

@export var speed = 500.0

var time = 0
var enemy_position: Vector2i = Vector2.ZERO
var origin: Vector2i = Vector2.ZERO

func y_pos(px: float, py: float, ex: float, ey: float, x: float):
	var d = (py - ey) / (px - ex)
	var inverse_speed = (-1.0 / speed)
	return -inverse_speed * x * x + inverse_speed * x * px + inverse_speed * x * ex + d * x - inverse_speed * px * ex - ex * d + ey
	
func aim(room: Room, enemy: Enemy):
	enemy_position = enemy.global_position
	origin = room.to_global(room.position)

func _process(delta: float) -> void:
	time += delta
		
	self.global_position.x = time * speed
	self.global_position.y = y_pos(origin.x, origin.y, enemy_position.x, enemy_position.y, time * speed)

	var string = "x: %s, y: %s"
	var formatted_string = string % [self.global_position.x, self.global_position.y]
	#print(formatted_string)
