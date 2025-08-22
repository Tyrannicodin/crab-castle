extends CanvasLayer

@onready var parent = $".."

@onready var animator: AnimationPlayer = $GameStartOverlay/GameStartAnimation
@onready var menu: VBoxContainer = $GameStartOverlay/SeaGradient/Menu
@onready var options: VBoxContainer = $GameStartOverlay/SeaGradient/Options

var in_game = false
var deep = false
var buttons_disabled = true

func _ready():
	if parent is Game:
		in_game = true
		show()
		animator.play("wave")
		await animator.animation_finished
		buttons_disabled = false
		menu.get_node("Resume").text = "Resume"
		menu.get_node("Quit").text = "Main menu"
		return

	animator.play_backwards("deeperer")
	await  animator.animation_finished
	buttons_disabled = false

func _process(_delta):
	if Input.is_action_just_pressed("pause") and in_game:
		if get_tree().paused:
			if deep:
				animator.play_backwards("deeper")
				await animator.animation_finished
			animator.play("wave")
			await animator.animation_finished
			get_tree().paused = false
			return
		animator.play_backwards("wave")
		get_tree().paused = true

func resume_pressed() -> void:
	if buttons_disabled:
		return
	if in_game:
		get_tree().paused = false
		animator.play("wave")
		return
	get_tree().change_scene_to_file("res://game/game.tscn")

func options_pressed() -> void:
	if buttons_disabled:
		return
	deep = true
	options.show()
	animator.play("deeper")
	await animator.animation_finished
	menu.hide()

func options_back_pressed() -> void:
	if buttons_disabled:
		return
	deep = false
	menu.show()
	animator.play_backwards("deeper")
	await animator.animation_finished
	options.hide()

func quit_pressed() -> void:
	if buttons_disabled:
		return
	if in_game:
		options.hide()
		buttons_disabled = true
		animator.play("deeperer")
		await animator.animation_finished
		get_tree().paused = false
		get_tree().change_scene_to_file("res://menu/menu.tscn")
		return # Just to be safe
	get_tree().quit()
