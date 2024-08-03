extends Control

@onready var jump_bar = %JumpBar
	
var held: bool = false
var time_held: float = 0

var time_to_get_to_slow_down = 1.0
var time_to_get_to_max = 3.0
var min_strength = 1
var slow_down_range = 6
var max_strength = 8

func _ready():
	jump_bar.set_min(min_strength)
	jump_bar.set_max(max_strength)

func _input(event):
	if not event is InputEventKey:
		return
	if event.keycode == KEY_SPACE:
		held = event.is_pressed()
		if not held:
			jump()
	if event.keycode == KEY_SHIFT and event.is_pressed():
		if held:
			held = false
			time_held = 0

func _process(delta):
	if held:
		if time_held == 0:
			if PlayerCamera.instance:
				var jump_indicator: CPUParticles3D = \
					PlayerCamera.instance.jump_dirn_indicator
				jump_indicator.set_emitting(true)
		time_held += delta
	var strength: float = min_strength
	if time_held <= time_to_get_to_slow_down:
		var ratio = time_held / time_to_get_to_slow_down
		strength = min_strength + (slow_down_range - min_strength) * ratio
	else:
		var p2_time = time_held - time_to_get_to_slow_down
		var p2_ratio = p2_time \
			/ (time_to_get_to_max - time_to_get_to_slow_down)
		strength = slow_down_range + (max_strength - slow_down_range) * p2_ratio
	jump_bar.set_value(strength)

func jump():
	var strength = jump_bar.get_value()
	time_held = 0
	if PlayerCamera.instance:
		var jump_indicator: CPUParticles3D = \
			PlayerCamera.instance.jump_dirn_indicator
		jump_indicator.set_emitting(false)
		var cur_ammount = jump_indicator.get_amount()
		jump_indicator.set_amount(1)
		jump_indicator.set_amount(cur_ammount)
	var p: Player = Player.instance
	print("Jump with strength: ", strength)
	var exit = strength == max_strength
	if exit:
		strength *= 2
	p.jump(strength, exit)
