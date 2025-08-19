extends CanvasLayer

signal upgrade_selected(room: Room)

var available_rooms: Array[Room] = []
var damage_only: bool = false
var money: int = 0

func roll_rooms(set_damage_only = false) -> void:
	damage_only = set_damage_only
	show()
	reroll_rooms()

func reroll_rooms() -> void:
	var rng = RandomNumberGenerator.new()
	
	var filtered_rooms = available_rooms
	if damage_only == true:
		filtered_rooms = filtered_rooms.filter(func(room: Room): return room.requires_enemies_to_trigger)
	
	var weights = PackedFloat32Array(filtered_rooms.map(func(room: Room): return room.weight))

	$Margin/VBox/Center/VBox/Roll.disabled = money < 5

	var selected
	for child in $Margin/VBox/Upgrades.get_children():
		selected = rng.rand_weighted(weights)
		child.set_room(filtered_rooms[selected])
		child.disabled = money < filtered_rooms[selected].cost
		weights.remove_at(selected)
		filtered_rooms.remove_at(selected)

func on_upgrade_selected(room: Room) -> void:
	# Maybe ID could be replaced with a resource
	upgrade_selected.emit(room)
	hide()

func on_rooms_loaded(rooms: Array[Room]):
	available_rooms = rooms

func on_balance_change(value: int) -> void:
	money = value

func skip() -> void:
	hide()
