@tool
extends Area3D
@onready var collision_shape: CollisionShape3D = $CollisionShape
@onready var visual_indicator: MeshInstance3D = $VisualIndicator

@export var radius: float = 200:
	set(v):
		radius = v
		var vi = get_node_or_null("VisualIndicator")
		if not vi:
			return
		var mesh: SphereMesh = vi.get_mesh()
		mesh.set_height(2 * radius)
		mesh.set_radius(radius)
		var shape: SphereShape3D = collision_shape.get_shape()
		shape.set_radius(radius)

var ready_to_exit: bool = false

var terminating = false

func _ready():
	if Engine.is_editor_hint():
		return
	
	self.visible = true
	
	self.body_exited.connect(_on_body_exited)
	Global.all_parts_picked_up.connect(_ready_to_leave)
	
	var mesh: SphereMesh = visual_indicator.get_mesh()
	var mat: StandardMaterial3D = mesh.get_material()
	mat.albedo_color = Color(Color.DARK_RED, 0.5)
	
	terminating = false
	
	Global.to_main_menu.connect(func(): terminating = true)
	Global.restart.connect(func(): terminating = true)
	Global.victory.connect(func(): terminating = true)

func _ready_to_leave():
	ready_to_exit = true
	var mesh: SphereMesh = visual_indicator.get_mesh()
	var mat: StandardMaterial3D = mesh.get_material()
	mat.albedo_color = Color(Color.LIME_GREEN, 0.5)

func _on_body_exited(body: Node3D):
	if terminating:
		return
	if not (body is Player):
		return
	if body != Player.instance:
		return
	if ready_to_exit:
		Global.victory.emit()
	else:
		Global.restart.emit()
