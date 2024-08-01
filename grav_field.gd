extends Area3D

@export var force = 5
@export var planet_field_ratio = 0.5
@export var rot_period = 40 #seconds it takes to make a full rotation on its pole

# Called when the node enters the scene tree for the first time.
func _ready():
	#force set scale upon ready
	$CollisionShape3D.scale = $".".scale
	$PlanetRigidBody/CollisionShape3D.scale = $".".scale * planet_field_ratio
	$PlanetRigidBody/MeshInstance3D.scale = $".".scale * planet_field_ratio
	self.scale = Vector3(1,1,1)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#planet_rotation(delta) #uncomment to enable daynight cycle
	position.x += 0.3 * delta #change accordingly
	
	var areas = get_overlapping_bodies()
	for area in areas:
		if area is CharacterBody3D:
			area.set_cog(self)
			area.reparent(self) #this does not look very safe
			
func get_force():
	return force
	
	
func planet_rotation(time): #tries to rotate based on rot_period
	if rot_period:
		rotate(basis.y.normalized(),  (2*PI)/(rot_period/time))
	else:
		pass

