class_name PlayerCamera
extends Node3D

@onready var yaw_node = $CamYaw
@onready var pitch_node = $CamYaw/CamPitch
@onready var camera: Camera3D = $CamYaw/CamPitch/SpringArm/PlayerCamera

var yaw : float = 0
var pitch : float = 0

static var instance: PlayerCamera

static var yaw_sensitivity: float = 0.1
static var pitch_sensitivity: float = 0.1

var yaw_acceleration: float = 20
var pitch_acceleration: float = 20

var pitch_max: float = 25
var pitch_min: float = -65

func _ready():
	instance = self
	Global.start_game.connect(start_game)

func start_game():
	camera.set_current(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if event is InputEventMouseMotion:
		yaw += event.relative.x * yaw_sensitivity
		pitch += event.relative.y * pitch_sensitivity

func _physics_process(delta):
	pitch = clamp(pitch, pitch_min, pitch_max)
	
	yaw_node.rotation_degrees.y = lerp(
		yaw_node.rotation_degrees.y, yaw, yaw_acceleration * delta)
	pitch_node.rotation_degrees.x = lerp(
		pitch_node.rotation_degrees.x, pitch, pitch_acceleration * delta)
