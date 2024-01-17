extends ColorRect

@onready var item_texture = $Texture
@onready var name_label = $NameLabel

var icon_path
var item_id

signal item_selected(data)

func load_item(a_Item_data):
	item_id = a_Item_data["name"].to_snake_case()
	if a_Item_data["tags"]:
		if !a_Item_data["tags"].contains("ai core"):
			icon_path = "res://Assets/Item Sprites/" + a_Item_data["section"].capitalize() + " Parts/" + a_Item_data["name"] + ".png"
		else:
			icon_path = "res://Assets/Item Sprites/Head Parts/AI Core.png"
	else:
		icon_path = "res://Assets/Item Sprites/" + a_Item_data["section"].capitalize() + " Parts/" + a_Item_data["name"] + ".png"
	item_texture.texture = load(icon_path)
	name_label.text = a_Item_data["name"]

func _on_texture_button_button_down():
	emit_signal("item_selected", item_id)
