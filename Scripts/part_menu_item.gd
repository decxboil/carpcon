extends ColorRect

@onready var item_texture = $Texture
@onready var name_label = $NameLabel

var icon_path
var item_ID

signal item_selected(data)

func load_item(a_Item_data, a_Item_ID):
	item_ID = a_Item_ID
	icon_path = a_Item_data["icon_path"]
	item_texture.texture = load(icon_path)
	name_label.text = a_Item_data["name"]

func _on_texture_button_button_down():
	get_parent().on_item_selected(item_ID)
