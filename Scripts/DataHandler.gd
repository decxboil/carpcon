extends Node

var item_data := {}
var item_grid_data := {}
@onready var item_data_path = "res://Data/item_data.fsh"

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
		item_data[item]["icon_path"] = "res://Assets/Item Sprites/" + item_data[item]["section"].capitalize() + " Parts/" + item_data[item]["name"] + ".png"
		if item_data[item]["tags"]:
			if item_data[item]["tags"].contains("ai core"):
				item_data[item]["icon_path"] = "res://Assets/Item Sprites/Head Parts/AI Core.png"
		item_data[item]["icon_scale"] = 1.47
		if item_data[item]["name"] == "Bulkhead":
			item_data[item]["icon_scale"] = 0.73

func create_player():
	return fisher

var fisher = {
	"name": "Natalie Leguin",
	"callsign": "Genie",
	"level": 1,
	"background": "freefisher",
	"developments": [],
	"gear_data": {
		"frame": {
			
		},
		"internals": {
			
		}
	}
}
