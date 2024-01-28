extends TextureRect

signal slot_entered(slot)
signal slot_exited(slot)

@onready var filter = $StatusFilter
@onready var padlock = $Padlock

var slot_ID
var is_hovering := false
var locked := true
enum States {DEFAULT, TAKEN, FREE}
var state := States.DEFAULT
var installed_item = null

func set_color(a_state = States.DEFAULT):
	match a_state:
		States.DEFAULT:
			filter.color = Color(Color.WHITE, 0.0)
		States.TAKEN:
			filter.color = Color(Color.DARK_ORANGE, 0.3)
		States.FREE:
			filter.color = Color(Color.GREEN, 0.3)

func lock():
	locked = true
	padlock.visible = true

func unlock():
	locked = false
	padlock.visible = false

func _process(_delta):
	if get_global_rect().has_point(get_global_mouse_position()):
		if not is_hovering:
			is_hovering = true
			emit_signal("slot_entered", self)
	else:
		if is_hovering:
			is_hovering = false
			emit_signal("slot_exited")
