extends Label

func update_stat(game: Game) -> void:
	if game.wave_number == 1:
		text = "You beat 1 wave."
	else:
		text = "You beat %d waves." % game.wave_number
