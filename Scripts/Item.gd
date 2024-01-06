extends Node2D

@onready var IconRect_path = $Icon

var item_ID : int
var item_grids := []
var selected = false
var grid_anchor = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 60 * delta)

func load_item(a_itemID : int):
	var icon_path = "res://Assets/" + DataHandler.item_data[str(a_itemID)]["Name"] + ".png"
	IconRect_path.texture = load(icon_path)
	for grid in DataHandler.item_grid_data[str(a_itemID)]:
		var converter_array := []
		for i in grid:
			converter_array.push_back(int(i))
		item_grids.push_back(converter_array)
