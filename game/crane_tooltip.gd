extends "res://game/custom_tooltip.gd"

var cost: int = 0

func _ready() -> void:
	tooltip_name = "Removal Service"
	text = "Drag on to the top of your Castle to remove a room. Price increases after each use."
	super._ready()

func get_tooltip_label(n, text) -> Tooltip:
	var tooltip = super.get_tooltip_label(n, text)
	tooltip.show_cost(cost)
	return tooltip
