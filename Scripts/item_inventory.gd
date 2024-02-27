extends VBoxContainer

@onready var menu_item_scene = preload("res://Scenes/part_menu_item.tscn")
@onready var internals_scroll_scene = preload("res://Scenes/internals_scroll_container.tscn")
@onready var internals_grid_scene = preload("res://Scenes/internals_grid.tscn")
@onready var margin_container = $MarginContainer

@onready var mech_builder = $"../../../VBoxContainer/HBoxContainer/MechBuilder"

var section_list := {"head": null, "chest": null, "arm": null, "leg": null}

var types = ["ranged", "melee", "active", "passive", "mitigation"]

# Called when the node enters the scene tree for the first time.
func _ready():
	for part in section_list:
		var new_scroll = internals_scroll_scene.instantiate()
		var new_grid = internals_grid_scene.instantiate()
		new_scroll.add_child(new_grid)
		margin_container.add_child(new_scroll)
		new_grid.spawn_item.connect(mech_builder.on_item_inventory_spawn_item)
		section_list[part] = new_grid
	
	var item_array := []
	for item in DataHandler.item_data:
		item_array.append(DataHandler.item_data[item])
	
	item_array.sort_custom(func(a, b): return types.find(a["type"]) < types.find(b["type"]) if types.find(a["type"]) != types.find(b["type"]) else a["name"] < b["name"])
	
	for item in item_array:
		if item["section"] == "any":
			for section in section_list:
				var new_entry = menu_item_scene.instantiate()
				section_list[section].add_child(new_entry)
				new_entry.load_item(item, DataHandler.item_data.find_key(item))
		else:
			var new_entry = menu_item_scene.instantiate()
			section_list[item["section"]].add_child(new_entry)
			new_entry.load_item(item, DataHandler.item_data.find_key(item))

func _on_tab_bar_tab_chosen(label):
	change_visibility.call_deferred(label)

func change_visibility(label):
	for section in section_list:
		if !section_list[section]:
			return
		
		if section == label:
			section_list[section].get_parent().visible = true
		else:
			section_list[section].get_parent().visible = false
