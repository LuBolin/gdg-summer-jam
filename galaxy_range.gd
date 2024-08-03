@tool
extends Area3D
@onready var collision_shape: CollisionShape3D = $CollisionShape
@onready var visual_indicator: MeshInstance3D = $VisualIndicator

@export var radius: float = 100:
	set(v):
		radius = v
		var mesh: SphereMesh = visual_indicator.get_mesh()
		mesh.set_height(2 * radius)
		mesh.set_radius(radius)
		var shape: SphereShape3D = collision_shape.get_shape()
		shape.set_radius(radius)

var ready_to_exit: bool = false

func _ready():
	if Engine.is_editor_hint():
		return
	
	self.body_exited.connect(_on_body_exited)
	Global.all_parts_picked_up.connect(_ready_to_leave)
	
	var mesh: SphereMesh = visual_indicator.get_mesh()
	var mat: StandardMaterial3D = mesh.get_material()
	mat.albedo_color = Color(Color.DARK_RED, 0.5)

func _ready_to_leave():
	ready_to_exit = true
	var mesh: SphereMesh = visual_indicator.get_mesh()
	var mat: StandardMaterial3D = mesh.get_material()
	mat.albedo_color = Color(Color.LIME_GREEN, 0.5)

func _on_body_exited(body: Node3D):
	if not (body is Player):
		return
	if ready_to_exit:
		Global.victory.emit()
	else:
		Global.restart.emit()
