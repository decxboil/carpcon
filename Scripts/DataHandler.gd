extends Node

var item_data := {}
var item_grid_data := {}
var item_data_path = "user://LocalData/item_data.json"

var gear_data_template := {
	"callsign": "",
	"frame": "",
	"internals": {},
	"background": "",
	"unlocks": [],
	"level": "1"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_data(item_data_path)
	set_grid_and_icon_data()

func load_data(a_path):
	if not FileAccess.file_exists(a_path):
		printerr("file not found")
		return
	var file = FileAccess.open(a_path, FileAccess.READ)
	item_data = JSON.parse_string(file.get_as_text())
	file.close()

func set_grid_and_icon_data():
	for item in item_data.keys():
		var temp_grid_array := []
		for point in item_data[item]["grid"]:
			temp_grid_array.push_back(point.split(","))
		item_grid_data[item] = temp_grid_array
		item_data[item]["icon_path"] = "res://Assets/Item Sprites/" + item_data[item]["name"] + ".png"
		item_data[item]["icon_scale"] = 1.47

func get_gear_template():
	return gear_data_template.duplicate()

func import_file(file):
	pass
