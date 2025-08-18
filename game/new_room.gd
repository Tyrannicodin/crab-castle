extends Sprite2D

var dragging = false
var click_radius = 32 # Size of the sprite.

var original_position = self.global_position

var add_room_icon = preload("res://game/AddRoom.tscn")
var add_room_icons = []

func show_room_buildable(room: Room) -> void:
	var icon = add_room_icon.instantiate()
	$"../Tower".add_child(icon)
	icon.original_room = room
	icon.global_position = room.global_position
	add_room_icons.push_back(icon)

func place_room(room: Room) -> void:
	var old_name = room.name
	var new_room = load("res://game/rooms/Freezer.tscn").instantiate()
	room.replace_by(new_room)
	room.game = $".."
	print(new_room)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.position - self.position).length() < click_radius:
			if not dragging and event.pressed:
				dragging = true
				
				var current_rooms = $"../Tower".get_children()
				
				for child in current_rooms:
					if (child.id == 'empty'):
						show_room_buildable(child)

		if dragging and not event.pressed:
			dragging = false
						
			for icon in add_room_icons:
				var distance = sqrt((self.global_position.x - icon.global_position.x) * (self.position.x - icon.global_position.x) + (self.global_position.y - icon.global_position.y) * (self.global_position.y - icon.global_position.y))
				print(distance)
				if distance < float(click_radius):
					place_room(icon.original_room)

				$"../Tower".remove_child(icon)
						
			self.global_position = original_position

	if event is InputEventMouseMotion and dragging:
		self.position = event.position
