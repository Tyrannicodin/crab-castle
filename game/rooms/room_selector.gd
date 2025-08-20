extends Node2D

signal room_selected(index: int)

var bench = []
var child_script = load("res://game/bench_room.gd")

func add_room(room: Room) -> void:
	var but = Sprite2D.new()
	but.global_scale = room.scale / 2.5;
	but.texture = room.image
	but.set_script(child_script)
	bench.push_back(but)
	self.add_child(but)
	
	for i in range(len(bench)):
		position_on_bench(bench[i], i)

func position_on_bench(but: Sprite2D, i: int):
	but.global_position.x = self.global_position.x + (i * 80) + 32
	but.global_position.y = self.global_position.y + 32
	but.room_id = i

func remove_room(index: int) -> void:
	remove_child(bench[index])
	bench.pop_at(index)
	
	for i in range(len(bench)):
		position_on_bench(bench[i], i)
