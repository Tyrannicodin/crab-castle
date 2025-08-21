extends CanvasLayer

@onready var textBox = $TutorialTextBox

var text = [
	"The seagulls are attacking! We have to build a castle!",
	"Drag your weapon onto the platform.",
	"Press start wave and defend!",
]

@onready var tutorial_disabled = not ConfigManager.get_value("show_tutorial", true)
var tutorial_index = 0

func next_tutorial() -> void:
	for child in get_children():
		child.hide()
	
	if tutorial_disabled:
		return

	if tutorial_index >= len(text):
		tutorial_disabled = true
		ConfigManager.set_value("show_tutorial", false)
		return

	textBox.show()
	textBox.text = text[tutorial_index]
	if get_node_or_null("Tutorial" + str(tutorial_index)):
		get_node("Tutorial" + str(tutorial_index)).show()
	tutorial_index += 1

func _ready() -> void:
	next_tutorial()

func _on_upgrade_ui_upgrade_selected(_room: Room) -> void:
	next_tutorial()

func _on_tower_room_placed(_room: int) -> void:
	next_tutorial()

func _on_game_wave_start() -> void:
	next_tutorial()
