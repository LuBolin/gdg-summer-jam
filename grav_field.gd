extends Area3D

@export var force = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var areas = get_overlapping_bodies()
	for area in areas:
		if area is CharacterBody3D:
			area.set_cog(self)

func get_force():
	return force

