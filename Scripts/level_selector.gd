extends SpinBox

var path = "user://LocalData/level_data.json"

var level_data = {}
signal change_level(level_data, level)

# Called when the node enters the scene tree for the first time.
func _ready():
	if not FileAccess.file_exists(path):
		printerr("file not found")
		return
	var file = FileAccess.open(path, FileAccess.READ)
	var temp_data = JSON.parse_string(file.get_as_text())
	if temp_data:
		level_data = temp_data
	else: 
		return
	file.close()

func _on_value_changed(a_Value):
	var temp_value = str(a_Value)
	emit_signal("change_level", level_data[temp_value], temp_value)

func _on_save_options_menu_new_gear_pressed():
	value = 1
	emit_signal("change_level", level_data["1"], "1")

func _on_mech_builder_new_save_loaded(a_User_data):
	value = int(a_User_data["level"])
	emit_signal("change_level", level_data[a_User_data["level"]], a_User_data["level"])
