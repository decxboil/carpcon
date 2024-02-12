extends LineEdit

func _on_mech_builder_new_save_loaded(user_data):
	text = user_data["callsign"]

func _on_save_options_menu_new_gear_pressed():
	text = ""
