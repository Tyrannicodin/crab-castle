extends Control
class_name Tooltip

func set_description(n: String, desc: String):
	$VBoxContainer/name.text = n
	$VBoxContainer/description.text = desc
