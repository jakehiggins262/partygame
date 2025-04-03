extends Control

func _ready():
	# Set the slider to match the current volume level
	$MarginContainer/VBoxContainer/HSlider.value = AudioServer.get_bus_volume_db(0)

func _on_h_slider_value_changed(value: float) -> void:
	# Convert the slider value to decibels
	var db_value = linear_to_db(value)
	AudioServer.set_bus_volume_db(0, db_value)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/main_menu.tscn")
