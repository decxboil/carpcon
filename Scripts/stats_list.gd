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
	"willpower": 0,
	"ap": 0,
	"speed": 0,
	"sensor": 0,
	"repair_kits": 0,
	"unlocks": 0,
	"default_unlocks": [],
	"weight_cap": 0,
	"weight": 0,
	"ballast": 0}

var uppercase_stats := ["close", "far", "mental", "power", "ap"]
var spacer_locations := ["core_integrity", "power", "willpower", "repair_kits"]
var label_dict := {}

signal update_unlock_label(current, maximum)
var unlock_tally = 0

var cringe_ballast_tracker = 0

var current_background
var current_level

var ignoring_weight_cap = false
var ignoring_unlock_cap = false

@onready var weight_label_shaker = $WeightLabelShaker

# Called when the node enters the scene tree for the first time.
func _ready():
	for key in stats_to_display.keys():
		var new_label = stat_label_scene.instantiate()
		label_dict[key] = new_label
		add_child(new_label)
		
		if spacer_locations.has(key):
			var blank_label = stat_label_scene.instantiate()
			add_child(blank_label)
	
	weight_label_shaker.target_label = label_dict["weight"] # magic constants, yippee

func update_labels():
	stats_to_display["ballast"] = int(base_stats["ballast"] + cringe_ballast_tracker + stats_to_display["weight"]/5)
	
	for key in stats_to_display.keys():
		var stat_name
		if uppercase_stats.has(key):
			stat_name = key.to_upper()
		else:
			stat_name = key.capitalize()
		
		var temp_value
		if typeof(stats_to_display[key]) == 4 or key == "weight":
			temp_value = str(stats_to_display[key])
		else:
			temp_value = str(stats_to_display[key]) + " (" + str(base_stats[key]) + "+" + str(stats_to_display[key] - base_stats[key]) + ")"
		
		label_dict[key].text = stat_name + ": " + temp_value
	
	emit_signal("update_unlock_label", unlock_tally, stats_to_display["unlocks"])

func _on_mech_builder_item_installed(a_Item):
	for stat in stats_to_display:
		if stats_to_display.has(stat) and a_Item.item_data.has(stat) and a_Item.item_data[stat] != null:
			stats_to_display[stat] += a_Item.item_data[stat]
	cringe_ballast_tracker += a_Item.item_data["ballast"]
	update_labels()

func _on_mech_builder_item_removed(a_Item):
	for stat in stats_to_display:
		if stats_to_display.has(stat) and a_Item.item_data.has(stat) and a_Item.item_data[stat] != null:
			stats_to_display[stat] -= a_Item.item_data[stat]
	cringe_ballast_tracker -= a_Item.item_data["ballast"]
	update_labels()

func _on_frame_selector_load_frame(a_Frame_data, _a_Frame_name):
	for stat in base_stats:
		if a_Frame_data.has(stat):
			if stats_to_display.has(stat):
				stats_to_display[stat] = a_Frame_data[stat] + (stats_to_display[stat] - base_stats[stat])
			base_stats[stat] = a_Frame_data[stat]
	
	unlock_tally = 0
	update_labels()

func _on_background_selector_load_background(a_Background_data):
	if current_background:
		for stat in stats_to_display:
			if stats_to_display.has(stat) and current_background.has(stat) and stat != "background":
				stats_to_display[stat] -= current_background[stat]
	
	for stat in base_stats:
		if a_Background_data.has(stat):
			if stats_to_display.has(stat) and stat != "background":
				stats_to_display[stat] += a_Background_data[stat]
			base_stats[stat] = a_Background_data[stat]
	
	stats_to_display["background"] = a_Background_data["background"]
	current_background = a_Background_data
	update_labels()

func _on_level_selector_change_level(a_Level_data, _a_Level):
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
	return unlock_tally < stats_to_display["unlocks"] or ignoring_unlock_cap

func _on_mech_builder_reset_lock_tally():
	unlock_tally = 0
	emit_signal("update_unlock_label", unlock_tally, stats_to_display["unlocks"])

func is_under_weight_limit(a_Item_weight):
	var under_limit = a_Item_weight + stats_to_display["weight"] <= stats_to_display["weight_cap"]
	return under_limit or ignoring_weight_cap

func update_weight_label_effect(a_Item_weight):
	if (a_Item_weight == null) or is_under_weight_limit(a_Item_weight):
		weight_label_shaker.stop_shaking()
	else:
		weight_label_shaker.start_shaking()

func _on_weight_cap_check_button_toggled(button_pressed):
	ignoring_weight_cap = button_pressed

func _on_unlocks_check_button_toggled(button_pressed):
	ignoring_unlock_cap = button_pressed
