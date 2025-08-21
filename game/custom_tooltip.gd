extends Control

var Tooltip = preload("res://game/Tooltip.tscn")
var tooltip
var text

func _ready() -> void:
	mouse_entered.connect(mouse_entered_f)
	mouse_exited.connect(mouse_exited_f)
	z_index = 10

func set_room_tooltip(room: Room):
	text = "%s\nCooldown: %ss" % [room.description, str(room.cooldown_seconds)]

func mouse_entered_f():
	if tooltip != null:
		return
	tooltip = get_tooltip_label(text)
	get_tree().root.add_child(tooltip)

func mouse_exited_f():
	tooltip.queue_free()

func get_tooltip_label(for_text):
	var t: Control = Tooltip.instantiate()
	t.set_description(for_text)
	t.global_position = global_position
	t.position.x = t.position.x - 1080 + (t.size.x / 2)
	t.position.y = t.position.y - t.size.y - 37
	return t
