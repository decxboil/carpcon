extends VBoxContainer

@onready var stat_label_scene = preload("res://Scenes/stat_label.tscn")

var stats_dict := {"ap": 0,
		"close": 0,
		"core": 0,
		"evade": 0,
		"far": 0,
		"power": 0,
		"repair": 0,
		"sensor": 0,
		"speed": 0,
		"weight": 0}
var label_dict := {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for key in stats_dict.keys():
		var new_label = stat_label_scene.instantiate()
		label_dict[key] = new_label
		self.add_child(new_label)

func update_labels():
	for key in stats_dict.keys():
		if key != "ap":
			label_dict[key].text = key.capitalize() + ": " + str(stats_dict[key])
		else:
			label_dict[key].text = key.to_upper() + ": " + str(stats_dict[key])

func _on_mech_builder_item_installed(a_Item):
	stats_dict["weight"] += a_Item.weight
	update_labels()

func _on_mech_builder_item_removed(a_Item):
	stats_dict["weight"] -= a_Item.weight
	update_labels()

func _on_frame_chooser_load_frame(a_Frame):
	for stat in stats_dict:
		if stat == "unlocks":
			continue
		stats_dict[stat] = a_Frame[stat]
	update_labels()
