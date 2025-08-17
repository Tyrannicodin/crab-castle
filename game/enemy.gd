extends Sprite2D
class_name Enemy

@export var display_name: String
@export var speed: int
@export var health: int

func _process(delta: float) -> void:
	self.position.x -= delta * speed
