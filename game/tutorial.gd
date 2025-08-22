extends CanvasLayer

var tutorial_disabled = not ConfigManager.get_value("show_tutorial", true)

func _ready() -> void:
	ConfigManager.on_value_set.connect(on_value_set)
	if tutorial_disabled: return
	$One.show()

func on_value_set(param: String, value: Variant) -> void:
	if param == "show_tutorial":
		tutorial_disabled = not value

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
	ConfigManager.set_value("show_tutorial", false)
