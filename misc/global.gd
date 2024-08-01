extends Node

signal to_main_menu
signal start_game
signal restart
signal victory

signal all_parts_picked_up

var in_game: bool = false

func _ready():
	start_game.connect(func(): in_game = true)
	restart.connect(func(): in_game = true)
	victory.connect(func(): in_game = false)
	to_main_menu.connect(func(): in_game = false)

func _input(event):
	if OS.is_debug_build():
		if event is InputEventKey and event.is_pressed:
			match event.keycode:
				KEY_V:
					victory.emit()
