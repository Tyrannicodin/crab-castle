extends Node2D
class_name DamageNumber

var opacity = 1
var initial_up_velocity = -20
var x_speed = randi_range(-10, 10)

func _ready() -> void:
	$Label.label_settings = $Label.label_settings.duplicate()

func set_damage_number(value: int):
	$Label.text = str(value)

func set_flavor_text(value: String):
	$Label.text = value

func _process(delta: float) -> void:
	initial_up_velocity += 100 * delta
	global_position.y += initial_up_velocity * delta
	global_position.x += x_speed * delta
	opacity -= delta

	$Label.label_settings.font_color.a = opacity
	$Label.label_settings.outline_color.a = opacity

	if opacity <= 0:
		queue_free()
