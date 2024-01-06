extends Node

var item_data := {}
var item_grid_data := {}
@onready var item_data_path = "res://Data/Carp_Con Item Data.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_data(item_data_path)
	set_grid_data()

func load_data(a_path):
	if not FileAccess.file_exists(a_path):
		printerr("file not found")
		return
	var file = FileAccess.open(a_path, FileAccess.READ)
	item_data = JSON.parse_string(file.get_as_text())
	file.close()
	print(item_data)

func set_grid_data():
	for item in item_data.keys():
		var temp_grid_array := []
		for point in item_data[item]["Grid"].split("/"):
			temp_grid_array.push_back(point.split(","))
		item_grid_data[item] = temp_grid_array
	print(item_grid_data)

func _process(delta):
	pass

var fisher = {
	"name": "Natalie Leguin",
	"callsign": "Genie",
	"level": 1,
	"background": "freefisher",
	"talents": {
		"talent_name": 1,
	},
	"mech_data": {
		"frame": {
			"name": "Rhombus",
			"weight_cap": 12,
			"close": 5,
			"far": 5,
			"evade": 11,
			"speed": 3,
			"sensors": 3,
			
		},
		"internals": {
			
		}
	}
	# "unlocks" : add unlock schema I guess
}
