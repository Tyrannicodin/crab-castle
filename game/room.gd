extends Node
class_name Room

@export var display_name: String
@export var cooldown_seconds: int

# The weapon fires
signal trigger

var game: Game
@onready var cooldown_remaining = cooldown_seconds

func _process(delta: float) -> void:
	cooldown_remaining -= delta

	if cooldown_remaining < 0:
		cooldown_remaining = cooldown_seconds
		trigger_weapon()
	
	if cooldown_seconds > 0 and cooldown_remaining > 0:
		$CooldownBar.value = cooldown_remaining / cooldown_seconds
	else:
		$CooldownBar.value = 0

func trigger_weapon():
	trigger.emit()
