extends FileDialog

@onready var data_dir = "res://Data"
@onready var local_data_dir = "user://LocalData"

@onready var error_dialog = $ErrorDialog
@onready var success_dialog = $SuccessDialog

func _on_file_selected(a_path):
	var diraccess = DirAccess.open(data_dir)
	var zipreader = ZIPReader.new()
	
	var err = zipreader.open(a_path)
	var files_to_import = zipreader.get_files()
	
	diraccess.list_dir_begin()
	var file_name = diraccess.get_next()
	
	while file_name != "":
		if diraccess.current_is_dir():
			continue
		
		if file_name in files_to_import:
			var data = zipreader.read_file(file_name).get_string_from_utf8()
			var file = FileAccess.open(local_data_dir.path_join(file_name), FileAccess.WRITE)
			file.store_string(data)
			file.close()
		
		file_name = diraccess.get_next()
	
	DataHandler.reload_items()
	success_dialog.popup()
