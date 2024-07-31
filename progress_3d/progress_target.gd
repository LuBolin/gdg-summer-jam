extends Marker3D

@export var camera: Camera3D
@export var viewport_height_percentage = 0.4

# 8 by 4
# 3 padding on each side
@export var object_height = 14.0
@export var object_width = 10.0

@onready var v_stretch = $Control/VBoxContainer/Stretch
@onready var bg_panel = $Control/VBoxContainer/Panel

func _ready():
	v_stretch.set_stretch_ratio(1.0 - viewport_height_percentage)
	bg_panel.set_stretch_ratio(viewport_height_percentage)
	await get_tree().process_frame 
	var bg_rect: Rect2 = bg_panel.get_rect()
	var size = bg_rect.size
	size.x = size.y / object_height * object_width
	bg_panel.set_custom_minimum_size(size)

func _physics_process(delta):
	var viewport_size = get_viewport().size
	
	var desired_height_pixels = viewport_size.y * viewport_height_percentage
	
	var fov = deg_to_rad(camera.fov)
	var distance_from_camera = (object_height / 2) / tan(fov / 2) / (desired_height_pixels / viewport_size.y)
	
	var camera_basis = camera.global_transform.basis
	
	var right_vector = camera_basis.x * (object_width / 2)
	var down_vector = -camera_basis.y * (object_height / 2)
	
	var viewport_world_height = 2 * distance_from_camera * tan(fov / 2)
	var viewport_world_width = viewport_world_height * viewport_size.x / viewport_size.y
	
	var position_offset = (
		camera_basis.z * -distance_from_camera + 
		camera_basis.x * (viewport_world_width / 2 - object_width / 2) + 
		camera_basis.y * (-viewport_world_height / 2 + object_height / 2)
	)
	var world_position = camera.global_transform.origin + position_offset
	
	global_transform.origin = world_position
	
	#var to_camera = camera.global_transform.origin - global_transform.origin
#
	## Create a basis that looks at the camera
	#var look_at_basis = Basis.looking_at(to_camera, Vector3.UP)
#
	## Interpolate between the current orientation and the look-at orientation
	#var rotation_factor = 0.5  # Adjust this value between 0 and 1 to control how much it faces the camera
	#var final_basis = global_transform.basis.slerp(look_at_basis, rotation_factor)
#
	## Apply the new orientation
	#global_transform.basis = final_basis
