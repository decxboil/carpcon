extends TextureRect

signal slot_entered(slot)
signal slot_exited(slot)

@onready var filter = $StatusFilter
@onready var padlock = $Padlock

var slot_ID
var is_hovering := false
enum States {DEFAULT, TAKEN, FREE, LOCKED}
var state := States.DEFAULT
var equipment_installed = null

func set_color(a_state = States.DEFAULT):
	match a_state:
		States.DEFAULT:
			filter.color = Color(Color.WHITE, 0.0)
			padlock.visible = false
		States.TAKEN:
			filter.color = Color(Color.RED, 0.3)
		States.FREE:
			filter.color = Color(Color.GREEN, 0.3)
		States.LOCKED:
			padlock.visible = true

func lock():
	state = States.LOCKED
	self.set_color(state)

func _process(delta):
	if state == States.LOCKED:
		return
	if get_global_rect().has_point(get_global_mouse_position()):
		if not is_hovering:
			is_hovering = true
			emit_signal("slot_entered", self)
	else:
		if is_hovering:
			is_hovering = false
			emit_signal("slot_exited", self)
