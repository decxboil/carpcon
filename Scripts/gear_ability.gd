extends ColorRect

@onready var name_label = $VBoxContainer/GearAbilityLabel
@onready var text_label = $VBoxContainer/GearAbilityText

func _on_mech_builder_set_gear_ability(a_Frame):
	name_label.text = "Gear Ability:\n" + a_Frame["gear_ability_name"]
	text_label.text = a_Frame["gear_ability"]
