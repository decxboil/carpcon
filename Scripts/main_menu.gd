extends VBoxContainer

func _on_gear_builder_button_button_down():
	get_tree().change_scene_to_file("res://Scenes/mech_builder.tscn")
