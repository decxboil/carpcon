extends Control

@onready var slot_scene = preload("res://Scenes/grid_slot.tscn")
@onready var body_container = $ColorRect/BodyContainer
@onready var item_scene = preload("res://Scenes/item.tscn")
@onready var column_count = body_container.columns

var grid_array := []
var item_held = null
var current_slot = null
var can_place := false
var icon_anchor : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(36):
		create_slot()
	
	for i in range(36):
		if i > 20:
			grid_array[i].unlock()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if item_held:
		if body_container.get_global_rect().has_point(get_global_mouse_position()):
			if Input.is_action_just_pressed("mouse_leftclick"):
				place_item()
	else:
		if body_container.get_global_rect().has_point(get_global_mouse_position()):
			if Input.is_action_just_pressed("mouse_leftclick"):
				pickup_item()
	pass

func create_slot():
	var new_slot = slot_scene.instantiate()
	new_slot.slot_ID = grid_array.size()
	body_container.add_child(new_slot)
	grid_array.push_back(new_slot)
	new_slot.slot_entered.connect(_on_slot_mouse_entered)
	new_slot.slot_exited.connect(_on_slot_mouse_exited)

func _on_slot_mouse_entered(a_Slot):
	icon_anchor = Vector2(10000, 10000)
	current_slot = a_Slot
	if item_held:
		check_slot_availability(current_slot)
		set_grids.call_deferred(current_slot)
	pass
	
func _on_slot_mouse_exited(a_Slot):
	clear_grid()
	pass

func _on_button_spawn_pressed():
	var new_item = item_scene.instantiate()
	add_child(new_item)
	new_item.load_item(1)
	new_item.selected = true
	item_held = new_item

func check_slot_availability(a_Slot):
	for grid in item_held.item_grids:
		var grid_to_check = a_Slot.slot_ID + grid[0] + grid[1] * column_count
		var line_switch_check = a_Slot.slot_ID % column_count + grid[0]
		if line_switch_check < 0 or line_switch_check >= column_count:
			can_place = false
			return
		if grid_to_check < 0 or grid_to_check >= grid_array.size():
			can_place = false
			return
		if grid_array[grid_to_check].state == grid_array[grid_to_check].States.TAKEN or grid_array[grid_to_check].locked:
			can_place = false
			return
		can_place = true

func set_grids(a_Slot):
	for grid in item_held.item_grids:
		var grid_to_check = a_Slot.slot_ID + grid[0] + grid[1] * column_count
		var line_switch_check = a_Slot.slot_ID % column_count + grid[0]
		if line_switch_check < 0 or line_switch_check >= column_count:
			continue
		if grid_to_check < 0 or grid_to_check >= grid_array.size():
			continue
		
		if can_place:
			grid_array[grid_to_check].set_color(grid_array[grid_to_check].States.FREE)
			
			if grid[1] < icon_anchor.x: icon_anchor.x = grid[1]
			if grid[0] < icon_anchor.y: icon_anchor.y = grid[0]	
		else:
			grid_array[grid_to_check].set_color(grid_array[grid_to_check].States.TAKEN)

func clear_grid():
	for grid in grid_array:
		grid.set_color(grid.States.DEFAULT)

func place_item():
	if not can_place or not current_slot:
		return
	
	var calculated_grid_id = current_slot.slot_ID + icon_anchor.x * column_count + icon_anchor.y
	item_held.snap_to(grid_array[calculated_grid_id].global_position)
	
	item_held.grid_anchor = current_slot
	for grid in item_held.item_grids:
		var grid_to_check = current_slot.slot_ID + grid[0] + grid[1] * column_count
		grid_array[grid_to_check].state = grid_array[grid_to_check].States.TAKEN
		grid_array[grid_to_check].equipment_installed = item_held
		
		item_held = null
		clear_grid()

func pickup_item():
	if not current_slot or not current_slot.equipment_installed:
		return
	
	item_held = current_slot.equipment_installed
	item_held.selected = true
	
	for grid in item_held.item_grids:
		var grid_to_check = item_held.slot_ID + grid[0] + grid[1] * column_count
		grid_array[grid_to_check].state = grid_array[grid_to_check].States.FREE
		grid_array[grid_to_check].equipment_installed = null
	
	check_slot_availability(current_slot)
	clear_grid.call_deferred(current_slot)
