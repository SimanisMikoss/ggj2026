extends Camera3D

@export var ray_length := 1000.0
var has_valid_interactable: bool = false
var interactable

func _physics_process(_delta):
	check_for_interactable()
	if Input.is_action_just_pressed("interact"):
		interact()

func check_for_interactable():
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
		if collider.has_method("interact"):
			has_valid_interactable = true
			interactable = collider
			interactable.process_raycast_change(true)
	else:
		if has_valid_interactable:
			interactable.process_raycast_change(false)
		has_valid_interactable = false

func interact():
	if has_valid_interactable == true:
		interactable.interact(self)
