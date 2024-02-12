extends OptionButton

var save_path = "user://LocalData/frame_data.json"

var frame_data = {}
signal load_frame(frame_data, frame_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	if not FileAccess.file_exists(save_path):
		printerr("file not found")
		return
	var file = FileAccess.open(save_path, FileAccess.READ)
	var temp_data = JSON.parse_string(file.get_as_text())
	if temp_data:
		frame_data = temp_data
	else: 
		return
	file.close()
	
	for frame in frame_data:
		add_item(frame.capitalize())
	
	emit_signal.call_deferred("load_frame", frame_data[frame_data.keys()[0]], frame_data.keys()[0])

func _on_item_selected(index):
	var frame_name = get_item_text(index).to_snake_case()
	emit_signal("load_frame", frame_data[frame_name], frame_name)

func _on_mech_builder_new_save_loaded(a_User_data):
	select(frame_data.keys().find(a_User_data["frame"]))
	emit_signal("load_frame", frame_data[a_User_data["frame"]], a_User_data["frame"])
