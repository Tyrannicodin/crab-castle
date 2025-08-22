extends Sprite2D

@onready var shader = material

var hovered = false

var click_radius = 40

func _ready() -> void:
	$Tooltip.tooltip_name = "Trash Can"
	$Tooltip.text = "Drag a tower here to sell it."

func _process(_delta: float) -> void:
	if $"../../".in_wave:
		material = shader
	else:
		material = null

	hovered = false
	var pos = get_global_mouse_position()
	if (pos - self.global_position).length() < click_radius:
		hovered = true
