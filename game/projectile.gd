extends Node2D

@export var damage = 50

@export var speed = 5
@export var fall_speed = 1
@export var gravity = 1

var vertical_speed = 0
var horizontal_speed = 0

func aim(enemy: Enemy):
	vertical_speed = speed
	horizontal_speed = speed

func _process(delta: float) -> void:
	self.global_position.x += speed
	self.global_position.y -= vertical_speed
	vertical_speed += gravity
