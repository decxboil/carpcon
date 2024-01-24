extends OptionButton

var save_path = "res://Data/fisher_backgrounds.json"

var background_data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	if not FileAccess.file_exists(save_path):
		printerr("file not found")
		return
	var file = FileAccess.open(save_path, FileAccess.READ)
	background_data = JSON.parse_string(file.get_as_text())
	file.close()
	
	for background in background_data:
		add_item(background.capitalize())
