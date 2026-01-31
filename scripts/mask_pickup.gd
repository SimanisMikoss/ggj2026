extends Area3D
class_name MaskPickup
var mask_id
@export var pickup_offset: Vector3

#timer
var has_timer: bool = false

#stats
var interactable: bool = true
var mask_texture: Texture2D

#references
var target_node : Sprite3D 
var interact_text: Label3D
var collision_shape: CollisionShape3D
var original_parent

func _ready():
	interactable = true
	interact_text = get_node("%InteractText") 
	target_node = get_node("%MaskPickupSprite") 
	mask_texture = target_node.texture
	collision_shape = get_node("CollisionShape3D")
	original_parent = self.get_parent()
	
func show_interact_prompt(show_prompt: bool):
	interact_text.visible = show_prompt;
	if show_prompt == false:
		has_timer = false
	
func process_raycast_change(hit: bool):
	if hit == true and interactable == true:
		#show_interact_prompt(true)
		#try_add_timer()
		show_interact_prompt(true)
	else:
		show_interact_prompt(false)

func try_add_timer():
	if has_timer == true:
		return
	has_timer = false;
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = 1.0
	timer.start()
	timer.timeout.connect(Callable(self, "show_interact_prompt").bind(false))		

# Called when the node enters the scene tree for the first time.
func interact(interactor: Node3D):
	print("try interact")
	if interactable == false:
		return
	enable_interactions(false)
	#PICK UP MASK ON PLAYER
	interactor.pickup_mask(self)
	self.position += pickup_offset

func enable_interactions(enable: bool):
	interactable = enable
	collision_shape.visible = enable
	self.monitorable = enable
	self.monitoring = enable
	show_interact_prompt(false)
	
func change_visuals(new_texture: Texture2D):
	target_node.texture = new_texture
	mask_texture = target_node.texture
	
func drop():
	print("mask is dropped")
	enable_interactions(true)
	#parent.remove_child(self)
	target_node.visible = true
