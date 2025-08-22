extends Button

func on_pressed() -> void:
    get_tree().paused = false
    get_tree().change_scene_to_file("res://menu/menu.tscn")
