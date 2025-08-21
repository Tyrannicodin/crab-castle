extends Control

var Tooltip = preload("res://game/Tooltip.tscn")
var tooltip
var text
var tooltip_name

func _ready() -> void:
	mouse_entered.connect(mouse_entered_f)
	mouse_exited.connect(mouse_exited_f)

func set_room_tooltip(room: Room):
	tooltip_name = room.display_name
	text = "%s\nCooldown: %ss" % [room.description, str(room.cooldown_seconds)]

func mouse_entered_f():
	if tooltip != null:
		return
	tooltip = get_tooltip_label(tooltip_name, text)
	get_tree().root.add_child(tooltip)

func mouse_exited_f():
	tooltip.queue_free()

func get_tooltip_label(n, text) -> Tooltip:
	var t: Tooltip = Tooltip.instantiate()
	t.set_description(n, text)
	t.global_position = global_position
	t.position.x = t.position.x - 1080 + (t.size.x / 2)
	t.position.y = t.position.y - t.size.y - 37
	return t
