extends Node

signal all_parts_picked_up

@onready var target_prefab = preload("res://ship_progress_target.tscn")
static var ship_progress_target: ShipProgressTarget

func _ready():
	ship_progress_target = target_prefab.instantiate()
	var cam3d = get_viewport().get_camera_3d()
	cam3d.add_child(ship_progress_target)
