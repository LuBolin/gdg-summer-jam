@tool
class_name RocketPart
extends CharacterBody3D

var target: ShipProgressTarget

var picked_up = false

var target_position: Vector3
var target_rotation: Quaternion

var initial_pickup_time: float = 1.0  # Time to reach target when first picked up
var follow_time: float = 0.05  # Time to reach target during normal following
var current_move_time: float
var pickup_timer: float = 0.0

var has_reached_target: bool = false
var pos_at_pickup: Vector3

static var parts_count: int = 0
static var remaining_parts_count: int = 0

@export var pick_sphere_radius: float = 2.0:
	set(v):
		pick_sphere_radius = v
		var ps: MeshInstance3D = get_node("PickSphere")
		ps.mesh = ps.mesh.duplicate() # make unique
		var sphere: SphereMesh = ps.get_mesh()
		sphere.radius = v
		sphere.height = 2 * v
@export var pick_sphere_color: Color = Color('0000ff61'):
	set(v):
		pick_sphere_color = v
		var ps: MeshInstance3D = get_node("PickSphere")
		var sphere: SphereMesh = ps.get_mesh()
		var mat: StandardMaterial3D = sphere.get_material()
		mat.albedo_color = v
@export var pick_sphere_y: float = 0:
	set(v):
		pick_sphere_y = v
		var ps: MeshInstance3D = get_node("PickSphere")
		ps.position.y = v
@export var show_bbox: bool = true:
	set(v):
		show_bbox = v
		var bbox = get_node("BBox")
		bbox.set_visible(v)

@onready var pick_sphere: MeshInstance3D = $PickSphere
@onready var b_box: Node3D = $BBox
@onready var illusion_body: CharacterBody3D = $IllusionBody
@onready var illusion_mesh: MeshInstance3D = $IllusionBody/IllusionMesh

var model: MeshInstance3D
var collision_shape: CollisionShape3D


func _ready():
	for c in get_children():
		if not c is MeshInstance3D:
			continue
		elif c in [pick_sphere, b_box]:
			continue
		else:
			model = c
			break
	assert(model)
	assert(pick_sphere)
	
	if not Global.ship_progress_target.is_node_ready():
		await Global.ship_progress_target.is_node_ready
	
	target = Global.ship_progress_target
	
	pick_sphere.create_trimesh_collision()
	var static_body = pick_sphere.get_child(0)
	var collision_shape = static_body.get_child(0)
	collision_shape.reparent(self)
	pick_sphere.remove_child(static_body)
	static_body.queue_free()
	
	b_box.hide()
	
	# this part needs updating when we use proper models
	var dupe_mesh = model.mesh.duplicate()
	var mat = StandardMaterial3D.new()
	# Transparency TRANSPARENCY_ALPHA = 1
	mat.set_transparency(1)
	mat.albedo_color = Color(Color.DARK_BLUE, 0.75)
	dupe_mesh.set_material(mat)
	illusion_mesh.mesh = dupe_mesh
	illusion_mesh.set_position(model.get_position())
	
	parts_count += 1
	remaining_parts_count += 1

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	
	# var to_move: CharacterBody3D = self if picked_up else illusion_body
	var to_moves = []
	if picked_up:
		to_moves.append(self)
	if not has_reached_target:
		to_moves.append(illusion_body)
	if not to_moves:
		return
	if picked_up:
		pickup_timer += delta
	
	target_position = target.global_position
	target_rotation = target.get_quaternion()
	
	for to_move in to_moves:
		if to_move == self:
			if not has_reached_target:
				# During initial pickup movement
				var t = pickup_timer / initial_pickup_time
				to_move.global_position = pos_at_pickup.lerp(target_position, t)
				var dist = target_position.distance_to(to_move.global_position)
				if dist < 0.1:
					pick_up_reached()
			else:
				var direction = (target_position - global_position)
				to_move.velocity = direction / follow_time
				to_move.move_and_slide()
		elif to_move == illusion_body:
			var direction = (target_position - to_move.global_position)
			to_move.velocity = direction / follow_time
			to_move.move_and_slide()
			
		to_move.global_rotation = target.global_rotation


func _input(event):
	if Engine.is_editor_hint():
		return

func pick_up():
	picked_up = true
	set_collision_layer(0)
	set_collision_mask(0)
	pickup_timer = 0.0
	pos_at_pickup = global_position
	pick_sphere.hide()

func pick_up_reached():
	has_reached_target = true
	for c in illusion_body.get_children():
		illusion_body.remove_child(c)
		c.queue_free()
	remove_child(illusion_body)
	illusion_body.queue_free()
	remaining_parts_count -= 1
	if remaining_parts_count == 0:
		Global.all_parts_picked_up.emit()
