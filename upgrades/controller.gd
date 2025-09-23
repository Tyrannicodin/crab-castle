extends CanvasLayer

signal upgrade_selected(room: Room)
signal balance_changed(new_balance: float)

var available_rooms: Array[Room] = []
var money: float = 0
var wave_number = 0
var scaling: Scaling = load("res://game/scaling.gd").new()
var number_of_rerolls = 0
var last_reroll_cost = 0
var free_rerolls = 0

func roll_rooms(new_wave_number) -> void:
	number_of_rerolls = 0
	wave_number = new_wave_number
	show()
	reroll_rooms()
	$"../UI/Start Next Wave".disabled = true

func reroll_rooms() -> void:
	$Margin/VBox/Center/VBox/Roll.show()
	$Margin/VBox/Center/VBox/Skip.show()
	if number_of_rerolls != 0:
		on_balance_change(money - last_reroll_cost)
	self.balance_changed.emit(money)
	var reroll_cost = scaling.scale_reroll_price(wave_number, number_of_rerolls)
	last_reroll_cost = reroll_cost
	number_of_rerolls += 1

	if free_rerolls >= 1:
		free_rerolls -= 1
		number_of_rerolls -= 1
		last_reroll_cost = 0
		reroll_cost = 0
	
	var rng = RandomNumberGenerator.new()
	
	var filtered_rooms = available_rooms.duplicate()
	
	# We force the player to pick a simple weapon on the first wave
	if wave_number < 1:
		$Margin/VBox/Center/VBox/Roll.hide()
		$Margin/VBox/Center/VBox/Skip.hide()
		filtered_rooms = filtered_rooms.filter(func(room: Room): return room.display_name in ["Slingshot", "Bow", "Crab Cannon"])

	var weights = PackedFloat32Array(filtered_rooms.map(func(room: Room): return room.weight))

	$Margin/VBox/Center/VBox/Roll.text = "Reroll -%d" % reroll_cost
	$Margin/VBox/Center/VBox/Roll.disabled = money < reroll_cost

	var selected
	for child in $Margin/VBox/Upgrades.get_children():
		selected = rng.rand_weighted(weights)
		var room = filtered_rooms[selected].duplicate()
		room.cost = scaling.scale_shop(wave_number, room.cost)
		child.set_room(room)
		weights.remove_at(selected)
		filtered_rooms.remove_at(selected)

func on_upgrade_selected(room: Room) -> void:
	# Maybe ID could be replaced with a resource
	if money >= room.cost:
		upgrade_selected.emit(room)
		on_balance_change(money - room.cost)
		self.balance_changed.emit(money)
		on_close()

func on_rooms_loaded(rooms: Array[Room]):
	available_rooms = rooms

func on_balance_change(value: float) -> void:
	money = value

func skip() -> void:
	on_close()

func on_close():
	$"../UI/Start Next Wave".disabled = false
	free_rerolls = 0
	hide()
