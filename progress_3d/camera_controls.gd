extends Camera3D

var sensitivity = 0.1
var yaw = 0.0
var pitch = 0.0

func _ready():
	# Hide the mouse cursor and capture it within the window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

var held: bool = false

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		held = event.is_pressed()
		
	if event is InputEventMouseMotion and held:
		# Adjust yaw and pitch based on the mouse motion
		yaw -= event.relative.x * sensitivity
		pitch -= event.relative.y * sensitivity

		# Clamp the pitch to prevent the camera from flipping
		pitch = clamp(pitch, -90, 90)

		# Apply the rotation to the camera
		rotation_degrees.y = yaw
		rotation_degrees.x = pitch
	if event is InputEventKey and event.is_pressed and event.keycode == KEY_SPACE:
		yaw = 0.0
		pitch = 0.0
		rotation_degrees.y = yaw
		rotation_degrees.x = pitch
