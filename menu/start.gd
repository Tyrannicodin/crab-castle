extends Button

func on_pressed() -> void:
    # When pressed, move to game scene. In the future,
    # this will also load the run upgrades into a global object the game scene can use
    get_tree().change_scene_to_file("res://game/game.tscn")
