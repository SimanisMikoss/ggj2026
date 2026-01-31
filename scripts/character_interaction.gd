extends Area3D

@export var damage_player_delay: float
var interactable: bool = true
var player_detection_area: Area3D

#references
var target_node : Node3D 
var character_mask: CharacterMask

var preferred_mask_id: int
var visuals: CharacterVisuals

var player_controller : CameraController
var player_controller_set: bool = false
var has_mask: bool = false

func _ready():
	visuals = get_node("CharacterVisuals")
	character_mask = get_node("%CharacterMask") 
	target_node = get_node("%HeadText") 
	
	player_detection_area = get_node("%PlayerDetectionArea")
	player_detection_area.body_entered.connect(on_player_entered)
	player_detection_area.body_exited.connect(on_player_exited)
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	character_mask.visible = false

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		target_node.visible = true
		target_node.process_mode = Node.PROCESS_MODE_INHERIT

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		target_node.visible = false
		target_node.process_mode = Node.PROCESS_MODE_DISABLED
		
func on_player_entered(body: Node3D)-> void:
	if (body.has_method("temp") and body.player_manager.is_carrying_right_mask(preferred_mask_id) == false):
		body.temp()
		if (player_controller_set == false):
			player_controller = body.player_manager
			player_controller.connect("player_damaged",_on_player_damaged)
			player_controller_set = true
		if(has_mask == false):
			visuals.change_animation("angry")
	print("player detected in monster zone")

func on_player_exited(body: Node3D)-> void:
	visuals.change_animation("default")
	print("player exited monster zone")
	
func process_raycast_change(hit: bool):
	if hit == true:
		return

func interact(interactor: Node3D):
	if interactable == false:
		return
	interactor.try_remove_mask(self)
	
func _on_player_damaged():
	visuals.change_animation("angry")
	return

func try_equip_mask(player: Node3D, mask: Node3D):
	if (mask.mask_id != preferred_mask_id):
		print("i don't like this mask with id", mask.mask_id, ",i want ", preferred_mask_id)
		visuals.change_animation("attack")
		start_damage_player_timer(player)
		return;
	else:
		player.remove_mask(self)
		
func start_damage_player_timer(player):
	await get_tree().create_timer(damage_player_delay).timeout
	
	# This line runs only after the 2 seconds have passed
	_on_damage_player_timer_finished(player)

func _on_damage_player_timer_finished(player):
	print("Timer finished! Calling the method now.")
	player.damage_player(33)
	
func equip_mask(player, mask: Node3D):
	interactable = false
	has_mask = true
	visuals.change_animation("default")
	character_mask.texture = mask.mask_texture
	character_mask.visible = true
	character_mask.start_follow_player(player)
	
func set_preferred_mask(mask_id: int):
	preferred_mask_id = mask_id
	print("set preferred mask id to ", preferred_mask_id)
