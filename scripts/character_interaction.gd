extends Area3D

var interactable: bool = true
var player_detection_area: Area3D

#references
var target_node : Node3D 
var character_mask: Sprite3D

var preferred_mask_id: int
var visuals: CharacterVisuals

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
	
func try_equip_mask(player: Node3D, mask: Node3D):
	if (mask.mask_id != preferred_mask_id):
		print("i don't like this mask with id", mask.mask_id, ",i want ", preferred_mask_id)
		player.damage_player(33)
		return;
	else:
		player.remove_mask(self)
	
func equip_mask(mask: Node3D):
	interactable = false
	visuals.change_animation("default")
	character_mask.texture = mask.mask_texture
	character_mask.visible = true
	
func set_preferred_mask(mask_id: int):
	preferred_mask_id = mask_id
	print("set preferred mask id to ", preferred_mask_id)
