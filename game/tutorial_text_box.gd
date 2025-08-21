@tool
extends Node2D

@export_multiline var text: String = ""

func _process(_delta):
	$PanelContainer/Label.text = text
