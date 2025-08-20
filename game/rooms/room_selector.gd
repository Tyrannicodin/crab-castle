extends HBoxContainer

signal room_selected(index: int)

var bench = []

func add_room(room: Room) -> void:
	var but = TextureButton.new()
	but.texture_normal = room.image
	but.ignore_texture_size = true
	but.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	but.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	but.global_position.x = 0;
	bench.push_back(but)
	but.connect(
		"pressed",
		func(): room_selected.emit(get_children().find(but))
	)
	add_child(but)

func remove_room(index: int) -> void:
	remove_child(bench[index])
	bench.pop_at(index)
