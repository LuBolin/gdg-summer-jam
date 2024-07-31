class_name RocketPart
extends CharacterBody3D

@export var target: Node3D

var picked_up = false

var target_position: Vector3
var target_rotation: Quaternion

var initial_pickup_time: float = 1.0  # Time to reach target when first picked up
var follow_time: float = 0.05  # Time to reach target during normal following
var current_move_time: float
var pickup_timer: float = 0.0


func _physics_process(delta):
	if not picked_up:
		return
	if target:
		pickup_timer += delta
		
		target_position = target.global_position
		target_rotation = target.get_quaternion()

		current_move_time = initial_pickup_time \
			if pickup_timer <= initial_pickup_time \
			else follow_time

		var direction = (target_position - global_position)
		velocity = direction / current_move_time

		move_and_slide()

		global_rotation = target.global_rotation
		
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var camera3d = get_viewport().get_camera_3d()
		var from = camera3d.project_ray_origin(event.position)
		var to = from + camera3d.project_ray_normal(event.position) * 1000

		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		var result = space_state.intersect_ray(query)

		if result and result.collider == self:
			pick_up()

func pick_up():
	picked_up = true
	set_collision_layer(0)
	set_collision_mask(0)
	pickup_timer = 0.0
	get_node("PickSphere").hide()
