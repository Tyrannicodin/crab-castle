extends Sprite2D

var hovered = false

var click_radius = 40

func _ready() -> void:
	$Tooltip.tooltip_name = "Trash Can"
	$Tooltip.text = "Drag a tower to sell."

func _process(delta: float) -> void:
	hovered = false
	var pos = get_global_mouse_position()
	if (pos - self.global_position).length() < click_radius:
		hovered = true
