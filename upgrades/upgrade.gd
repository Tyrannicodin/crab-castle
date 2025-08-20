extends Button

signal room_selected(chosen_room: Room)

var room: Room

func set_room(new_room: Room) -> void:
	room = new_room
	$Margin/VBox/RoomName.text = new_room.display_name
	$Margin/VBox/Image.texture = new_room.image
	$Margin/VBox/Description.text = new_room.description
	$Margin/VBox/Cooldown.text = "Cooldown: " + str(new_room.cooldown_seconds) + "s"

func _on_pressed() -> void:
	room_selected.emit(room)
