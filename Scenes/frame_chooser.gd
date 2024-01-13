extends OptionButton

var save_path = "res://Data/frame_data.json"

var frame_data = {}
signal load_frame(frame)

# Called when the node enters the scene tree for the first time.
func _ready():
	if not FileAccess.file_exists(save_path):
		printerr("file not found")
		return
	var file = FileAccess.open(save_path, FileAccess.READ)
	frame_data = JSON.parse_string(file.get_as_text())
	file.close()
	
	for frame in frame_data:
		self.add_item(frame.capitalize())
	
	emit_signal.call_deferred("load_frame", frame_data[frame_data.keys()[0]])

func _on_item_selected(index):
	var frame_name = get_item_text(index).to_snake_case()
	emit_signal("load_frame", frame_data[frame_name])
