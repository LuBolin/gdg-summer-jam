extends CharacterBody3D


const SPEED = 1.0
const JUMP_VELOCITY = 4.5
const turn_rate = 30

var up_vector : Vector3 = Vector3(0, 1, 0)
var front_vector : Vector3 = Vector3(1, 0, 0)

var cog : Node3D

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#print(direction) #up z -1, left x -1
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	
	if cog:
		#gravity thing here
		var gravity_vector = cog.position - position
		var cross = gravity_vector.cross(up_vector).normalized()
		var angle = PI - up_vector.signed_angle_to(gravity_vector, cross)
		print(angle)
		up_vector = up_vector.rotated(cross, angle * delta)
		front_vector = front_vector.rotated(cross, angle * delta)
		if not is_on_planet():
			velocity += (cog.position - position).normalized() * 2 * delta

	look_at(front_vector - position)
	move_and_slide()
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY




func is_on_planet():
	if cog == null:
		return false
	return $RayCast3D.get_collider() == cog

func set_cog(planet):
	cog = planet
