extends Node2D

@onready var IconRect_path = $Icon

var item_ID : int
var item_grids := []
var selected = false
var grid_anchor = null
var part_section = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position() - IconRect_path.size/2, 60 * delta)

func load_item(a_itemID : int):
	part_section = DataHandler.item_data[str(a_itemID)]["section"]
	var icon_path = "res://Assets/Item Sprites/" + part_section + " Parts/" + DataHandler.item_data[str(a_itemID)]["name"] + ".png"
	IconRect_path.texture = load(icon_path)
	for grid in DataHandler.item_grid_data[str(a_itemID)]:
		var converter_array := []
		for i in grid:
			converter_array.push_back(int(i))
		item_grids.push_back(converter_array)

func snap_to(destination: Vector2):
	var tween = get_tree().create_tween()
	
	var snap_adjustment = Vector2(2,0)
	tween.tween_property(self, "global_position", destination + snap_adjustment, 0.01).set_trans(Tween.TRANS_SINE)
	selected = false
