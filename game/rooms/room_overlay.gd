extends Node2D
class_name RoomOverlay

var room: Room
var progress: float = 0

func _process(_delta) -> void:
	for child in get_children():
		child.hide()
	
	if not room:
		return

	$Sprite.show()
	if room.visible_arrows & 0b0001:
		$ArrowUp.show()
	if room.visible_arrows & 0b0010:
		$ArrowRight.show()
	if room.visible_arrows & 0b0100:
		$ArrowDown.show()
	if room.visible_arrows & 0b1000:
		$ArrowLeft.show()
	
	if room.visible_progress_bar:
		$Progress.show()
		$Progress.value = progress

func update_sprite() -> void:
	$Sprite.texture = room.image
	$Sprite.scale = room.scale
