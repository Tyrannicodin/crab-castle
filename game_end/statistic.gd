@tool
extends HBoxContainer

@export var stat_name: String = "" : 
	set(value):
		$Label.text = value
		stat_name = value
@export var property: StringName = ""

func update_stat(game: Game) -> void:
	var prop = game.get(property)
	if prop is float:
		prop = snappedf(prop, 0.01)
	$Aspect/Panel/Margin/Label.text = str(prop)
