extends ColorRect

@onready var slot_scene = preload("res://Scenes/grid_slot.tscn")
@onready var item_scene = preload("res://Scenes/item.tscn")

@onready var name_input = $LineEdit
@onready var head_container = $HeadContainer
@onready var body_container = $BodyContainer
@onready var l_arm_container = $LeftArmContainer
@onready var r_arm_container = $RightArmContainer
@onready var legs_container = $LegsContainer
@onready var containers = [body_container, l_arm_container, r_arm_container, head_container, legs_container]

var grid_array := []
var current_slot = null
var icon_anchor : Vector2
var can_unlock := false

var unlocks := []
var save_path = "res://Data/frame_data.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	for container in containers:
		for i in container.capacity:
			create_slot(container)

func _process(_delta):
	if Input.is_action_just_pressed("mouse_leftclick"):
		for container in containers:
			if container.get_global_rect().has_point(get_global_mouse_position()):
				toggle_locked()

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
	set_grids.call_deferred(current_slot)

func set_grids(a_Slot):
	grid_array[a_Slot.slot_ID].set_color(grid_array[a_Slot.slot_ID].States.FREE)

func _on_slot_mouse_exited():
	clear_grid()

func clear_grid():
	for grid in grid_array:
		grid.set_color(grid.States.DEFAULT)

func toggle_locked():
	if not current_slot:
		return
	
	var index = unlocks.find(current_slot.slot_ID)
	if index == -1:
		unlocks.push_back(current_slot.slot_ID)
		current_slot.unlock()
	else:
		unlocks.remove_at(index)
		current_slot.lock()

func _on_save_button_button_down():
	var file = FileAccess.open(save_path, FileAccess.READ)
	var save_data = {}
	save_data = JSON.parse_string(file.get_as_text())
	file.close()
	
	file = FileAccess.open(save_path, FileAccess.WRITE)
	if !save_data:
		save_data = {}
	unlocks.sort()
	var frame_name = name_input.text
	if !save_data.has(frame_name):
		save_data[frame_name] = {}
	save_data[frame_name]["unlocks"] = unlocks
	file.store_string(JSON.stringify(save_data))
	file.close()
	print("Saved frame " + frame_name + " at " + save_path)
