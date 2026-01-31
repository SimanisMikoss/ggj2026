extends Camera3D
class_name CameraController

var end_screen = preload("res://scenes/end_screen.tscn")
@export var ray_length := 10.0
var has_valid_interactable: bool = false
var interactable

var hands

var has_mask: bool = false
var item_in_hands: MaskPickup
var item_in_hands_visual: TextureRect

#health
var player_life: int
var player_max_life: int = 100
signal player_damaged()

func _ready():
	hands = get_node("%Hands") 
	player_life = player_max_life
	show_hands(false)

func _physics_process(_delta):
	check_for_interactable()
	if Input.is_action_just_pressed("interact"):
		interact()
		
func damage_player(amount: int):
	if (player_life <= 0):
		return
	print("taking damage amount:", amount)
	player_life -= amount
	player_damaged.emit()
	if (player_life <= 0):
		player_life = 0
		print("game over")
		end_game()
		
func end_game(victory = false):
	Global.input_allowed = false
	var end_screen_instance = end_screen.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.show_end_screen(victory)

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
			if (has_valid_interactable):
				interactable.process_raycast_change(false)
				try_show_interact_label(false)
			has_valid_interactable = true
			interactable = collider
			interactable.process_raycast_change(true)
			try_show_interact_label(true, interactable) # for characters
	else:
		if has_valid_interactable == true:
			interactable.process_raycast_change(false)
		has_valid_interactable = false
		try_show_interact_label(false) #for characters

func interact():
	if has_valid_interactable == true:
		interactable.interact(self)
		has_valid_interactable = false
	else:
		try_drop_mask()
		
func pickup_mask(mask: Node3D):
	print("player has mask")
	try_drop_mask()
	has_mask = true
	item_in_hands = mask
	mask.visible = false
	show_hands(true)
	
func try_remove_mask(remover: Node3D):
	print("player try remove mask")
	if has_mask:
		remover.try_equip_mask(self, item_in_hands)
		
func remove_mask(remover: Node3D):
	print("player remove mask")
	remover.equip_mask(self, item_in_hands)
	has_mask = false
	show_hands(false)
	
func try_show_interact_label(show: bool, interactable = null):
	if show and interactable.has_method("try_equip_mask"):
		hands.interact_text.visible = true
	else:
		hands.interact_text.visible = false
	
func show_hands(show: bool):
	hands.visible = show
	if show:
		hands.item_visual.texture = item_in_hands.mask_texture
		
func try_drop_mask():
	print("try drop mask")
	if has_mask == false:
		return
		
	has_mask = false
	show_hands(false)
	item_in_hands.visible = true
	item_in_hands.drop()
	
func is_carrying_right_mask(required_mask_id: int)-> bool:
	if (has_mask and item_in_hands.mask_id == required_mask_id):
		return true
	return false
	
