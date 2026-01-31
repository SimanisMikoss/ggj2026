extends Area3D

var interactable: bool = true

#references
var target_node : Node3D 
var character_mask: Sprite3D

var preferred_mask_id: int

func _ready():
	character_mask = get_node("%CharacterMask") 
	target_node = get_node("%HeadText") 
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

func process_raycast_change(hit: bool):
	if hit == true:
		return

func interact(interactor: Node3D):
	if interactable == false:
		return
	interactor.try_remove_mask(self)
	
func try_equip_mask(player: Node3D, mask: Node3D):
	player.remove_mask(self)
	if mask != null:
		print("todo check if mask is correct")
	
func equip_mask(mask: Node3D):
	interactable = false
	character_mask.texture = mask.mask_texture
	character_mask.visible = true
	
func set_preferred_mask(mask_id: int):
	preferred_mask_id = mask_id
	print("set preferred mask id")
