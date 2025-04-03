extends Control


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/last_man_standing_level.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/options_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
