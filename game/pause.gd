extends CanvasLayer

@onready var animator: AnimationPlayer = $GameStartOverlay/GameStartAnimation

var deep = false

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			get_tree().paused = false
			if deep:
				animator.play_backwards("deeper")
				await animator.animation_finished
			animator.play("wave")
			await animator.animation_finished
			$GameStartOverlay/SeaGradient/Menu.hide()
			return
		get_tree().paused = true
		$GameStartOverlay/SeaGradient/Menu.show()
		animator.play_backwards("wave")

func resume_pressed() -> void:
	get_tree().paused = false
	animator.play("wave")

func options_pressed() -> void:
	deep = true
	animator.play("deeper")

func options_back_pressed() -> void:
	deep = false
	animator.play_backwards("deeper")
