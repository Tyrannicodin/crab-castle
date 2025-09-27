extends Node2D

signal room_selected(index: int)
signal sell(room: int, value: int)

var bench = []
var child_script = load("res://game/bench_room.gd")
var BenchedRoom = load("res://game/BenchedRoom.tscn")
var scaling: Scaling = load("res://game/scaling.gd").new()
var dragging_room = false
var dragging_crane = false

var max_bench_size = 6

func _process(_delta: float) -> void:
	dragging_room = false
	dragging_crane = false
	for b in bench:
		if b.dragging:
			dragging_room = true
			break
	if is_full():
		$"../Bench/Crane".disabled = true
	else:
		$"../Bench/Crane".disabled = false
	if $"../Bench/Crane".dragging:
		dragging_crane = true

func add_room(room: Room) -> void:
	if is_full():
		# This is really bad...
		return
	
	var but: Node2D = BenchedRoom.instantiate()
	var image: Node2D = but.get_child(0)
	image.texture = room.image
	image.scale = room.scale / 2.5;
	but.instance = Tower.RoomInstance.new(room, Vector2i(-1,-1))
	bench.push_back(but)
	self.add_child(but)

	for i in range(len(bench)):
		position_on_bench(bench[i], i)

func position_on_bench(but: Node2D, i: int):
	but.global_position.x = self.global_position.x + (i * 112) + 32
	but.global_position.y = self.global_position.y + 32
	but.room_id = i

func is_full():
	return len(bench) >= max_bench_size

func remove_room(index: int) -> void:
	remove_child(bench[index])
	bench.pop_at(index)
	
	for i in range(len(bench)):
		position_on_bench(bench[i], i)

func _on_tower_sell(room: int) -> void:
	var room_data = bench[room]
	var sell_price = scaling.sell_price($"../..".wave_number, room_data.room)
	remove_room(room)
	sell.emit(room, sell_price)
