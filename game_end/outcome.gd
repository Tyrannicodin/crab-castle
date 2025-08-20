extends Label

func update_stat(game: Game) -> void:
    if game.in_wave:
        text = "YOU LOSE"
    else:
        text = "YOU WIN"
