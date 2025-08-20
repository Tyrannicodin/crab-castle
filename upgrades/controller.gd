extends CanvasLayer

signal upgrade_selected(room: Room)

var available_rooms: Array[Room] = []
var damage_only: bool = false
var money: int = 0
var wave_number = 0
var scaling: Scaling = load("res://game/scaling.gd").new()

func roll_rooms(wave_number) -> void:
	damage_only = wave_number < 1
	show()
	reroll_rooms()

	self.wave_number = wave_number

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
		var room = filtered_rooms[selected].duplicate()
		room.cost = scaling.scale_shop(wave_number, room.cost)
		child.set_room(room)
		child.disabled = money < room.cost
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
