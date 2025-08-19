@tool
extends HBoxContainer

@export var stat_name: String = "" : 
	set(value):
		$Label.text = value
		stat_name = value
@export var property: StringName = ""

func update_stat(game: Game) -> void:
	$Aspect/Panel/Margin/Label.text = str(game.get(property))
