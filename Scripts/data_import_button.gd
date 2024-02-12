extends Button

@onready var file_dialog = $"../../../../FileDialog"

func _on_button_down():
	file_dialog.visible = true
