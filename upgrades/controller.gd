extends CanvasLayer

signal upgrade_selected(room: Room)

var available_rooms: Array[Room] = []

func roll_rooms() -> void:
	var rng = RandomNumberGenerator.new()
	var weights = PackedFloat32Array(available_rooms.map(func(room: Room): return room.weight))

	var current_rooms = available_rooms.duplicate()
	var selected
	for child in $Upgrades.get_children():
		selected = rng.rand_weighted(weights)
		child.set_room(current_rooms[selected])
		weights.remove_at(selected)
		current_rooms.remove_at(selected)

func on_upgrade_selected(room: Room) -> void:
	# Maybe ID could be replaced with a resource
	upgrade_selected.emit(room)
	hide()

func on_rooms_loaded(rooms: Array[Room]):
	available_rooms = rooms
