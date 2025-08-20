extends Node

var dragging = false
var click_radius = 100
var initial_pos = self.global_position
@export var room_id = -1

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.position - self.global_position).length() < click_radius:
			initial_pos = self.global_position
			$'../'.room_selected.emit(room_id)
			if not dragging and event.pressed:
				dragging = true
		if dragging and not event.pressed:
			dragging = false
			self.global_position = initial_pos
		
	if event is InputEventMouseMotion and dragging:
		self.global_position = event.position
