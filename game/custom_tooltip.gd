extends Control

var Tooltip = preload("res://game/Tooltip.tscn")
var tooltip
var text
var tooltip_name
var sell_price: int
var scaling: Scaling = preload("res://game/scaling.gd").new()

func _ready() -> void:
	mouse_entered.connect(mouse_entered_f)
	mouse_exited.connect(mouse_exited_f)

func set_room_tooltip(wave_number: int, room: Room):
	tooltip_name = room.display_name
	text = "%s\nCooldown: %ss" % [room.description, str(room.cooldown_seconds)]
	sell_price = scaling.sell_price(wave_number, room)

func mouse_entered_f():
	if tooltip != null:
		return
	tooltip = get_tooltip_label(tooltip_name, text)
	get_tree().root.add_child(tooltip)
	tooltip.get_canvas()

func mouse_exited_f():
	if tooltip != null: tooltip.queue_free()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if tooltip != null: tooltip.queue_free()

func get_tooltip_label(n, text) -> Tooltip:
	var t: Tooltip = Tooltip.instantiate()
	t.set_description(n, text)
	if sell_price:
		t.sell_price(sell_price)
	
	var x = global_position.x - 1080 + 16
	if (x <= -955):
		x = -950
	var y = global_position.y - 1080 - 64 - 25
	t.set_position(Vector2i(x, y))

	return t
