extends Node2D

@export var damage = 50

@export var speed = 500.0

var vertical_speed = 0
var horizontal_speed = 0
var time = 0
var enemy_position_x = 0
var enemy_position_y = 0
var origin_x = 0
var origin_y = 0

func y_pos(px: float, py: float, ex: float, ey: float, x: float):
	var d = (py - ey) / (px - ex)
	var inverse_speed = (-1.0 / speed)
	return -inverse_speed * x * x + inverse_speed * x * px + inverse_speed * x * ex + d * x - inverse_speed * px * ex - ex * d + ey
	
func aim(enemy: Enemy):
	enemy_position_x = 400
	enemy_position_y = 300
	origin_x = 0
	origin_y = 300
	
	self.global_position.x
	self.global_position.y

func _process(delta: float) -> void:
	time += delta
		
	self.global_position.x = time * speed
	self.global_position.y = y_pos(origin_x, origin_y, enemy_position_x, enemy_position_y, time * speed)

	var string = "x: %s, y: %s"
	var formatted_string = string % [self.global_position.x, self.global_position.y]
	print(formatted_string)
