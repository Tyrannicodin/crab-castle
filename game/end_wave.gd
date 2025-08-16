extends Button

func on_pressed() -> void:
    # End the round and show upgrade select screen
    $"../UpgradeUi".show()
