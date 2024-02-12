extends Button

@onready var file_dialog = $"../../../../FileDialog"

func _on_button_down():
	file_dialog.current_path = "user://"
	file_dialog.popup()
