extends CenterContainer

@export var property: StringName = ""

func update_stat(game: Game) -> void:
	var prop = game.get(property)
	if prop is float:
		prop = snappedf(prop, 0.01)
	$Panel/Margin/Label.text = str(prop)
