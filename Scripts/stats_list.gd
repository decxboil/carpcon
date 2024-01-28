extends VBoxContainer

@onready var stat_label_scene = preload("res://Scenes/stat_label.tscn")

var stats_to_display := {
	"background": "",
	"marbles": 0,
	"core_integrity": 0,
	"close": 0,
	"far": 0,
	"mental": 0,
	"power": 0,
	"evade": 0,
	"willpower": 0,
	"ap": 0,
	"speed": 0,
	"sensor": 0,
	"repair_kits": 0,
	"unlocks": 0,
	"weight_cap": 0,
	"weight": 0,
	"ballast": 0}

var base_stats := {
	"background": "",
	"marbles": 0,
	"core_integrity": 0,
	"close": 0,
	"far": 0,
	"mental": 0,
	"power": 0,
	"evade": 0,
	"speed": 0,
	"sensor": 0,
	"ap": 0,
	"weight_cap": 0,
	"weight": 0,
	"ballast": 0,
	"repair_kits": 0,
	"willpower": 0,
	"unlocks": 0}

var uppercase_stats := ["close", "far", "mental", "power", "ap"]
var spacer_locations := ["core_integrity", "power", "willpower", "repair_kits"]
var label_dict := {}

signal update_unlock_label(current, maximum)
var unlock_tally = 0

var current_background
var current_level

# Called when the node enters the scene tree for the first time.
func _ready():
	for key in stats_to_display.keys():
		var new_label = stat_label_scene.instantiate()
		label_dict[key] = new_label
		add_child(new_label)
		
		if spacer_locations.has(key):
			var blank_label = stat_label_scene.instantiate()
			add_child(blank_label)

func update_labels():
	for key in stats_to_display.keys():
		var stat_name
		if uppercase_stats.has(key):
			stat_name = key.to_upper()
		else:
			stat_name = key.capitalize()
		
		var value
		if typeof(stats_to_display[key]) == 4:
			value = str(stats_to_display[key])
		else:
			value = str(stats_to_display[key]) + " (" + str(base_stats[key]) + "+" + str(stats_to_display[key] - base_stats[key]) + ")"
		
		label_dict[key].text = stat_name + ": " + value
	
	emit_signal("update_unlock_label", unlock_tally, stats_to_display["unlocks"])

func _on_mech_builder_item_installed(a_Item):
	for stat in stats_to_display:
		if stats_to_display.has(stat) and a_Item.item_data.has(stat) and a_Item.item_data[stat] != null:
			stats_to_display[stat] += a_Item.item_data[stat]
	update_labels()

func _on_mech_builder_item_removed(a_Item):
	for stat in stats_to_display:
		if stats_to_display.has(stat) and a_Item.item_data.has(stat) and a_Item.item_data[stat] != null:
			stats_to_display[stat] -= a_Item.item_data[stat]
	update_labels()

func _on_frame_chooser_load_frame(a_Frame):
	for stat in stats_to_display:
		if stats_to_display.has(stat) and a_Frame.has(stat):
			stats_to_display[stat] = a_Frame[stat]
			base_stats[stat] = a_Frame[stat]
	unlock_tally = 0
	update_labels()

func _on_background_selector_load_background(a_Background_data):
	if current_background:
		for stat in stats_to_display:
			if stats_to_display.has(stat) and current_background.has(stat) and stat != "background":
				stats_to_display[stat] -= current_background[stat]
	
	for stat in stats_to_display:
		if stats_to_display.has(stat) and a_Background_data.has(stat) and stat != "background":
			stats_to_display[stat] += a_Background_data[stat]
			base_stats[stat] = a_Background_data[stat]
	
	stats_to_display["background"] = a_Background_data["background"]
	current_background = a_Background_data
	update_labels()

func _on_level_selector_change_level(a_Level_data):
	if current_level:
		for stat in stats_to_display:
			if stats_to_display.has(stat) and current_level.has(stat):
				stats_to_display[stat] -= current_level[stat]
	
	for stat in stats_to_display:
		if stats_to_display.has(stat) and a_Level_data.has(stat):
			stats_to_display[stat] += a_Level_data[stat]
	current_level = a_Level_data
	update_labels()

func _on_mech_builder_incrememnt_lock_tally(a_Change):
	unlock_tally += a_Change
	emit_signal("update_unlock_label", unlock_tally, stats_to_display["unlocks"])

func unlocks_remaining() -> bool:
	return unlock_tally < stats_to_display["unlocks"]
