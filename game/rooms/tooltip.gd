extends "res://game/custom_tooltip.gd"


func get_tooltip_label(n, text) -> Tooltip:
	var tooltip = super.get_tooltip_label(n, text)
	
	var y = tooltip.get_position().y - 20
	tooltip.set_position(Vector2i(tooltip.get_position().x,  y))
	return tooltip
