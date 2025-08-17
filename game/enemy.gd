extends Sprite2D
class_name Enemy

@export var display_name: String
@export var speed: int
@export var health: int

var time = 0.0

func _process(delta: float) -> void:
	time += delta
	self.position.x -= delta * speed
	self.position.y = 10 * sin(2 * time)
