extends OptionButton

var save_path = "user://LocalData/fisher_backgrounds.json"

var background_data := {}
signal load_background(background_data)

# Called when the node enters the scene tree for the first time.
func _ready():
	if not FileAccess.file_exists(save_path):
		printerr("file not found")
		return
	var file = FileAccess.open(save_path, FileAccess.READ)
	var temp_data = JSON.parse_string(file.get_as_text())
	if temp_data:
		background_data = temp_data
	else: 
		return
	file.close()
	
	for background in background_data:
		add_item(background_data[background]["background"])
	
	emit_signal.call_deferred("load_background", background_data[background_data.keys()[0]])

func _on_item_selected(index):
	var background_name = get_item_text(index).to_snake_case()
	emit_signal("load_background", background_data[background_name])

func _on_mech_builder_new_save_loaded(a_User_data):
	select(background_data.keys().find(a_User_data["background"]))
	emit_signal("load_background", background_data[a_User_data["background"]])
