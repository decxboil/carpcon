extends SpinBox

@onready var path = "res://Data/level_data.json"

var level_data = {}
signal change_level(data)

# Called when the node enters the scene tree for the first time.
func _ready():
	if not FileAccess.file_exists(path):
		printerr("file not found")
		return
	var file = FileAccess.open(path, FileAccess.READ)
	level_data = JSON.parse_string(file.get_as_text())
	file.close()

func _on_value_changed(value):
	value = str(value)
	emit_signal("change_level", level_data[value])
