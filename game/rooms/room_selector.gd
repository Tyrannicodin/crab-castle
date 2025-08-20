extends Node2D

signal room_selected(index: int)

var bench = []
var child_script = load("res://game/bench_room.gd")

func add_room(room: Room) -> void:
	var but = Sprite2D.new()
	but.global_scale = Vector2(0.3,0.3);
	but.texture = room.image
	but.set_script(child_script)
	bench.push_back(but)
	self.add_child(but)
	
	but.global_position.x = self.global_position.x
	but.global_position.y = self.global_position.y
	but.room_id = len(bench) - 1

func remove_room(index: int) -> void:
	remove_child(bench[index])
	bench.pop_at(index)
