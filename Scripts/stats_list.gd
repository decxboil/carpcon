extends VBoxContainer

@onready var stat_label_scene = preload("res://Scenes/stat_label.tscn")

var stats_dict := {"Weight": 0}
var label_dict := {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for key in stats_dict.keys():
		var new_label = stat_label_scene.instantiate()
		label_dict[key] = new_label
		self.add_child(new_label)
	update_labels()

func update_labels():
	for key in label_dict.keys():
		label_dict[key].text = key + ": " + str(stats_dict[key])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mech_builder_item_installed(a_Item):
	stats_dict["Weight"] += a_Item.weight
	update_labels()

func _on_mech_builder_item_removed(a_Item):
	stats_dict["Weight"] -= a_Item.weight
	update_labels()
