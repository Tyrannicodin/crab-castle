extends CanvasLayer

signal upgrade_selected(room: Room)
signal balance_changed(new_balance: float)

var available_rooms: Array[Room] = []
var damage_only: bool = false
var money: float = 0
var wave_number = 0
var scaling: Scaling = load("res://game/scaling.gd").new()
var number_of_rerolls = 0
var last_reroll_cost = 0

func roll_rooms(wave_number) -> void:
	damage_only = wave_number < 1
	number_of_rerolls = 0
	show()
	reroll_rooms()

	self.wave_number = wave_number

func reroll_rooms() -> void:
	on_balance_change(money - last_reroll_cost)
	self.balance_changed.emit(money)
	var reroll_cost = scaling.scale_reroll_price(wave_number, number_of_rerolls)
	last_reroll_cost = reroll_cost
	number_of_rerolls += 1
	var rng = RandomNumberGenerator.new()
	
	var filtered_rooms = available_rooms.duplicate()
	if damage_only == true:
		filtered_rooms = filtered_rooms.filter(func(room: Room): return room.requires_enemies_to_trigger)

	var weights = PackedFloat32Array(filtered_rooms.map(func(room: Room): return room.weight))

	$Margin/VBox/Center/VBox/Roll.text = "Reroll -%d" % reroll_cost
	$Margin/VBox/Center/VBox/Roll.disabled = money < reroll_cost

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

func on_balance_change(value: float) -> void:
	money = value

func skip() -> void:
	hide()
