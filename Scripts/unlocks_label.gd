extends Label

func _on_stats_list_update_unlock_label(a_Current, a_Maximum):
	text = "Unlocks Remaining: " + str(a_Maximum - a_Current) + "/" + str(a_Maximum)
