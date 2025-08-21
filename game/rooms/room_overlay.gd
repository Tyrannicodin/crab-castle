@tool
extends Node2D
class_name RoomOverlay

@export var room: Room :
	set(value):
		room = value
		if room:
			$Tooltip.set_room_tooltip(wave_number, room)
			update_sprite()
var progress: float = 0
var flavor_text = preload("res://game/FlavorText.tscn")

var wave_number: int = 0
var extra_scale = Vector2(1, 1)
var time_since_fired: float = 0
var flavor_text_queue = []
var time_since_last_text = 100

var hide_progress_bar = false
var default_position = null

func _ready() -> void:
	hide_progress_bar = true
	play_sound("build")

func _process(delta) -> void:
	time_since_last_text += delta
	for child in get_children():
		if child is AudioStreamPlayer2D or child is AudioStreamPlayer: continue
		if child is Control and child is not ProgressBar: continue
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
	#if room.visible_arrows & 0b0001:
	#	$ArrowUp.show()
	#if room.visible_arrows & 0b0010:
	#	$ArrowRight.show()
	#if room.visible_arrows & 0b0100:
	#	$ArrowDown.show()
	#if room.visible_arrows & 0b1000:
	#	$ArrowLeft.show()
	
	if room.visible_progress_bar and !hide_progress_bar:
		$Progress.show()
		$Progress.value = progress
	
	if time_since_last_text > .2 and len(flavor_text_queue) >= 1:
		var text = flavor_text_queue.pop_front()
		summon_text(text)
		time_since_last_text = 0

func update_sprite() -> void:
	if room:
		$Pos/Sprite.texture = room.image
		$Pos/Sprite.scale = room.scale

func show_progress():
	hide_progress_bar = false

func hide_progress():
	hide_progress_bar = true

func create_flavor_text(text: String):
	flavor_text_queue.push_back(text)

func summon_text(text: String):
	if flavor_text == null:
		return
	var inst = flavor_text.instantiate()
	inst.set_flavor_text(text)
	get_tree().root.add_child(inst)
	inst.global_position.x = global_position.x + 80
	inst.global_position.y = global_position.y + 40 + randi_range(-20, 10)

func play_sound(sound: String):
	if sound == "buff":
		$Buff.pitch_scale = randf_range(1, 1.2)
		$Buff.play()
	if sound == "build":
		$Build.pitch_scale = randf_range(1, 1.2)
		$Build.play()
