extends Node

@onready var data_dir = "res://Data"

var dirs_to_check := ["user://LocalData", "user://Saves", "user://Screenshots"]

# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = DirAccess.open(data_dir)
	for directory in dirs_to_check:
		if !DirAccess.dir_exists_absolute(directory):
			DirAccess.make_dir_recursive_absolute(directory)
	
	if not DirAccess.get_files_at("user://LocalData").is_empty():
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			continue
		var file = FileAccess.open("user://LocalData".path_join(file_name), FileAccess.WRITE)
		var data = FileAccess.open(data_dir.path_join(file_name), FileAccess.READ).get_as_text()
		file.store_string(data)
		file.close()
		file_name = dir.get_next()
