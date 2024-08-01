extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape3D.scale =  $"..".scale * $"..".planet_field_ratio
	$MeshInstance3D.scale = $"..".scale * $"..".planet_field_ratio
	# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
