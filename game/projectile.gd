extends Node2D

@export var damage = 50

@export var speed = 1000
@export var gravity = 2.0
@export var pierce = 0

var time = 0
var enemy_position: Vector2 = Vector2.ZERO
var origin: Vector2 = Vector2.ZERO
@onready var remaining_pierce = pierce
var disabled = false

var angle: float

func y_pos(p: Vector2, e: Vector2, x: float):
	var d = (p.y - e.y) / (p.x - e.x)
	
	# f''(x) = gravitational constant
	var y_scale = (gravity / 2.0) * (1.0 / speed)
	
	return y_scale * x * x - y_scale * x * p.x - y_scale * x * e.x + d * x + y_scale * p.x * e.x - e.x * d + e.y
	
func aim(spawnpoint: Vector2, enemy: Enemy):
	enemy_position = enemy.global_position
	origin = spawnpoint
	
	angle = (enemy_position - origin).angle()

func _process(delta: float) -> void:
	time += delta
	self.global_position.x += cos(angle) * speed * delta
	self.global_position.y += sin(angle) * speed * delta


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
