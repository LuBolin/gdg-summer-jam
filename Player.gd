extends CharacterBody3D


const SPEED = 1.0
const JUMP_VELOCITY = 1.5
const turn_rate = 30
var yvel = 0

var cog : Node3D


func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (Vector3(-input_dir.x, 0, input_dir.y)).normalized()
	#print(direction) #up z -1, left x -1
	
	if cog:
		var gravity_vector = cog.position - position
		if not gravity_vector.normalized().is_equal_approx(transform.basis.y):
			var new_basis = Basis(gravity_vector.cross(transform.basis.z).normalized(), -gravity_vector.normalized(), transform.basis.z).orthonormalized()
			transform.basis = new_basis
			#transform.basis = transform.basis.slerp(new_basis, 10).orthonormalized()
			#transform.basis = transform.basis.looking_at(-transform.basis.z, -gravity_vector)
		
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
	move_and_slide()
	
	#if cog:
		##gravity thing here
		#var gravity_vector = cog.position - position
		#var cross = gravity_vector.cross(up_vector).normalized()
		#var angle = PI - up_vector.signed_angle_to(gravity_vector, cross)
		#up_vector = -gravity_vector.normalized()
		#front_vector = (front_vector - (front_vector.dot(up_vector)) * up_vector.normalized()).normalized()
		#if not is_on_planet():
			#velocity += (cog.position - position).normalized() * 5 * delta
	#if direction:
		#front_vector = front_vector.rotated(up_vector, turn_rate * delta * direction.x)
	#print(is_on_planet())
	#$vectorup.look_at((up_vector) * 10)
	#look_at(front_vector + position)
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#move_and_slide()
	## Handle jump.

func get_velocity_basis(vector):
	return Vector3(vector.x * transform.basis.x + vector.y * transform.basis.y + vector.z * transform.basis.z)


func is_on_planet():
	if cog == null or $RayCast3D.get_collider() == null:
		return false
	return $RayCast3D.get_collider().get_parent() == cog

func set_cog(planet):
	cog = planet
	






	
