extends GridContainer

signal spawn_item(item_ID)

func on_item_selected(a_Item_ID):
	emit_signal("spawn_item", a_Item_ID)
