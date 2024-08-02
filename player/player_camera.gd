@tool
class_name PlayerCamera
extends Node3D

@onready var yaw_node = $CamYaw
@onready var pitch_node = $CamYaw/CamPitch
@onready var camera: Camera3D = $CamYaw/CamPitch/SpringArm/PlayerCamera
@onready var interact_raycast: RayCast3D = $CamYaw/CamPitch/SpringArm/PlayerCamera/InteractRaycast
@onready var jump_dirn_indicator = %JumpDirnIndicator


@export var y_offset: float = 2.0:
	set(v):
		y_offset = v
		var cam_yaw: Node3D = get_node_or_null("CamYaw")
		if not cam_yaw:
			return
		cam_yaw.position = Vector3(0, y_offset, 0)

var yaw : float = 0
var pitch : float = 0

static var instance: PlayerCamera

static var yaw_sensitivity: float = 0.1
static var pitch_sensitivity: float = 0.1

var yaw_acceleration: float = 20
var pitch_acceleration: float = 20

var pitch_max: float = 40
var pitch_min: float = -65

var current_interacter: Node3D

func _ready():
	if Engine.is_editor_hint():
		return
	
	instance = self
	camera.set_current(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if Engine.is_editor_hint():
		return
	
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * yaw_sensitivity
		pitch -= event.relative.y * pitch_sensitivity

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	
	pitch = clamp(pitch, pitch_min, pitch_max)
	
	yaw_node.rotation_degrees.y = lerp(
		yaw_node.rotation_degrees.y, yaw, yaw_acceleration * delta)
	pitch_node.rotation_degrees.x = lerp(
		pitch_node.rotation_degrees.x, pitch, pitch_acceleration * delta)

	var collider = null
	if interact_raycast.is_colliding():
		collider = interact_raycast.get_collider()
	if collider == current_interacter:
		return
	# collider !=  current_interacter
	if current_interacter and current_interacter.has_method("hide_interact_hint"):
		current_interacter.hide_interact_hint()
	current_interacter = collider
	if collider and collider.has_method("show_interact_hint"):
		collider.show_interact_hint()
