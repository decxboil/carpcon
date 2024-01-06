extends Control

@onready var slot_scene = preload("res://Scenes/grid_slot.tscn")
@onready var body_container = $ColorRect/MarginContainer/VBoxContainer/BodyContainer
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
	
	grid_array[3].lock()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func create_slot():
	var new_slot = slot_scene.instantiate()
	new_slot.slot_ID = grid_array.size()
	body_container.add_child(new_slot)
	grid_array.push_back(new_slot)
	new_slot.slot_entered.connect(_on_slot_mouse_entered)
	new_slot.slot_exited.connect(_on_slot_mouse_exited)

func _on_slot_mouse_entered(a_Slot):
	a_Slot.set_color(a_Slot.States.TAKEN)
	pass
	
func _on_slot_mouse_exited(a_Slot):
	a_Slot.set_color(a_Slot.States.DEFAULT)
	pass

func _on_button_spawn_pressed():
	var new_item = item_scene.instantiate()
	add_child(new_item)
	new_item.load_item(1)
	new_item.selected = true
	item_held = new_item
