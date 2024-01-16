extends ColorRect

@onready var slot_scene = preload("res://Scenes/grid_slot.tscn")
@onready var item_scene = preload("res://Scenes/item.tscn")

@onready var head_container = $HeadContainer
@onready var body_container = $BodyContainer
@onready var l_arm_container = $LeftArmContainer
@onready var r_arm_container = $RightArmContainer
@onready var legs_container = $LegsContainer
@onready var containers = [body_container, l_arm_container, r_arm_container, head_container, legs_container]

var save_path = "res://Data/frame_data.fsh"

var grid_array := []
var item_held = null
var current_slot = null
var can_place := false
var icon_anchor : Vector2
enum Modes {EQUIP, PLACE, UNLOCK}
var mode = Modes.EQUIP

signal item_installed(a_Item)
signal item_removed(a_Item)

# Called when the node enters the scene tree for the first time.
func _ready():
	for container in containers:
		for i in container.capacity:
			create_slot(container)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("mouse_leftclick"):
		match mode:
			Modes.EQUIP:
				for container in containers:
					if container.get_global_rect().has_point(get_global_mouse_position()):
						pickup_item()
			Modes.PLACE:
				for container in containers:
					if container.get_global_rect().has_point(get_global_mouse_position()):
						place_item()
			Modes.UNLOCK:
				for container in containers:
					if container.get_global_rect().has_point(get_global_mouse_position()):
						toggle_locked()
	elif Input.is_action_just_pressed("mouse_rightclick"):
		match mode:
			Modes.PLACE:
				drop_item()
	pass

func create_slot(container):
	var new_slot = slot_scene.instantiate()
	new_slot.slot_ID = grid_array.size()
	container.add_child(new_slot)
	grid_array.push_back(new_slot)
	new_slot.slot_entered.connect(_on_slot_mouse_entered)
	new_slot.slot_exited.connect(_on_slot_mouse_exited)

func _on_slot_mouse_entered(a_Slot):
	icon_anchor = Vector2(10000, 10000)
	current_slot = a_Slot
	if item_held:
		check_slot_availability(current_slot)
		set_grids.call_deferred(current_slot)
	if mode == Modes.UNLOCK:
		check_lock_availability(current_slot)
		set_lock_grids.call_deferred(current_slot)
	pass
	
func _on_slot_mouse_exited(_a_Slot):
	clear_grid()
	pass

func _on_button_spawn_pressed():
	var new_item = item_scene.instantiate()
	add_child(new_item)
	new_item.load_item("far_sensors_i")
	new_item.selected = true
	item_held = new_item
	mode = Modes.PLACE

func check_lock_availability(a_Slot):
	pass

func check_slot_availability(a_Slot):
	var column_count = a_Slot.get_parent().columns
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
		if grid_array[grid_to_check].get_parent() != current_slot.get_parent():
			can_place = false
			return
		if item_held.item_data["section"] != "Any" and grid_array[grid_to_check].get_parent().get_name() != (item_held.item_data["section"].capitalize() + "Container"):
			can_place = false
			return
		can_place = true

func set_lock_grids(a_Slot):
	grid_array[a_Slot.slot_ID].set_color(grid_array[a_Slot.slot_ID].States.FREE)

func set_grids(a_Slot):
	var column_count = a_Slot.get_parent().columns
	for grid in item_held.item_grids:
		var grid_to_check = a_Slot.slot_ID + grid[0] + grid[1] * column_count
		var line_switch_check = a_Slot.slot_ID % column_count + grid[0]
		if line_switch_check < 0 or line_switch_check >= column_count:
			continue
		if grid_to_check < 0 or grid_to_check >= grid_array.size():
			continue
		if grid_array[grid_to_check].get_parent() != current_slot.get_parent():
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
	
	var column_count = current_slot.get_parent().columns
	var calculated_grid_id = current_slot.slot_ID + icon_anchor.x * column_count + icon_anchor.y
	if calculated_grid_id >= grid_array.size():
		return
	
	item_held.get_parent().remove_child(item_held)
	current_slot.get_parent().add_child(item_held)
	item_held.global_position = get_global_mouse_position()
	
	item_held.snap_to(grid_array[calculated_grid_id].global_position)
	
	item_held.grid_anchor = current_slot
	for grid in item_held.item_grids:
		var grid_to_check = current_slot.slot_ID + grid[0] + grid[1] * column_count
		grid_array[grid_to_check].state = grid_array[grid_to_check].States.TAKEN
		grid_array[grid_to_check].installed_item = item_held
	
	emit_signal("item_installed", item_held)
	
	item_held = null
	mode = Modes.EQUIP
	clear_grid()

func pickup_item():
	if not current_slot or not current_slot.installed_item:
		return
	
	var column_count = current_slot.get_parent().columns
	item_held = current_slot.installed_item
	item_held.selected = true
	
	for grid in item_held.item_grids:
		var grid_to_check = item_held.grid_anchor.slot_ID + grid[0] + grid[1] * column_count
		grid_array[grid_to_check].state = grid_array[grid_to_check].States.FREE
		grid_array[grid_to_check].installed_item = null
	
	check_slot_availability(current_slot)
	set_grids.call_deferred(current_slot)
	
	emit_signal("item_removed", item_held)
	
	mode = Modes.PLACE

func drop_item():
	item_held.queue_free()
	item_held = null
	mode = Modes.EQUIP

func toggle_locked():
	if not current_slot:
		return
	
	if current_slot.locked:
		current_slot.unlock()

func _on_frame_chooser_load_frame(a_Frame):
	for grid in grid_array:
		grid.lock()
	for index in a_Frame["unlocks"]:
		grid_array[index].unlock()

func _on_unlock_toggle_button_down():
	if item_held:
		drop_item()
	
	if mode == Modes.UNLOCK:
		mode = Modes.EQUIP
	else:
		mode = Modes.UNLOCK
