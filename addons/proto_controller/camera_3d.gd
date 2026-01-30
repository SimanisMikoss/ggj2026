extends Camera3D

@export var ray_length := 1000.0

func _physics_process(_delta):
	if Input.is_action_just_pressed("interact"):
		interact()

func interact():
	var mouse_pos = get_viewport().get_mouse_position()
	var origin = project_ray_origin(mouse_pos)
	var direction = project_ray_normal(mouse_pos)

	var query = PhysicsRayQueryParameters3D.create(
		origin,
		origin + direction * ray_length
	)

	query.collide_with_areas = true

	var result = get_world_3d().direct_space_state.intersect_ray(query)

	if result:
		var collider = result.collider
		print("Hit:", collider.name)

		if collider.has_method("interact"):
			collider.interact(self)
