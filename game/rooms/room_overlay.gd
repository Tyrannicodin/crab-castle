@tool
extends Node2D
class_name RoomOverlay

@export var room: Room : 
	set(value):
		room = value
		if room:
			update_sprite()
var progress: float = 0

var extra_scale = Vector2(1, 1)
var time_since_fired: float = 0

var hide_progress_bar = false
var default_position = null

func _ready() -> void:
	hide_progress_bar = true

func _process(delta) -> void:
	for child in get_children():
		child.hide()

	$Pos.visible = true
	$Pos/Sprite.visible = true
	update_sprite()

	if not room:
		return

	time_since_fired += delta
	
	$Pos/Sprite.scale = extra_scale * room.scale
	$Pos/Sprite.rotation_degrees = room.rotation
	if default_position == null:
		default_position = $Pos/Sprite.position
	$Pos/Sprite.position = room.translation

	extra_scale = lerp(Vector2(1.2, 1.2), Vector2(1, 1), ease(10 * time_since_fired, -.5))

	$Pos/Sprite.show()
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
	if room:
		$Pos/Sprite.texture = room.image
		$Pos/Sprite.scale = room.scale

func show_progress():
	hide_progress_bar = false

func hide_progress():
	hide_progress_bar = true
