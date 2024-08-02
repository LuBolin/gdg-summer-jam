extends Control

@onready var jump_bar = %JumpBar
	
var held: bool = false
var time_held: float = 0

var time_to_get_to_slow_down = 0.4
var time_to_get_to_max = 1.2
var min_jump = 2
var slow_down_range = 6
var max_jump = 7

func _ready():
	jump_bar.set_min(min_jump)
	jump_bar.set_max(max_jump)

func _input(event):
	if not event is InputEventKey:
		return
	if event.keycode == KEY_SPACE:
		held = event.is_pressed()
		if not held:
			jump()

func _process(delta):
	if held:
		if time_held == 0:
			if PlayerCamera.instance:
				var jump_indicator: CPUParticles3D = \
					PlayerCamera.instance.jump_dirn_indicator
				jump_indicator.set_emitting(true)
		time_held += delta
	var strength: float = min_jump
	if time_held <= time_to_get_to_slow_down:
		var ratio = time_held / time_to_get_to_slow_down
		strength = min_jump + (slow_down_range - min_jump) * ratio
	else:
		var p2_time = time_held - time_to_get_to_slow_down
		var p2_ratio = p2_time \
			/ (time_to_get_to_max - time_to_get_to_slow_down)
		strength = slow_down_range + (max_jump - slow_down_range) * p2_ratio
	jump_bar.set_value(strength)

func jump():
	var strength = jump_bar.get_value()
	print(strength)
	if strength == max_jump:
		print("WEEEEE")
	time_held = 0
	if PlayerCamera.instance:
		var jump_indicator: CPUParticles3D = \
			PlayerCamera.instance.jump_dirn_indicator
		jump_indicator.set_emitting(false)
