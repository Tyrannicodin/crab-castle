extends Control

var nunito: FontVariation = preload("res://assets/fonts/nunito.tres")

func set_room_tooltip(room: Room):
	tooltip_text = "%s\nCooldown: %ss" % [room.description, str(room.cooldown_seconds)]

func _make_custom_tooltip(for_text):
	var label = Label.new()
	label.text = for_text
	label.add_theme_font_override("font", nunito)
	label.add_theme_font_size_override("font_size", 24)
	label.global_position = $"..".global_position
	return label
