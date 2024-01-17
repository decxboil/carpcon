extends ColorRect

@onready var slot_scene = preload("res://Scenes/grid_slot.tscn")
@onready var item_scene = preload("res://Scenes/item.tscn")

@onready var name_input = $LineEdit
@onready var chest_container = $ChestContainer

var grid_array := []
var current_slot = null
var icon_anchor : Vector2

var grid := []
var save_path = "res://Data/item_data.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in chest_container.capacity:
		create_slot(chest_container)

func _process(_delta):
	if Input.is_action_just_pressed("mouse_leftclick"):
		if chest_container.get_global_rect().has_point(get_global_mouse_position()):
			toggle_selected()

func create_slot(container):
	var new_slot = slot_scene.instantiate()
	new_slot.slot_ID = grid_array.size()
	container.add_child(new_slot)
	grid_array.push_back(new_slot)
	new_slot.unlock()
	new_slot.slot_entered.connect(_on_slot_mouse_entered)
	new_slot.slot_exited.connect(_on_slot_mouse_exited)

func _on_slot_mouse_entered(a_Slot):
	icon_anchor = Vector2(10000, 10000)
	current_slot = a_Slot
	set_grids.call_deferred(current_slot)

func set_grids(a_Slot):
	if a_Slot.state != a_Slot.States.TAKEN:
		grid_array[a_Slot.slot_ID].set_color(grid_array[a_Slot.slot_ID].States.FREE)

func _on_slot_mouse_exited(a_Slot):
	clear_grid()

func clear_grid():
	for grid in grid_array:
		if grid.state != grid.States.TAKEN:
			grid.set_color(grid.States.DEFAULT)

func toggle_selected():
	if not current_slot:
		return
	
	var current_ID = current_slot.slot_ID
	var grid_y = current_ID/chest_container.columns
	var grid_x = current_ID%chest_container.columns
	var formatted_coords = "[" + str(grid_x) + ", " + str(grid_y) + "]"
	
	if current_slot.state == current_slot.States.DEFAULT:
		grid.push_back(formatted_coords)
		current_slot.set_color(grid_array[current_ID].States.TAKEN)
		current_slot.state = current_slot.States.TAKEN
		print("Added " + formatted_coords)
	else:
		grid.erase(formatted_coords)
		current_slot.set_color(grid_array[current_ID].States.DEFAULT)
		current_slot.state = current_slot.States.DEFAULT
		print("Removed " + formatted_coords)

func _on_save_button_button_down():
	var file = FileAccess.open(save_path, FileAccess.READ)
	var save_data = {}
	save_data = JSON.parse_string(file.get_as_text())
	file.close()
	
	if !save_data:
		save_data = {}
	grid.sort()
	var item_name = name_input.text
	save_data[item_name]["grid"] = grid
	
	file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
	print("Saved item " + item_name + " at " + save_path)
