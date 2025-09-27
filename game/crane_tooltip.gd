extends "res://game/custom_tooltip.gd"

var cost: int = 0

func _ready() -> void:
	tooltip_name = "Removal Service"
	text = "Drag this onto your Castle to place a room back onto your bench."
	super._ready()

func get_tooltip_label(n, text) -> Tooltip:
	var tooltip = super.get_tooltip_label(n, text)
	var y = tooltip.get_position().y - 30
	tooltip.set_position(Vector2i(tooltip.get_position().x,  y))
	return tooltip
