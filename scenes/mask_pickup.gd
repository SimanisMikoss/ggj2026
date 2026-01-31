extends Area3D

@export var pickup_offset: Vector3

#stats
var interactable: bool = true
var mask_texture: Texture2D

#references
var target_node : Sprite3D 
var interact_text: Label3D
var collision_shape: CollisionShape3D

func _ready():
	interactable = true
	interact_text = get_node("%InteractText") 
	target_node = get_node("%MaskPickupSprite") 
	mask_texture = target_node.texture
	collision_shape = get_node("CollisionShape3D")
	
func show_interact_prompt(show_prompt: bool):
	interact_text.visible = show_prompt;
	
func process_raycast_change(hit: bool):
	if hit == true and interactable == true:
		show_interact_prompt(true)
	else:
		show_interact_prompt(false)

# Called when the node enters the scene tree for the first time.
func interact(interactor: Node3D):
	print("try interact")
	if interactable == false:
		return
	enable_interactions(false)
	#PICK UP MASK ON PLAYER
	self.reparent(interactor, true)
	interactor.pickup_mask(self)
	self.position += pickup_offset

func enable_interactions(enable: bool):
	interactable = enable
	collision_shape.visible = enable
	show_interact_prompt(false)
