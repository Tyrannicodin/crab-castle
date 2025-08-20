extends GridContainer

@export var buses: Array[StringName] = ["Master", "SFX", "Music"]

func _ready():
	var volume: float
	var bus_label: Label
	var bus_slider: HSlider
	for bus in buses:
		bus_label = Label.new()
		bus_label.text = bus + " volume"

		bus_slider = HSlider.new()
		bus_slider.min_value = 0
		bus_slider.max_value = 1
		bus_slider.step = 0.001
		bus_slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		bus_slider.size_flags_vertical = Control.SIZE_EXPAND_FILL
		bus_slider.value_changed.connect(
			func(value): update_audio_volume(AudioServer.get_bus_index(bus), value)
		)

		volume = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index(bus))
		volume = clamp(volume, 0, 1)
		bus_slider.value = volume
		add_child(bus_label)
		add_child(bus_slider)

func update_audio_volume(bus: int, volume: float) -> void:
	AudioServer.set_bus_volume_linear(bus, volume)
