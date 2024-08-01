extends Node

signal to_main_menu
signal start_game
signal restart
signal victory

signal all_parts_picked_up

func _ready():
	pass

func _input(event):
	if OS.is_debug_build():
		if event is InputEventKey and event.is_pressed:
			match event.keycode:
				KEY_V:
					victory.emit()
