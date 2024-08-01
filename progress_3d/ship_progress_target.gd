class_name ShipProgressTarget
extends Marker3D

var camera: Camera3D
@export var viewport_height_percentage = 0.5

# 8 by 4
# 2 padding on each side
@export var object_height = 12.0
@export var object_width = 8.0

@onready var v_stretch = $Control/VBoxContainer/Stretch
@onready var bg_panel = $Control/VBoxContainer/Panel

@onready var progress_cam_atlas_texture = $Control/VBoxContainer/Panel/ProgressCamAtlasTexture

var progress_vp: SubViewport
var progress_cam: Camera3D

static var instance: ShipProgressTarget

func _ready():
	instance = self
	
	camera = get_parent()
	
	v_stretch.set_stretch_ratio(1.0 - viewport_height_percentage)
	bg_panel.set_stretch_ratio(viewport_height_percentage)
	await get_tree().process_frame 
	var bg_rect: Rect2 = bg_panel.get_rect()
	var size = bg_rect.size
	size.x = size.y / object_height * object_width
	bg_panel.set_custom_minimum_size(size)
	
	progress_vp = camera.get_node("ProgressViewport")
	progress_cam = progress_vp.get_child(0)
	
	# progress_vp.set_size(size)
	progress_vp.set_size(get_viewport().get_size())
	
	var node_path: NodePath = progress_vp.get_path()
	var progress_cam_atlas: AtlasTexture = \
		progress_cam_atlas_texture.get_texture()
	var progress_cam_viewport: ViewportTexture = \
		progress_cam_atlas.get_atlas()
	progress_cam_viewport.set_viewport_path_in_scene(node_path)
	
	var origin = get_viewport().get_size() - Vector2i(size)
	var region = Rect2(origin, size)
	progress_cam_atlas.set_region(region)
	
	sync_with_camera()
	
	Global.all_parts_picked_up.connect(all_parts_picked_up)

func sync_with_camera():
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
	
func all_parts_picked_up():
	var theme: Theme = bg_panel.get_theme().duplicate()
	# Godot wttf is this theme.get_stylebox syntax
	var sb_flat: StyleBoxFlat = theme.get_stylebox("panel", "Panel")
	var alpha = sb_flat.border_color.a
	sb_flat.border_color = Color(Color.LIME_GREEN, alpha)
	bg_panel.set_theme(theme)
