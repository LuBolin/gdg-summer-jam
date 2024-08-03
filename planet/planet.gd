@tool
class_name Planet
extends CharacterBody3D

@onready var gravity_field = %GravityField
@onready var gf_visuals = %GFVisuals

@export var force = 5
@export var planet_scale: float = 1 :
	set(v):
		planet_scale = v
		self.scale = Vector3.ONE * planet_scale
@export var field_planet_ratio = 2.0 :
	set(v):
		field_planet_ratio = v
		var gf = get_node("GravityField")
		gf.scale = Vector3.ONE * field_planet_ratio
@export var rotation_axis = Vector3(1, 1, 0).normalized()
@export var rot_period = 10 #seconds it takes to make a full rotation on its pole
@export var center = Vector3(0, 0, 0) :
	set(v):
		center = v
		pos_sync()
@export var orbit_axis = Vector3(0, 1, 0):
	set(v):
		orbit_axis = v.normalized()
		pos_sync()
@export var orbit_period = 1:
	set(v):
		orbit_period = v
		pos_sync()
@export var orbit_radius = 1:
	set(v):
		orbit_radius = v
		pos_sync()
@export var orbit_axis_angle = PI:
	set(v):
		orbit_axis_angle = v
		pos_sync()
@export var t: float = 0:
	set(v):
		t = v
		pos_sync()
		
@export var mesh : SphereMesh

var objects_on_planet = []

func pos_sync():
	if not is_inside_tree():
		return
	global_position = center + ( \
		Vector3(2 * cos(t / orbit_period), 
		0, 
		sin(t / orbit_period)) * orbit_radius
	).rotated(orbit_axis, orbit_axis_angle)

func _ready():
	if Engine.is_editor_hint():
		return
	gf_visuals.hide()
	$MeshInstance3D.mesh = mesh
	#set scaling
	# self.scale = self.scale * planet_scale
	# gravity_field.scale = gravity_field.scale * field_planet_ratio
	#global_position = center + ( \
			#Vector3(2 * cos(t / orbit_period), 
			#0, 
			#sin(t / orbit_period)) * orbit_radius
		#).rotated(orbit_axis, orbit_axis_angle)
	pass

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	
	#move the planet
	var current_position = global_position
	# $MeshInstance3D.rotate(rotation_axis,  (2*PI)/(rot_period/delta))
	rotate(rotation_axis,  (2*PI)/(rot_period/delta))
	t += delta
	var next_position = center + ( \
		Vector3(2 * cos(t / orbit_period), 
		0, 
		sin(t / orbit_period)) * orbit_radius
	).rotated(orbit_axis, orbit_axis_angle)
	velocity = next_position - current_position
	move_and_slide()
	#move everything on the planet
	var position_change = global_position - current_position
	for object in objects_on_planet:
		update_object(object, position_change)

func get_force():
	return force

func update_object(object, position_change):
	#adjust position
	object.global_position += position_change
	
	var delta = get_process_delta_time()
	var angle = (2*PI)/(rot_period/delta)
	
	# adjust basis rotation
	var gravity_vector = global_position - object.global_position
	if not gravity_vector.normalized().is_equal_approx(object.transform.basis.y):
		var new_basis = Basis(\
			-gravity_vector.cross(object.transform.basis.z).normalized(), \
			-gravity_vector.normalized(), \
			object.transform.basis.z).orthonormalized()
		object.transform.basis = new_basis
	
	var d = object.global_position - global_position
	object.global_position -= d
	object.rotate(rotation_axis, angle)
	object.global_position += d.rotated(rotation_axis, angle)

func _on_gravity_field_body_entered(body):
	if body == self:
		return
	if body is Player:
		if not body.set_cog(self):
			return
		print(body)
		objects_on_planet.append(body)

func extrude_body(body):
	if not body is Player:
		return
	for i in range(len(objects_on_planet)):
		if body == objects_on_planet[i]:
			print("renoied")
			objects_on_planet.remove_at(i)
			body.set_cog(null)

func _on_gravity_field_body_exited(body):
	# extrude_body(body)
	return
