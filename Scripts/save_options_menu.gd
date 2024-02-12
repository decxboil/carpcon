extends MenuButton

@onready var file_dialog = $FileDialog
@onready var mech_builder = $"../.."
@onready var menu = get_popup()

signal new_gear_pressed
signal load_save_data(user_data)
var buttons_to_add := ["New Gear", "Save to file", "Load from file", "Screenshot"]

func _ready():
	for button_name in buttons_to_add:
		menu.add_item(button_name)
	
	menu.id_pressed.connect(_on_item_pressed)
	file_dialog.file_selected.connect(read_save_file)

func _on_item_pressed(id):
	var action = buttons_to_add[id]
	
	match (action):
		"New Gear":
			emit_signal("new_gear_pressed")
		"Save to file":
			save_current_build()
		"Load from file":
			file_dialog.popup()
		"Screenshot":
			save_screenshot()

func save_current_build():
	var filename = "user://Saves/Save-%d.fsh" % Time.get_unix_time_from_system()
	var file = FileAccess.open(filename, FileAccess.WRITE)
	
	file.store_string(mech_builder.get_user_data_string())
	
	var path
	if OS.has_feature("editor"):
		path = ProjectSettings.globalize_path("user://Saves")
	else:
		path = OS.get_user_data_dir().path_join("Saves")
	OS.shell_show_in_file_manager(path, true)

func read_save_file(a_path):
	var file = FileAccess.open(a_path, FileAccess.READ)
	var save_data = JSON.parse_string(file.get_as_text())
	file.close()
	
	emit_signal("load_save_data", save_data)

func save_screenshot():
	file_dialog.visible = false
	await get_tree().create_timer(0.1).timeout
	var image = get_viewport().get_texture().get_image()
	
	var filename = "user://Screenshots/Screenshot-%d.png" % Time.get_unix_time_from_system()
	
	image.save_png(filename)
	
	var path
	if OS.has_feature("editor"):
		path = ProjectSettings.globalize_path("user://Screenshots")
	else:
		path = OS.get_user_data_dir().path_join("Screenshots")
	OS.shell_show_in_file_manager(path, true)
