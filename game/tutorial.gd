extends CanvasLayer

var tutorial_disabled = false

func _ready() -> void:
	if tutorial_disabled: return
	$One.show()


func _on_upgrade_ui_upgrade_selected(room: Room) -> void:
	if tutorial_disabled: return
	$One.hide()
	$Two.show()


func _on_tower_room_placed(room: int) -> void:
	if tutorial_disabled: return
	$One.hide()
	$Two.hide()
	$Three.show()


func _on_game_wave_start() -> void:
	if tutorial_disabled: return
	$One.hide()
	$Two.hide()
	$Three.hide()
	tutorial_disabled = true
