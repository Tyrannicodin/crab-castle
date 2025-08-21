extends CanvasLayer

@onready var textBox = $TutorialTextBox

var text = [
	"The seagulls are attacking! We have to build a castle!",
	"Drag your weapon onto the platform.",
	"Press start wave and defend!",
]

var tutorial_disabled = false
var tutorial_index = 0

func next_tutorial() -> void:
	for child in get_children():
		child.hide()
	
	if tutorial_index >= len(text):
		tutorial_disabled = true
		return

	textBox.show()
	textBox.text = text[tutorial_index]
	if get_node("Tutorial" + str(tutorial_index)):
		get_node("Tutorial" + str(tutorial_index)).show()
	tutorial_index += 1

func _ready() -> void:
	if tutorial_disabled: return
	next_tutorial()

func _on_upgrade_ui_upgrade_selected(_room: Room) -> void:
	if tutorial_disabled: return
	next_tutorial()

func _on_tower_room_placed(_room: int) -> void:
	if tutorial_disabled: return
	next_tutorial()

func _on_game_wave_start() -> void:
	if tutorial_disabled: return
	next_tutorial()
