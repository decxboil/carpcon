extends TabBar

signal tab_chosen(label)

var tab_labels := ["head", "chest", "arm", "leg"]

func _ready():
	for label in tab_labels:
		add_tab(label.capitalize())

func _on_tab_changed(tab):
	emit_signal("tab_chosen", tab_labels[tab])
