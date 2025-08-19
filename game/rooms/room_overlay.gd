@tool
extends Node2D
class_name RoomOverlay

@export var room: Room : 
	set(value):
		room = value
		update_sprite()
var progress: float = 0

var extra_scale = Vector2(1, 1)
var time_since_fired: float = 0

var hide_progress_bar = false

func _process(delta) -> void:
	for child in get_children():
		child.hide()

	if not room:
		return

	time_since_fired += delta

	$Sprite.scale = extra_scale * room.scale
	$Sprite.rotation_degrees = room.rotation

	extra_scale = lerp(Vector2(1.2, 1.2), Vector2(1, 1), ease(10 * time_since_fired, -.5))

	$Sprite.show()
	if room.visible_arrows & 0b0001:
		$ArrowUp.show()
	if room.visible_arrows & 0b0010:
		$ArrowRight.show()
	if room.visible_arrows & 0b0100:
		$ArrowDown.show()
	if room.visible_arrows & 0b1000:
		$ArrowLeft.show()
	
	if room.visible_progress_bar and !hide_progress_bar:
		$Progress.show()
		$Progress.value = progress

func update_sprite() -> void:
	$Sprite.texture = room.image
	$Sprite.scale = room.scale

func show_progress():
	hide_progress_bar = false

func hide_progress():
	hide_progress_bar = true
