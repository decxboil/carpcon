extends Node

@export var target_label: Label
@export var max_offset := 2

var is_shaking := false
@onready var effect_label: Label = $Label

func _ready():
	stop_shaking()

func _process(_delta):
	if is_shaking:
		var current_offset := Vector2(randf_range(-max_offset, max_offset), randf_range(-max_offset, max_offset))
		effect_label.global_position = target_label.global_position + current_offset

func start_shaking():
	effect_label.text = target_label.text
	effect_label.size = target_label.size
	effect_label.horizontal_alignment = target_label.horizontal_alignment
	effect_label.vertical_alignment = target_label.vertical_alignment
	effect_label.add_theme_font_size_override("font_size", target_label.get_theme_font_size("font_size") + 2)
	effect_label.show()
	is_shaking = true

func stop_shaking():
	effect_label.hide()
	is_shaking = false


