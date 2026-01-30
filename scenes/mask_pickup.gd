extends Area3D

var interactable: bool = true
var target_node : Node3D 

func _ready():
	interactable = true
	target_node = get_node("%MaskPickupSprite") 

# Called when the node enters the scene tree for the first time.
func interact(interactor: Node3D):
	print("try interact")
	if interactable == false:
		return
	interactable = false
	self.reparent(interactor, true)
	
	
