extends Node

signal to_main_menu
signal restart
signal victory

signal all_parts_picked_up

@onready var target_prefab = preload("res://progress_3d/ship_progress_target.tscn")
static var ship_progress_target: ShipProgressTarget

func _ready():
	ship_progress_target = target_prefab.instantiate()
	var cam3d = get_viewport().get_camera_3d()
	cam3d.add_child(ship_progress_target)

func _input(event):
	if OS.is_debug_build():
		if event is InputEventKey and event.is_pressed:
			match event.keycode:
				KEY_V:
					victory.emit()
