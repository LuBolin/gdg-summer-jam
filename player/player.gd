class_name Player
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 5
const turn_rate = 30
var yvel = 0

var cog : Node3D

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (Vector3(-input_dir.x, 0, input_dir.y)).normalized()
	
	if cog:
		
		if not is_on_planet():
			if cog:
				yvel -= delta * cog.get_force()
			else:
				yvel -= delta 
		else:
			yvel = 0
			if Input.is_action_just_pressed("ui_end"):
				yvel = JUMP_VELOCITY
	#print(basis)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	velocity = get_velocity_basis(Vector3(velocity.x, yvel, velocity.z))
	#velocity = Vector3(0, yvel, 0)
	move_and_slide()
	

func get_velocity_basis(vector):
	return Vector3(vector.x * transform.basis.x + vector.y * transform.basis.y + vector.z * transform.basis.z)


func is_on_planet():
	if cog == null or $RayCast3D.get_collider() == null:
		return false
	return $RayCast3D.get_collider() == cog

func apply_planet_rotation(planet, axis, rot, tl, time):
	if not is_on_planet():
		return
	var vector = global_position - planet.global_position
	var length = vector.length()
	vector = vector.rotated(axis, (2*PI)/(rot))
	velocity = (vector - (global_position - planet.global_position))
	move_and_slide()

func set_cog(planet):
	if planet == null:
		cog = planet
		return true
	if cog == null:
		yvel = 0
		cog = planet
		return true
	return false
