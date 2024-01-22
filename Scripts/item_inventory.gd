extends VBoxContainer

@onready var menu_item_scene = preload("res://Scenes/part_menu_item.tscn")
@onready var internal_grid_scene =
 
var section_list := ["head", "chest", "arm", "leg"]

signal spawn_item(item_ID)

# Called when the node enters the scene tree for the first time.
func _ready():
	for 
	
	for item in DataHandler.item_data:
		var new_entry = menu_item_scene.instantiate()
		add_child(new_entry)
		new_entry.load_item(DataHandler.item_data[item])

func on_item_selected(a_Item_ID):
	emit_signal("spawn_item", a_Item_ID)

func _on_tab_bar_tab_chosen(label):
	pass
