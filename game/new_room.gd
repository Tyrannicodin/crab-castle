extends Sprite2D

var dragging = false
var click_radius = 32 # Size of the sprite.

var original_position = self.global_position

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.position - self.position).length() < click_radius:
			if not dragging and event.pressed:
				dragging = true
		if dragging and not event.pressed:
			dragging = false
			self.global_position = original_position

	if event is InputEventMouseMotion and dragging:
		self.position = event.position
