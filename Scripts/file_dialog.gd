extends FileDialog

func _on_file_selected(path):
	if path.get_extension() != "fsh":
		print("failed")
		return
	var file = FileAccess.open(path, FileAccess.READ)
