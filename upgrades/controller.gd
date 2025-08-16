extends CanvasLayer

signal upgrade_selected(id: String)

func on_upgrade_selected(id: String) -> void:
	# Maybe ID could be replaced with a resource
	upgrade_selected.emit(id)
	print("Upgrade selected: " + id)
	hide()
