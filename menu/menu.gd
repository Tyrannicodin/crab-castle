extends CanvasLayer

@onready var parent = $".."

@onready var animator: AnimationPlayer = $GameStartOverlay/GameStartAnimation
@onready var menu: VBoxContainer = $GameStartOverlay/SeaGradient/Menu
@onready var options: VBoxContainer = $GameStartOverlay/SeaGradient/Options

var in_game = false
var deep = false

func _ready():
	if parent is Game:
		in_game = true
		show()
		animator.play("wave")
		await animator.animation_finished
		menu.get_node("Resume").text = "Resume"
		menu.get_node("Quit").text = "Main menu"
		return

	animator.play_backwards("deeperer")

func _process(_delta):
	if Input.is_action_just_pressed("pause") and in_game:
		if get_tree().paused:
			get_tree().paused = false
			if deep:
				animator.play_backwards("deeper")
				await animator.animation_finished
			animator.play("wave")
			await animator.animation_finished
			return
		get_tree().paused = true
		animator.play_backwards("wave")

func resume_pressed() -> void:
	if in_game:
		get_tree().paused = false
		animator.play("wave")
		return
	get_tree().change_scene_to_file("res://game/game.tscn")

func options_pressed() -> void:
	options.show()
	deep = true
	animator.play("deeper")

func options_back_pressed() -> void:
	deep = false
	animator.play_backwards("deeper")

func quit_pressed() -> void:
	if in_game:
		options.hide()
		animator.play("deeperer")
		await animator.animation_finished
		get_tree().change_scene_to_file("res://menu/menu.tscn")
		return # Just to be safe
	get_tree().quit()
