extends Node

signal to_main_menu
signal request_start_game
signal restart
signal victory

signal all_parts_picked_up

@onready var game_world: PackedScene = preload("res://game_world.tscn")
var current_game_world: Node3D

# var in_game: bool = false

func _ready():
	request_start_game.connect(start_game)
	restart.connect(restart_game)
	#victory.connect(func(): in_game = false)
	#to_main_menu.connect(func(): in_game = false)

func _input(event):
	if OS.is_debug_build():
		if event is InputEventKey and event.is_pressed:
			match event.keycode:
				KEY_V:
					victory.emit()
				KEY_R:
					restart_game()

func start_game():
	if current_game_world:
		return
	RocketPart.parts_count = 0
	RocketPart.remaining_parts_count = 0
	current_game_world = game_world.instantiate()
	var root: Node = get_tree().get_root().get_child(0)
	root.add_child(current_game_world)
	root.move_child(current_game_world, 0)

func end_game():
	if current_game_world:
		var root: Node = get_tree().get_root().get_child(0)
		current_game_world.queue_free()
		await current_game_world.tree_exited
		current_game_world = null

func restart_game():
	await end_game()
	start_game()
