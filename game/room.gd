extends Node2D
class_name Room

@export var display_name: String
@export var cooldown_seconds: float
@export var requires_enemies_to_trigger: bool = true

# The weapon fires
signal trigger

var game: Game
@onready var cooldown_remaining = cooldown_seconds

func _process(delta: float) -> void:
	cooldown_remaining -= delta

	if cooldown_remaining < 0:
		if (game.has_enemies() and requires_enemies_to_trigger) or !requires_enemies_to_trigger:
			cooldown_remaining = cooldown_seconds
			trigger_weapon()
	
	if cooldown_seconds > 0 and cooldown_remaining > 0:
		$CooldownBar.value = cooldown_remaining / cooldown_seconds
	else:
		$CooldownBar.value = 0

func trigger_weapon():
	trigger.emit()
